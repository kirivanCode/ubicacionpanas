import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiveMapScreen extends StatefulWidget {
  const LiveMapScreen({super.key});

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Set<Marker> _markers = {};

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(4.710989, -74.072090), // Bogotá por defecto
    zoom: 13,
  );

  void _loadMarkers() {
    _firestore.collection('users').snapshots().listen((snapshot) {
      final markers = snapshot.docs.map((doc) {
        final data = doc.data();
        if (data['location'] == null) return null;

        return Marker(
          markerId: MarkerId(doc.id),
          position: LatLng(
            data['location']['lat'],
            data['location']['lng'],
          ),
          infoWindow: InfoWindow(
            title: data['email'] ?? 'Usuario',
          ),
        );
      }).whereType<Marker>().toSet();

      setState(() {
        _markers.clear();
        _markers.addAll(markers);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa en tiempo real')),
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
