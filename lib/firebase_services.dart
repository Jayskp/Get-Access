import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Initialize Firestore with proper settings
  static Future<void> initializeFirestore() async {
    try {
      print("Initializing Firestore...");

      // Enable persistence for offline capabilities
      await _firestore
          .enablePersistence(const PersistenceSettings(synchronizeTabs: true))
          .catchError((e) {
            // This might fail in web or if already enabled, that's ok
            print("Persistence already enabled or not supported: $e");
          });

      // Set cache size to 100MB
      _firestore.settings = const Settings(
        cacheSizeBytes: 100 * 1024 * 1024, // 100MB
        persistenceEnabled: true,
      );

      print("Firestore initialized successfully");
    } catch (e) {
      print("Error initializing Firestore: $e");
    }
  }

  // Check if Firestore is properly set up
  static Future<bool> isFirestoreAvailable() async {
    try {
      print("Checking Firestore availability...");

      // Try to access a test collection
      final testRef = _firestore.collection('_test_');
      final testDoc = testRef.doc('test');

      // Try to write to Firestore
      await testDoc.set({'timestamp': FieldValue.serverTimestamp()});

      // Try to read from Firestore
      final snapshot = await testDoc.get();

      // Clean up test document
      await testDoc.delete();

      print("Firestore is available and working correctly");
      return true;
    } catch (e) {
      if (e.toString().contains("database (default) does not exist")) {
        print(
          "Firestore database does not exist. Please create it in the Firebase Console.",
        );
        return false;
      }

      print("Error checking Firestore availability: $e");
      return false;
    }
  }

  // Create required collections if they don't exist
  static Future<void> ensureRequiredCollections() async {
    try {
      print("Ensuring required collections exist...");

      // List of required collections
      final requiredCollections = [
        'users',
        'announcements',
        'posts',
        'comments',
      ];

      // Check each collection and create a dummy document if needed
      for (final collection in requiredCollections) {
        final testDoc = _firestore.collection(collection).doc('_init_');
        await testDoc.set({
          'initialized': true,
          'timestamp': FieldValue.serverTimestamp(),
        });
        await testDoc.delete();
        print("Collection '$collection' is ready");
      }

      print("All required collections are set up");
    } catch (e) {
      print("Error ensuring required collections: $e");
    }
  }

  // Helper method to check and setup everything
  static Future<bool> setupFirestore() async {
    try {
      print("Setting up Firestore...");

      // Initialize Firestore
      await initializeFirestore();

      // Check if Firestore is available
      final isAvailable = await isFirestoreAvailable();
      if (!isAvailable) {
        print(
          "Firestore is not available. Setup required in Firebase Console.",
        );
        return false;
      }

      // Ensure collections exist
      await ensureRequiredCollections();

      print("Firestore setup completed successfully");
      return true;
    } catch (e) {
      print("Error during Firestore setup: $e");
      return false;
    }
  }
}
