import 'dart:async';

//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';

class User {
  User({@required this.uid});
  final String uid;
}
// These are the instructions from the application logic controller
// for the screens to update their state.
// In the app currently only the landing page is stateful.
// Not needed any more, use AuthBase streams, instead
// abstract class UICommandsIntf {
//   void updateUser(User user);
//   void error(dynamic e);
// }
// These are the events coming from the screens.
// It's the job of the application controller to act accordingly,
// and as response, sends instructions to the UI what to do.
abstract class UIEventsIntf {
  // Not needed any more UI listens streams directly of AuthBase
  // void registerScreen(UICommandsIntf screen);
  Future<void> onSignOut();
  Future<void> onSignInAnonymously();
  Future<void> onCheckCurrentUser();
}
//This is going to be promoted as application logic component interface
//to handle events from UI/screens
abstract class AuthBase implements UIEventsIntf {
  // These functions are not the concern of the UI any more, 
  // these are used only by the application logic component, which is Auth in this sample app. 
  // Future<User> currentUser();
  // Future<User> signInAnonymously();
  // Future<void> signOut();
  Stream<User> get onAuthStateChanged;
  dispose();
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
  @override Future<void> onCheckCurrentUser() async {
    User user = await currentUser();
    // screen?.updateUser(user);
  }
  //The user clicked a button/menu to sign in without defining user name
  @override Future<void> onSignInAnonymously() async {
    try {
      User user = await signInAnonymously();
      // screen?.updateUser(user);
    } catch (e) {
      // With this solution no error handling :(
      // screen?.error(e);
    }
  }
  //The user clicked a button/menu to sign out
  @override Future<void> onSignOut() async {
    try {
      await signOut();
      // screen?.updateUser(null);
    } catch (e) {
      // screen?.error(e);
    }
  }
  // UICommandsIntf _screen;
  // UICommandsIntf get screen {
  //   if(_screen == null) throw "No screen registered";
  //   else return _screen;
  // }
  // @override void registerScreen(UICommandsIntf screen) {
  //   _screen = screen;
  // }
  @override Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }
  @override
  dispose() {
    _firebaseAuth.dispose();
  }
}

class FirebaseUser {
  final String uid;
  FirebaseUser(this.uid);
}
class FirebaseAuth {
  static FirebaseAuth instance = FirebaseAuth();
  FirebaseUser signInUser;
  Future<FirebaseUser> signInAnonymously() => Future<FirebaseUser>.delayed(Duration(seconds: 1),() { 
      signInUser = FirebaseUser("1234-5678-6789"); 
      controller.sink.add(signInUser);
      return signInUser;
    });
  Future<FirebaseUser> currentUser() => Future<FirebaseUser>.delayed(Duration(seconds: 1),() => signInUser);
  Future<void> signOut() => Future<void>.delayed(Duration(seconds: 1),(){
      signInUser = null;
      controller.sink.add(signInUser);
    });
  StreamController<FirebaseUser> controller = StreamController.broadcast();
  FirebaseAuth() {
    signOut();
  }
  Stream<FirebaseUser> get onAuthStateChanged => controller.stream;
  dispose(){
    controller.close();
  }
}