import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<String> createGroup() async {
    final user = _auth.currentUser!;
    final code = _generateCode();

    await _firestore.collection('groups').doc(code).set({
      'ownerId': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await joinGroup(code);
    return code;
  }

  Future<void> joinGroup(String code) async {
    final user = _auth.currentUser!;
    await _firestore
        .collection('groups')
        .doc(code)
        .collection('members')
        .doc(user.uid)
        .set({
      'email': user.email,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  String _generateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ123456789';
    return List.generate(
      6,
      (_) => chars[DateTime.now().millisecond % chars.length],
    ).join();
  }
}
