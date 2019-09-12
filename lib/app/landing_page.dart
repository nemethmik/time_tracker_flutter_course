import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home_page.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class LandingPage extends StatefulWidget {
  LandingPage({@required this.auth});
  final AuthBase auth;
  @override
  _LandingPageState createState() => _LandingPageState();
}
// Stateful widgets should implement UICommands directly or via mixins
// The application logic component (auth in this example) sends instructions to the UI what to do
class _LandingPageState extends State<LandingPage>/*  implements UICommandsIntf*/ {

  // User _user;
  @override void dispose() {
    super.dispose();
    widget.auth.dispose();
  }
  @override
  void initState() {
    super.initState();
    // It is very important to register a stateful widget as 
    // the recipient of instructions from the application logic components    
    // widget.auth.registerScreen(this);
    widget.auth.onCheckCurrentUser();
  }
  // A command from the application logic component to update the state
  // @override
  // void updateUser(User user) {
  //   setState(() {
  //     _user = user;
  //   });
  // }
  // An error occured during some operations, please, inform the user
  // @override
  // void error(e) {
  //     print(e.toString());
  // }
  // The application logic controller is passed along to all pages and screens,
  // but it's not necessary, since a static global singleton could be used, too.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: widget.auth.onAuthStateChanged,
      builder: (context,snapshot){
        var progressIndicator = Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
        if(snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data == null) {
            return SignInPage(auth: widget.auth,);
          } else {
            // Authentication or logout process has been started
            if(snapshot.data.uid == null) {
              return progressIndicator;  
            } else {
              return HomePage(auth: widget.auth,);
            }
          }
        } else {
          return progressIndicator;
        }
      },
    );
  }
}
