import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  static const String _isLoggedInKey = "isLoggedIn";
  static const String _initialQuestionShownKey = "initialQuestionShown";
  static const String _userIdKey = "userId";
  static const String _userEmailKey = "userEmail";
  static const String _userPhoneKey = "userPhone";
  static const String _lastLoginTimeKey = "lastLoginTime";
  static const String _isAdminKey = "isAdmin";

  // Admin credentials
  static const String adminEmail = "admin@example.com";
  static const String adminPassword = "admin123";

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Check if the user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      // Check Firebase Auth first
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        return true;
      }

      // Fallback to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;

      if (isLoggedIn) {
        // Check if the login session is still valid
        final lastLoginTime = prefs.getInt(_lastLoginTimeKey) ?? 0;
        final now = DateTime.now().millisecondsSinceEpoch;

        // If login was within 30 days, consider it valid
        final thirtyDaysInMillis = 30 * 24 * 60 * 60 * 1000;
        if (now - lastLoginTime < thirtyDaysInMillis) {
          return true;
        } else {
          // Session expired, log out
          await logout();
          return false;
        }
      }

      return false;
    } catch (e) {
      print("Error checking login status: $e");
      return false;
    }
  }

  // Sign in with email
  static Future<UserCredential> signInWithEmail(
    String email,
    String password, {
    bool isSignUp = false,
    bool isAdmin = false,
  }) async {
    try {
      UserCredential userCredential;

      if (isSignUp) {
        // Create new user
        try {
          userCredential = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          // Save user info to Realtime Database
          await _database.child('Users').child(userCredential.user!.uid).set({
            'Email': email,
            'createdAt': ServerValue.timestamp,
          });

          print("New user created: ${userCredential.user?.uid}");
        } on FirebaseAuthException catch (e) {
          if (e.code == 'email-already-in-use') {
            print("Email already in use");
          }
          rethrow;
        }
      } else {
        // Sign in existing user
        try {
          userCredential = await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          print("User signed in successfully: ${userCredential.user?.uid}");
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            print("No user found with this email");
          }
          rethrow;
        }
      }

      // Save to SharedPreferences
      await _saveUserDataToPrefs(
        userCredential.user!.uid,
        email: email,
        isAdmin: isAdmin,
      );

      return userCredential;
    } catch (e) {
      print("Error in signInWithEmail: $e");
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
  static Future<UserCredential> verifyPhoneCode(
    String verificationId,
    String smsCode,
    String phoneNumber,
  ) async {
    try {
      // Create credential
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      // Sign in with credential
      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // Save user info to Realtime Database
      await _database.child('Users').child(userCredential.user!.uid).set({
        'Phone no.': phoneNumber,
        'createdAt': ServerValue.timestamp,
      });

      // Save to SharedPreferences
      await _saveUserDataToPrefs(userCredential.user!.uid, phone: phoneNumber);

      return userCredential;
    } catch (e) {
      print("Error in verifyPhoneCode: $e");
      rethrow;
    }
  }

  // Save user data to SharedPreferences
  static Future<void> _saveUserDataToPrefs(
    String userId, {
    String? email,
    String? phone,
    bool isAdmin = false,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_userIdKey, userId);
      await prefs.setInt(
        _lastLoginTimeKey,
        DateTime.now().millisecondsSinceEpoch,
      );

      if (email != null) {
        await prefs.setString(_userEmailKey, email);
      }

      if (phone != null) {
        await prefs.setString(_userPhoneKey, phone);
      }

      await prefs.setBool(_isAdminKey, isAdmin);

      print(
        "User data saved to preferences. UserId: $userId, Email: $email, Phone: $phone, Admin: $isAdmin",
      );
    } catch (e) {
      print("Error saving user data to prefs: $e");
    }
  }

  // Set login state (for compatibility with existing code)
  static Future<void> login() async {
    try {
      // This method is kept for backward compatibility
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setInt(
        _lastLoginTimeKey,
        DateTime.now().millisecondsSinceEpoch,
      );

      // If Firebase user exists, save the ID
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await prefs.setString(_userIdKey, currentUser.uid);
        if (currentUser.email != null) {
          await prefs.setString(_userEmailKey, currentUser.email!);
        }
        if (currentUser.phoneNumber != null) {
          await prefs.setString(_userPhoneKey, currentUser.phoneNumber!);
        }
      }
    } catch (e) {
      print("Error in login(): $e");
    }
  }

  // Set logout state
  static Future<void> logout() async {
    try {
      // Sign out from Firebase
      await _auth.signOut();

      // Clear preferences
      final prefs = await SharedPreferences.getInstance();
      // Keep some settings but remove authentication data
      final initialQuestionShown = prefs.getBool(_initialQuestionShownKey);
      await prefs.clear();

      // Restore settings
      if (initialQuestionShown != null) {
        await prefs.setBool(_initialQuestionShownKey, initialQuestionShown);
      }

      print("User logged out successfully");
    } catch (e) {
      print("Error during logout: $e");
    }
  }

  // Get current user
  static Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      // Try to get from Firebase first
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        return {
          'userId': currentUser.uid,
          'email': currentUser.email,
          'phone': currentUser.phoneNumber,
        };
      }

      // Fallback to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      return {
        'userId': prefs.getString(_userIdKey),
        'email': prefs.getString(_userEmailKey),
        'phone': prefs.getString(_userPhoneKey),
      };
    } catch (e) {
      print("Error getting current user: $e");
      return {'userId': null, 'email': null, 'phone': null};
    }
  }

  // Check if email exists
  static Future<bool> checkEmailExists(String email) async {
    try {
      final List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(
        email,
      );
      return signInMethods.isNotEmpty;
    } catch (e) {
      print("Error checking if email exists: $e");
      return false;
    }
  }

  // Reset password
  static Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("Error sending password reset email: $e");
      rethrow;
    }
  }

  // Check if current user is an admin
  static Future<bool> isAdmin() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // First check if user has admin flag set in preferences
      final isAdminFlagSet = prefs.getBool(_isAdminKey) ?? false;
      if (isAdminFlagSet) return true;

      final userEmail = prefs.getString(_userEmailKey);

      // Check if user is logged in and has an admin email
      if (userEmail != null) {
        // Check if email matches admin email
        if (userEmail.toLowerCase() == adminEmail.toLowerCase()) {
          // Update admin flag in preferences
          await prefs.setBool(_isAdminKey, true);
          return true;
        }
      }
      return false;
    } catch (e) {
      print("Error checking admin status: $e");
      return false;
    }
  }

  // Toggle post feature status (admin only)
  static Future<bool> toggleFeaturePost(String postId, bool featured) async {
    try {
      // Verify admin status
      final isAdminUser = await isAdmin();
      if (!isAdminUser) {
        print("Unauthorized attempt to feature post");
        return false;
      }

      // Update post in Firebase
      await FirebaseDatabase.instance.ref().child('Posts').child(postId).update(
        {'isFeatured': featured},
      );

      print("Post $postId featured status changed to $featured");
      return true;
    } catch (e) {
      print("Error toggling feature post: $e");
      return false;
    }
  }

  // Delete a post (admin only)
  static Future<bool> deletePost(String postId) async {
    try {
      // Verify admin status
      final isAdminUser = await isAdmin();
      if (!isAdminUser) {
        print("Unauthorized attempt to delete post");
        return false;
      }

      // Delete post from Firebase
      await FirebaseDatabase.instance
          .ref()
          .child('Posts')
          .child(postId)
          .remove();

      // Also delete associated comments
      final commentsSnapshot =
          await FirebaseDatabase.instance
              .ref()
              .child('Comments')
              .orderByChild('postId')
              .equalTo(postId)
              .once();

      if (commentsSnapshot.snapshot.value != null) {
        final commentsData =
            commentsSnapshot.snapshot.value as Map<dynamic, dynamic>;

        for (var commentId in commentsData.keys) {
          await FirebaseDatabase.instance
              .ref()
              .child('Comments')
              .child(commentId.toString())
              .remove();
        }
      }

      print("Post $postId and its comments deleted successfully");
      return true;
    } catch (e) {
      print("Error deleting post: $e");
      return false;
    }
  }
}
