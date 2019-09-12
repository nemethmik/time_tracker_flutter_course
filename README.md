# Time Tracker Flutter Course

This project is my remake of Andrea Bizzotto's [Time Tracker Flutter Course](https://github.com/bizz84/time_tracker_flutter_course) on Udemy.

I started this project by downloading lecture 149 of section 8 (08.16-user-auth-class.zip).
This was the version just before section 9, where the instructor started explaining streams.

## 0910 Application Logic Branch
In the original version the separation of concerns was not clean. The UI classes directly called business/application logic operations.
In this version I refactored significantly the application architecture by introducing the concept of application logic component. In his stream-based version in section 9 the instructor used the **Auth** class implementing the **AuthBase** abstract class/interface. So, in my version here, I extended the AuthBase interface with event handlers as well as introduced and UI commands. 
In a more complete case application logic component is a separate class, here, for the sake of simplicity I used Auth as the AL component.

In tis application the Auth object is passed along to all the three widgets, langing, login and home as parameter, but it would have been necessary, a global service locator would be perfectly fine to get the singleton instance of the AL controller. That way, the problem of cascade-passing objects down the widget tree is not necessary. Check out how the popular [get_it package](https://pub.dev/packages/get_it) works, it is just a fancy sattic global hash-table of global mostly singleton objects.

When you have an application logic controller it becomes responsible for all business logic interactions. The UI objects simply notify the application logic component of events like onSignOut, onCheckCurrentUser, and so on and forth. The AL component performs the necessary actions, typically calling business logic services, then via the UICommandsIntf sends instructions to the UI what to do. In this sample, landing page was the only stateful widget, actually its state class registered itself as a listener to instructions from the AL component.

### What is then the major difference between set-state driven and stream driven architectures?
As explained above, with clean separation of concerns, nice application architectures can be made with simple tools like set-states and stateful widgets, too. 
This solution as I demonstrated here is a **reactive** approach, too; when the state class of the landing page's stateful widget was registered itself on the application logic controller, actually it became a listener. However, streams are a lot more versatile for this kind of reactive programming. So, the natural next step from this application logic controller solution presented here is using streams for communications, and stream builders to react "application logic instructions".
This is a fundamental part of MVVM architectures, where UI objects are listening to view-model objects. This MVVM architecture was brilliantly elaborated in Xamarin Forms, Android Architecture Components with Live Data, Data Binding and View Models, too. The Change Notifier machinery of the Flutter provider package is not based on streams but follows this reactive pattern, either.
So, with my example I just wanted to demonstrate that **reactive architecture is absolutely possible with simple tools like set-state and stateful widgets**.

An [accompanying video](https://youtu.be/fpwh9eGqtBk) explains all these in detail.

## 0911 Auth Stream Branch

In this version the communication from the application logic controller towards the UI was changed over to a stream. This example is not really clean since the event streams shoud be clearly differentiated from data streams, just like in Android Architecture with Live Data. So, with the introduction of streams, practically my AL component became exactly the same as a BloC.

In this architecture the UI sends evants via function calls, which is perfectly fine, since that direction of dependency is totally OK, the UI is allowed to know the exact interface of the AL. I don't see any benefit of defining a stream to send event messages from the UI to AL. It would be absolutely possible, and it would be totally OK, too. On the other hand, using streams to send data as well as instructions to UI is perfectly fine. 

The accompanying video is [Flutter 92 Time Tracker with Application Layer Applying Auth Stream](https://youtu.be/Bimbj2EHlA8)

# Fake FirebaseAuth Implementation
Since I have zero interest in Firebase, I removed all Firebase references from the project reversing the configuration explained in [lecture 119](https://www.udemy.com/course/flutter-firebase-build-a-complete-app-for-ios-android/learn/lecture/13910906).

Thereafter I added this section to the auth.dart file.

```dart
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
```
Note that I simulate lengthy operation by adding 1 second delay to each method.

# Using Tags with Visual Studio
Instead of branches Andrea used tags in his repository. VSC supports tags excellently, too, but I didn't see any benefit of tags vs branches, so I continue using branches.
