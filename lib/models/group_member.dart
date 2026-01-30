import 'package:google_maps_flutter/google_maps_flutter.dart';

class GroupMember {
  final String id;
  final String email;
  final LatLng position;

  GroupMember({
    required this.id,
    required this.email,
    required this.position,
  });

  factory GroupMember.fromFirestore(String id, Map<String, dynamic> data) {
    return GroupMember(
      id: id,
      email: data['email'],
      position: LatLng(data['lat'], data['lng']),
    );
  }
}
