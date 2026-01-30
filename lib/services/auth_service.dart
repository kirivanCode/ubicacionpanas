import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // REGISTRO
  Future<User?> register(String email, String password) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } catch (e) {
      throw e.toString();
    }
  }

  // LOGIN
  Future<User?> login(String email, String password) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } catch (e) {
      throw e.toString();
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }

  // USUARIO ACTUAL
  User? get currentUser => _auth.currentUser;
}
