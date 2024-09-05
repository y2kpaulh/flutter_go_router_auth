import 'package:user_auth_example/model/user_db_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserInfoStateNotifier extends StateNotifier<UserDBInfo?> {
  UserInfoStateNotifier(): super(null);

  bool get isSignedUp => state != null;

  Future<UserDBInfo?> getUserInfo() async {
    return state;
  }

  Future<UserDBInfo?> saveUserInfo(UserDBInfo userDBInfo) async {
    await Future.delayed(const Duration(milliseconds: 300));
    state = userDBInfo;
    return userDBInfo;
  }
}

// Provider 정의
final userInfoStateProvider = StateNotifierProvider<UserInfoStateNotifier, UserDBInfo?>((ref) {
  return UserInfoStateNotifier();
});