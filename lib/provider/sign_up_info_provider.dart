import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_auth_example/model/sign_up_info.dart';

class SignUpInfoStateNotifier extends StateNotifier<SignUpInfo> {
  SignUpInfoStateNotifier(): super(SignUpInfo(false, false));

  bool get isPhoneAuthed => state.isPhoneAuthed == true;
  bool get isTermsChecked => state.isTermsChecked == true;

  Future<SignUpInfo> getSignUpInfo() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return state;
  }

  SignUpInfo phoneAuthed()  {
    state.isPhoneAuthed = true;
    return state;
  }

  SignUpInfo termChecked()  {
    state.isTermsChecked = true;
   return state;
  }
}

// Provider 정의
final signUpInfoStateProvider = StateNotifierProvider<SignUpInfoStateNotifier, SignUpInfo>((ref) {
  return SignUpInfoStateNotifier();
});