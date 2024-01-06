import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '753383357173-e2pqr9f4bnfuv1p94oqekvu51u3o1qbu.apps.googleusercontent.com',
  );

  // Google sign in
  Future<User?> handleSignIn() async {
    try {
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential authResult =
            await _auth.signInWithCredential(credential);
        User? user = authResult.user;

        // Set the photo URL if available
        if (googleUser.photoUrl != null) {
          await user?.updatePhotoURL(googleUser.photoUrl!);
        }

        return user;
      } else {
        // Handle the case where the user cancels the sign-in process
        print("User canceled sign-in");
        return null;
      }
    } catch (e) {
      print("Error signing in with Google $e");
      return null;
    }
  }

  // Google sign out
  Future<void> handleSignOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print("Error signing out $e");
    }
  }

  // Get authenticated user
  User? get currentUser => _auth.currentUser;

  Future<bool> isSignInResultValid(User? user) async {
    if (user != null) {
      // Check if the user has the required attributes or roles
      if (user.displayName != null && user.email != null) {
        // Additional validation logic can be added here
        // For example, check if the user is an administrator or has certain roles
        // Replace this with your actual validation criteria
        return true;
      }
    }
    return false;
  }
}
