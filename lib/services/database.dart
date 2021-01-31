import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gator_meet_up/models/event.dart';
import 'package:gator_meet_up/models/event_marker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference eventsCollection =
      FirebaseFirestore.instance.collection("events");

  Future<void> updateUserData(Map data) async {
    return userCollection.doc(uid).set(data);
  }

  Future<void> createNewEvent(Map data) async {
    return eventsCollection.add(data);
  }

  void markRSVPforEvent(String id) async {
    //eventsCollection.doc(id).get()
  }

  Future getEventList() async {
    QuerySnapshot snap = await eventsCollection.get();
    if (snap == null) {
      return;
    }

    List<Event> markers = List<Event>();
    markers = snap.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      GeoPoint geoPoint = data["coordinates"];
      LatLng position = LatLng(geoPoint.latitude, geoPoint.longitude);
      return Event(
          eventID: MarkerId(doc.id),
          position: position,
          title: data["title"],
          description: data["description"],
          time: data["time"],
          timeStamp: data["timeStamp"],
          creatorUID: data["creator"],
          numRSVP: data["numRSVP"] ?? 5);
    }).toList();

    return markers;
  }
}

/*
QuerySnapshot snap =
        await messagesRef.orderBy("timeStamp", descending: false).get();
    if (snap == null) {
      return;
    }
    List<DefaultMessage> msgList = List<DefaultMessage>();
    msgList = snap.docs.map((doc) {
      print(doc.data()["timeStamp"]);
      return DefaultMessage(
        username: doc.data()["username"],
        message: doc.data()["message"],
        timestamp: doc.data()["timeStamp"],
      );
    }).toList();
    chat.messageList = msgList;
  }
*/
