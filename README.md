# Time Tracker Flutter Course

This project is my remake of Andrea Bizzotto's [Time Tracker Flutter Course](https://github.com/bizz84/time_tracker_flutter_course) on Udemy.

I started this project by downloading lecture 149 of section 8 (08.16-user-auth-class.zip).
This was the version just before section 9, where the instructor started explaining streams.

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

# Using Tags with Visual Studio
Instead of branches Andrea used tags in his repository.
