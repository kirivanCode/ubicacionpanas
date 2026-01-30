import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/location_realtime_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LocationRealtimeService _locationService =
      LocationRealtimeService();

  GoogleMapController? _mapController;
  bool tracking = false;

  LatLng _currentPosition =
      const LatLng(4.710989, -74.072092); // Bogotá default

  void toggleTracking() {
    if (tracking) {
      _locationService.stopTracking();
    } else {
      _locationService.startTracking(
        onLocationChanged: (lat, lng) {
          final newPosition = LatLng(lat, lng);

          setState(() {
            _currentPosition = newPosition;
          });

          _mapController?.animateCamera(
            CameraUpdate.newLatLng(newPosition),
          );
        },
      );
    }

    setState(() {
      tracking = !tracking;
    });
  }

  @override
  void dispose() {
    _locationService.stopTracking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ubicación en tiempo real')),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 16,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: (controller) {
                _mapController = controller;
              },
              markers: {
                Marker(
                  markerId: const MarkerId('me'),
                  position: _currentPosition,
                  infoWindow: const InfoWindow(title: 'Mi ubicación'),
                ),
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  tracking
                      ? '📡 Compartiendo ubicación'
                      : '⏸️ Ubicación detenida',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: toggleTracking,
                  child:
                      Text(tracking ? 'Detener' : 'Compartir ubicación'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
