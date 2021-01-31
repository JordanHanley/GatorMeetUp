import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventMarker extends Marker {
  String title;
  String description;
  String time;
  Timestamp timeStamp;
  String creatorUID;
  int numRSVP;
  EventMarker(
      MarkerId eventId,
      LatLng position,
      String title,
      String description,
      String time,
      Timestamp timeStamp,
      String creatorUID,
      VoidCallback tap,
      int numRSVP)
      : super(
          markerId: eventId,
          position: position,
          onTap: tap,
        ) {
    this.title = title;
    this.description = description;
    this.time = time;
    this.timeStamp = timeStamp;
    this.creatorUID = creatorUID;
    this.numRSVP = numRSVP;
  }

  // void createPopupWindow() {}
}

/*

--- Marker Constructor ---
const Marker({
    @required this.markerId,
    this.alpha = 1.0,
    this.anchor = const Offset(0.5, 1.0),
    this.consumeTapEvents = false,
    this.draggable = false,
    this.flat = false,
    this.icon = BitmapDescriptor.defaultMarker,
    this.infoWindow = InfoWindow.noText,
    this.position = const LatLng(0.0, 0.0),
    this.rotation = 0.0,
    this.visible = true,
    this.zIndex = 0.0,
    this.onTap,
    this.onDragEnd,
  }) : assert(alpha == null || (0.0 <= alpha && alpha <= 1.0));
*/
