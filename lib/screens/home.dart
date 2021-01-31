import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gator_meet_up/models/event.dart';
import 'package:gator_meet_up/models/event_marker.dart';
import 'package:gator_meet_up/services/auth.dart';
import 'package:gator_meet_up/services/database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:uuid/uuid.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthService _auth = AuthService();
  bool addModeOn = false;
  Set<EventMarker> _markers = Set<EventMarker>();
  String uid = FirebaseAuth.instance.currentUser.uid;
  final _scaffoldKey = GlobalKey<ScaffoldState>(); // necessary for the snackbar
  Set<EventMarker> testMarkers = Set<EventMarker>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Meet Up"),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(250, 70, 22, 1),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  _auth.signOutUser();
                })
          ],
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: LatLng(29.6436, -82.3549), zoom: 15),
              markers: _markers,
              onMapCreated: _onMapCreated,
              onTap: (LatLng point) async {
                if (addModeOn) {
                  _showCreatePopup(point, context);
                }
              },
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FloatingActionButton(
                    child: Icon(addModeOn ? Icons.add : Icons.public),
                    onPressed: () {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(addModeOn
                              ? "Event View Mode: Enabled"
                              : "Event Create Mode: Enabled")));
                      setState(() => addModeOn = !addModeOn);
                    },
                  ),
                  SizedBox(width: 20),
                  FloatingActionButton(
                    child: Icon(Icons.refresh),
                    onPressed: () async {
                      _refreshMapEventMarkers();
                    },
                  )
                ],
              ),
            )
          ],
        ));
  }

  void _onMapCreated(GoogleMapController controller) {
    _refreshMapEventMarkers();
  }

  void _refreshMapEventMarkers() async {
    List<Event> temp = await DatabaseService(uid: uid).getEventList();
    List<EventMarker> markers = List<EventMarker>();
    for (Event event in temp) {
      VoidCallback callback = () {
        showEventPopup(event.title, event.description, event.time,
            event.numRSVP, event.eventID.toString(), context);
      };
      markers.add(EventMarker(
          event.eventID,
          event.position,
          event.title,
          event.description,
          event.time,
          event.timeStamp,
          event.creatorUID,
          callback,
          event.numRSVP));
    }

    setState(() {
      _markers = Set.of(markers);
    });
  }

  void _showCreatePopup(LatLng point, context) {
    String title = "";
    String description = "";
    String time = "";
    Alert(
        context: context,
        title: "New Event",
        content: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.contact_support),
                labelText: 'Title',
              ),
              onChanged: (val) => title = val,
            ),
            TextField(
              decoration: InputDecoration(
                helperMaxLines: 2,
                icon: Icon(Icons.assignment_ind_rounded),
                labelText: 'Description',
              ),
              onChanged: (val) => description = val,
            ),
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.query_builder),
                labelText: 'Time',
              ),
              onChanged: (val) => time = val,
            ),
          ],
        ),
        buttons: [
          DialogButton(
            color: Color.fromRGBO(250, 70, 22, 1),
            onPressed: () async {
              VoidCallback callback = () {
                showEventPopup(title, description, time, 1, null, context);
              };

              // add to the user's screen so it instantly pops up when they add
              EventMarker newMarker = EventMarker(
                  MarkerId(Uuid().v4()),
                  point, // generate random id for the marker, no document id has been generated yet
                  title,
                  description,
                  time,
                  Timestamp.now(),
                  uid,
                  callback,
                  0);
              setState(() {
                _markers.add(newMarker);
              });
              // create the new event in the database
              Map<String, dynamic> data = {
                "coordinates": GeoPoint(point.latitude, point.longitude),
                "timeStamp": Timestamp.now(),
                "creator": uid,
                "title": title,
                "description": description,
                "time": time,
                "numRSVP": 1
              };
              DatabaseService(uid: uid).createNewEvent(data);
              Navigator.pop(context);
            },
            child: Text(
              "CREATE",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  void showEventPopup(String title, String description, String time,
      int numRSVP, String eventID, BuildContext context) {
    Dialog dialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 50,
              alignment: Alignment.center,
              color: Colors.lightBlue,
              child: Text(title,
                  style: TextStyle(color: Colors.white, fontSize: 30)),
            ),
            Expanded(
              child: Container(
                color: Color.fromRGBO(250, 70, 22, 1),
                child: SizedBox.expand(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Icon(Icons.notes),
                        Text(
                          " " + description,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.query_builder),
                            Text(" " + time,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25))
                          ],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.person),
                              Text(
                                " $numRSVP",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30),
                              )
                            ]),
                        Container(
                          alignment: Alignment.bottomCenter,
                          child: RaisedButton(
                            color: Colors.white,
                            child: Text('RSVP'),
                            onPressed: () => {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content:
                                      Text("You registered for this event!"))),
                              Navigator.of(context).pop()
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
    showDialog(context: context, child: dialog);
  }
}
