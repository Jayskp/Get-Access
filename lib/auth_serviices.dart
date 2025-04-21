import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  static const String _isLoggedInKey = "isLoggedIn";
  static const String _initialQuestionShownKey = "initialQuestionShown";
  static const String _userIdKey = "userId";
  static const String _userEmailKey = "userEmail";
  static const String _userPhoneKey = "userPhone";

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Check if the user is logged in
  static Future<bool> isLoggedIn() async {
    // Check Firebase Auth first
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      return true;
    }

    // Fallback to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Sign in with email
  static Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      // Sign in or create user if not exists
      UserCredential userCredential;
      try {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          // Create new user if not exists
          userCredential = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          // Save user info to Realtime Database
          await _database.child('Users').child(userCredential.user!.uid).set({
            'Email': email,
            'createdAt': ServerValue.timestamp,
          });
        } else {
          rethrow;
        }
      }

      // Save to SharedPreferences
      await _saveUserDataToPrefs(
          userCredential.user!.uid,
          email: email
      );

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with phone
  static Future<void> signInWithPhone(
      String phoneNumber,
      Function(PhoneAuthCredential) verificationCompleted,
      Function(FirebaseAuthException) verificationFailed,
      Function(String, int?) codeSent,
      Function(String) codeAutoRetrievalTimeout,
      ) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: '+91$phoneNumber',
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: (String verificationId, int? forceResendingToken) {
        // Log the verification ID or update the UI accordingly
        print("Verification ID received: $verificationId");
        codeSent(verificationId, forceResendingToken);
      },
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  // Verify phone code and sign in the user, then store phone number in the database
  static Future<UserCredential> verifyPhoneCode(String verificationId, String smsCode, String phoneNumber) async {
    try {
      // Create credential
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode
      );

      // Sign in with credential
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Save user info to Realtime Database
      await _database.child('Users').child(userCredential.user!.uid).set({
        'Phone no.': phoneNumber,
        'createdAt': ServerValue.timestamp,
      });

      // Save to SharedPreferences
      await _saveUserDataToPrefs(
          userCredential.user!.uid,
          phone: phoneNumber
      );

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Save user data to SharedPreferences
  static Future<void> _saveUserDataToPrefs(String userId, {String? email, String? phone}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userIdKey, userId);

    if (email != null) {
      await prefs.setString(_userEmailKey, email);
    }

    if (phone != null) {
      await prefs.setString(_userPhoneKey, phone);
    }
  }

  // Set login state (for compatibility with existing code)
  static Future<void> login() async {
    // This method is kept for backward compatibility
    // It should not be used for actual authentication
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
  }

  // Set logout state
  static Future<void> logout() async {
    // Sign out from Firebase
    await _auth.signOut();

    // Clear preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }



  // Get current user
  static Future<Map<String, dynamic>> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userId': prefs.getString(_userIdKey),
      'email': prefs.getString(_userEmailKey),
      'phone': prefs.getString(_userPhoneKey),
    };
  }
}