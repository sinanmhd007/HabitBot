import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habitbot/core/error/exceptions.dart';
import 'package:habitbot/core/utils/phone_utils.dart';
import 'package:habitbot/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> signup({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  });
  Future<void> logout();
  Future<UserModel?> checkAuthStatus();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({required this.firebaseAuth, required this.firestore});

  @override
  Future<UserModel> login({required String email, required String password}) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        // Fetch user from Firestore to get name if needed, or just use firebase user
        var doc = await firestore.collection('users').doc(userCredential.user!.uid).get();
        if(doc.exists) {
           return UserModel.fromJson(doc.data()!);
        }
        return UserModel.fromFirebaseUser(userCredential.user!);
      } else {
        throw AuthException('User not found');
      }
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseException(e);
    }
  }

  @override
Future<UserModel> signup({
  required String name,
  required String email,
  required String password,
  required String phoneNumber,
}) async {
  try {
    // 🔹 STEP 1: FORMAT PHONE NUMBER
    final formattedPhone = PhoneUtils.formatPhone(phoneNumber);

    final userCredential = await firebaseAuth
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential.user != null) {
      await userCredential.user!.updateDisplayName(name);

      final userModel = UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        phoneNumber: formattedPhone, // ✅ FIXED
      );

      // 🔹 STEP 2: SAVE CLEAN DATA
      await firestore
          .collection('users')
          .doc(userModel.id)
          .set(userModel.toJson());

      return userModel;
    } else {
      throw AuthException('Failed to create user');
    }
  } on FirebaseAuthException catch (e) {
    throw _handleFirebaseException(e);
  }
}

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<UserModel?> checkAuthStatus() async {
    final currentUser = firebaseAuth.currentUser;
    if (currentUser != null) {
        var doc = await firestore.collection('users').doc(currentUser.uid).get();
        if(doc.exists) {
           return UserModel.fromJson(doc.data()!);
        }
      return UserModel.fromFirebaseUser(currentUser);
    }
    return null;
  }
    AuthException _handleFirebaseException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return AuthException('No user found for that email.');
      case 'wrong-password':
        return AuthException('Wrong password provided.');
      case 'email-already-in-use':
        return AuthException('The account already exists for that email.');
      case 'weak-password':
        return AuthException('The password provided is too weak.');
      default:
        return AuthException(e.message ?? 'An unknown error occurred.');
    }
  }
}
