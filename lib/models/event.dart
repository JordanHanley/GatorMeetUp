import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Event {
  MarkerId eventID;
  LatLng position;
  String title;
  String description;
  String time;
  Timestamp timeStamp;
  String creatorUID;
  int numRSVP;

  Event(
      {this.eventID,
      this.position,
      this.title,
      this.description,
      this.time,
      this.timeStamp,
      this.creatorUID,
      this.numRSVP});
}
