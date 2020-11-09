import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum LoginStates { loggedIn, loggedOut, loading, error }

class FireBaseAuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

//user login state
  Stream<User> get loggedInUser {
    return auth.authStateChanges().map((user) {
      if (user == null) {
        //  print('User is currently signed out!');
      } else {
        print("last login/creation difference");
        print(user.metadata.lastSignInTime
                .difference(user.metadata.creationTime)
                .inSeconds <
            5);
        /*{
          storeService.adduser(user);
        }*/
        //  print('User is signed in!');
        // print('User ${user.email}');
      }
      return user;
    });
  }

  //signInAnonymously
  signInAnonymously() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      print('Failed signInAnonymously error code: ${e.code}');
      print(e.message);
    }
  }

  //signout
  signOut() async {
    await FirebaseAuth.instance.signOut();
    GoogleSignIn().disconnect();
  }

  //delete my account
  delete() async {
    try {
      await FirebaseAuth.instance.currentUser.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
            'The user must reauthenticate before this operation can be executed.');
      }
    }
  }

//sign in with google
  Future<UserCredential> signInWithGoogle(
      {bool silent = false, Null Function() onError}) async {
    // Trigger the authentication flow
    try {
      GoogleSignInAccount googleUser;
      if (silent)
        googleUser = await GoogleSignIn().signInSilently();
      else
        googleUser = await GoogleSignIn().signIn();
      // Obtain the auth details from the request
      if (googleUser == null) return null;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      // Create a new credential
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      print("exception on login ${e.runtimeType}");
      onError();
      return null;
    }
  }
}
