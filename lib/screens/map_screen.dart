import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/location_realtime_service.dart';

class MapScreen extends StatefulWidget {
  final String groupCode;

  const MapScreen({
    super.key,
    required this.groupCode,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LocationRealtimeService _locationService =
      LocationRealtimeService();

  GoogleMapController? _mapController;
  bool tracking = false;

  LatLng _myPosition = const LatLng(4.710989, -74.072092); // default Bogotá

  @override
  void initState() {
    super.initState();
    _startTracking();
  }

  void _startTracking() {
    tracking = true;

    _locationService.startTracking(
      groupCode: widget.groupCode,
      onLocationChanged: (lat, lng) {
        final pos = LatLng(lat, lng);

        setState(() {
          _myPosition = pos;
        });

        _mapController?.animateCamera(
          CameraUpdate.newLatLng(pos),
        );
      },
    );
  }

  void _stopTracking() {
    _locationService.stopTracking();
    setState(() {
      tracking = false;
    });
  }

  @override
  void dispose() {
    _locationService.stopTracking();
    super.dispose();
  }

  Set<Marker> _buildMarkers(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      if (!data.containsKey('lat') || !data.containsKey('lng')) {
        return null;
      }

      return Marker(
        markerId: MarkerId(doc.id),
        position: LatLng(data['lat'], data['lng']),
        infoWindow: InfoWindow(
          title: data['email'] ?? 'Usuario',
        ),
      );
    }).whereType<Marker>().toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grupo ${widget.groupCode}'),
        actions: [
          IconButton(
            icon: Icon(tracking ? Icons.pause : Icons.play_arrow),
            onPressed: tracking ? _stopTracking : _startTracking,
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('groups')
            .doc(widget.groupCode)
            .collection('members')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _myPosition,
              zoom: 16,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: _buildMarkers(snapshot.data!),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              tracking ? Icons.location_on : Icons.location_off,
              color: tracking ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 8),
            Text(
              tracking
                  ? 'Compartiendo ubicación'
                  : 'Ubicación detenida',
            ),
          ],
        ),
      ),
    );
  }
}
