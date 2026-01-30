import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class LocationRealtimeService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  StreamSubscription<Position>? _positionStream;

  void startTracking({
    required String groupCode,
    required Function(double lat, double lng) onLocationChanged,
  }) {
    final user = _auth.currentUser;
    if (user == null) return;

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((position) {
      _firestore
          .collection('groups')
          .doc(groupCode)
          .collection('members')
          .doc(user.uid)
          .set({
        'email': user.email,
        'lat': position.latitude,
        'lng': position.longitude,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      onLocationChanged(position.latitude, position.longitude);
    });
  }

  void stopTracking() {
    _positionStream?.cancel();
  }
}
