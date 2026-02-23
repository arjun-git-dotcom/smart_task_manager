import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final FirebaseFirestore firestore;

  UserProfileRepositoryImpl(this.firestore);

  @override
  Future<UserProfileEntity> fetchUserProfile({required String uid}) async {
    final doc = await firestore.collection('users').doc(uid).get();

    if (!doc.exists) {
      throw Exception('User profile not found');
    }

    final data = doc.data()!;
    return UserProfileEntity(
      uid: uid,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isDarkMode: data['themeMode'] ?? false,
    );
  }

  @override
  Future<void> updateUserProfile(UserProfileEntity profile) async {
    await firestore.collection('users').doc(profile.uid).set({
      'name': profile.name,
      'email': profile.email,
      'createdAt': profile.createdAt,
      'themeMode': profile.isDarkMode,
    },SetOptions(merge: true));
  }
}