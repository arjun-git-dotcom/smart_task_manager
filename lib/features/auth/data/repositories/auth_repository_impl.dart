import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl(this._firebaseAuth, this._firestore);

  @override
  Future<UserEntity> login({required String email, required String password}) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(), password: password,
    );
    return UserEntity(uid: userCredential.user!.uid, email: userCredential.user!.email!);
  }

  @override
  Future<UserEntity> register({required String email, required String password}) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(), password: password,
    );

    final user = userCredential.user!;

    
    await _firestore.collection('users').doc(user.uid).set({
      'name': '',
      'email': user.email,
      'createdAt': Timestamp.now(),
      'themeMode': false,
    });

    return UserEntity(uid: user.uid, email: user.email!);
  }

  @override
  Future<void> logout() async => await _firebaseAuth.signOut();

  @override
  UserEntity? getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    if (user != null) return UserEntity(uid: user.uid, email: user.email!);
    return null;
  }
}