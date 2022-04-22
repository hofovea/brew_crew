import 'package:brew_crew/model/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //map FirebaseUser to CustomUser
  CustomUser? _customUserFromFirebaseUser(User? user) {
    return user != null ? CustomUser(uid: user.uid) : null;
  }

  //auth change use stream
  Stream<CustomUser?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _customUserFromFirebaseUser(user));
  }

  //sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _customUserFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return _customUserFromFirebaseUser(result.user);
    } catch (e) {
      print(e);
      return null;
    }
  }

//register with email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      await DatabaseService(uid: user!.uid)
          .updateUserData('0', 'New crew member', 100);
      return _customUserFromFirebaseUser(result.user);
    } catch (e) {
      print(e);
      return null;
    }
  }

//sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e);
      return null;
    }
  }
}
