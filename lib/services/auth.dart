import 'dart:async';

//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';

class User {
  User({@required this.uid});
  final String uid;
}

abstract class AuthBase {
  Future<User> currentUser();
  Future<User> signInAnonymously();
  Future<void> signOut();
}

class Auth implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(uid: user.uid);
  }
  Future<User> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }
  Future<User> signInAnonymously() async {
    FirebaseUser user = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(user);
  }
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
class FirebaseUser {
  final String uid;
  FirebaseUser(this.uid);
}
class FirebaseAuth {
  static FirebaseAuth instance = FirebaseAuth();
  FirebaseUser signInUser;
  Future<FirebaseUser> signInAnonymously() => Future<FirebaseUser>.delayed(Duration(seconds: 1)
    ,() { signInUser = FirebaseUser("1234-5678-6789"); return signInUser;});
  Future<FirebaseUser> currentUser() => Future<FirebaseUser>.delayed(Duration(seconds: 1),() => signInUser);
  Future<void> signOut() => Future<void>.delayed(Duration(seconds: 1),(){signInUser = null;});
}