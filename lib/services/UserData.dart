import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

import '../model/user.dart';
import 'Location_service.dart';

class UserDataService {
  double get latitude => _latitude;
  double _latitude = 0;
  Future<void> getLocation(ValueNotifier<String> location) async {
    await LocationService().initialize();
    double? latitude = await LocationService().getLatitude();
    double? longitude = await LocationService().getLongitude();
    if (latitude != null && longitude != null) {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(latitude, longitude);
      String locationString = "";
      if (placemarks.isNotEmpty) {
        final placemark = placemarks[0];
        if (placemark.street != null) {
          locationString += "${placemark.street}, ";
        }
        if (placemark.administrativeArea != null) {
          locationString += "${placemark.administrativeArea}, ";
        }
        if (placemark.locality != null) {
          locationString += "${placemark.locality}, ";
        }
        locationString +=
        "${placemark.postalCode ?? ""}, ${placemark.country}";
      }
      location.value = locationString;
    } else {
      print("Failed to get location");
    }
  }

  Future<void> getRecord(
      ValueNotifier<String> checkIn,
      ValueNotifier<String> checkOut,
      ) async {
    FirebaseFirestore.instance
        .collection("Employee")
        .where("name", isEqualTo: Users.username)
        .get()
        .then((QuerySnapshot snap) {
      if (snap.docs.isNotEmpty) {
        FirebaseFirestore.instance
            .collection("Employee")
            .doc(snap.docs[0].id)
            .collection("Record")
            .doc(DateFormat("d MMMM yyyy").format(DateTime.now()))
            .snapshots()
            .listen((DocumentSnapshot snap2) {
          checkIn.value = snap2['checkIn'] ?? '--/--';
          checkOut.value = snap2['checkOut'] ?? '--/--';
        });
      }
    }).catchError((error) {
      print("Error fetching document: $error");
    });
  }

  Future<void> updateCheckOut(
      ValueNotifier<String> location,
      ValueNotifier<String> checkIn,
      ValueNotifier<String> checkOut,
      ) async {
    await getLocation(location); // Refresh location before updating
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection("Employee")
        .where("name", isEqualTo: Users.username)
        .get();
    DocumentSnapshot snap2 = await FirebaseFirestore.instance
        .collection("Employee")
        .doc(snap.docs[0].id)
        .collection("Record")
        .doc(DateFormat("d MMMM yyyy").format(DateTime.now()))
        .get();
    String checkInValue = DateFormat('hh:mm a').format(DateTime.now());
    if (snap2.exists) {
      String? existingCheckIn = snap2['checkIn'];
      await FirebaseFirestore.instance
          .collection("Employee")
          .doc(snap.docs[0].id)
          .collection("Record")
          .doc(DateFormat("d MMMM yyyy").format(DateTime.now()))
          .update({
        'checkIn': existingCheckIn,
        'checkOut': checkInValue,
        'checkInlocation': location.value,
      });
      checkIn.value = existingCheckIn ?? '--/--';
      checkOut.value = checkInValue;
    } else {
      await FirebaseFirestore.instance
          .collection("Employee")
          .doc(snap.docs[0].id)
          .collection("Record")
          .doc(DateFormat("d MMMM yyyy").format(DateTime.now()))
          .set({
        'date': Timestamp.now(),
        'checkIn': checkInValue,
        'checkOutlocation': location.value,
      });
      checkIn.value = checkInValue;
      checkOut.value = "--/--";
    }
  }
}
