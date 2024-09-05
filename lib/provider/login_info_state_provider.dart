import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginInfoStateNotifier extends StateNotifier<String> {
  final FlutterSecureStorage secureStorage;

  LoginInfoStateNotifier(this.secureStorage) : super('');

  bool get loggedIn => state.isNotEmpty;

  Future<void> loadUserId() async {
    final userId = await secureStorage.read(key: 'userId');
    state = userId ?? '';
  }

  Future<String> getUserId() async {
    final state = await secureStorage.read(key: 'userId');
    return state ?? '';
  }

  Future<void> saveUserId(String userId) async {
    try {
      state = userId;
      await secureStorage.write(key: 'userId', value: userId);
      // 지연 추가
      await Future.delayed(const Duration(milliseconds: 50));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUserId() async {
    state = '';
    await secureStorage.delete(key: 'userId');
    // 지연 추가
    await Future.delayed(const Duration(milliseconds: 50));
  }
}

// Provider 정의
final loginInfoStateProvider = StateNotifierProvider<LoginInfoStateNotifier, String>((ref) {
  final storage = FlutterSecureStorage();
  return LoginInfoStateNotifier(storage);
});