import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_auth_example/provider/sign_up_info_provider.dart';

import '../../model/user_db_info.dart';
import '../../provider/user_info_state_provider.dart';

class SignUpScreen extends StatefulHookConsumerWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  UserDBInfo? userDBInfo;
  String userInfoText = '';
  bool _termChecked = false;



  @override
  Widget build(BuildContext context) {
    final signUpInfo = ref.watch(signUpInfoStateProvider);
    final signUpInfoNotifier = ref.read(signUpInfoStateProvider.notifier);

    useMemoized((){
      _termChecked = signUpInfo.isTermsChecked;
    },[]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Phone Auth'),
            const SizedBox(
              height: 10,
            ),
            if (userInfoText.isNotEmpty) Text(userInfoText),
            const SizedBox(
              height: 10,
            ),

            ElevatedButton(
                onPressed: () async {
                  try {
                    if (context.mounted) {
                      await ref
                          .read(userInfoStateProvider.notifier)
                          .saveUserInfo(UserDBInfo('test-name', '01012345678'));

                       ref
                          .read(signUpInfoStateProvider.notifier)
                          .phoneAuthed();

                      userDBInfo = await ref
                          .read(userInfoStateProvider.notifier)
                          .getUserInfo();
                    }
                    if (userDBInfo != null) {
                      setState(() {
                        userInfoText =
                            '${userDBInfo!.name}, ${userDBInfo!.phone}';
                      });
                    }
                  } catch (e) {
                    debugPrint('phone auth error!');
                  }
                },
                child: const Text('auth')),
            const Text('Terms & Privacy'),
            const SizedBox(
              height: 10,
            ),
            // ElevatedButton(
            //     onPressed: () async {
            //       try {
            //          ref
            //             .read(signUpInfoStateProvider.notifier)
            //             .termChecked();
            //       } catch (e) {
            //         debugPrint('phone auth error!');
            //       }
            //     },
            //     child: const Text('Term Check')),
            Checkbox(value: _termChecked, onChanged: (bool? newValue) {
              // Call the termChecked method with the new value
              try {
            setState(() {
              _termChecked = signUpInfoNotifier
                  .termChecked(newValue!);
            });


              } catch (e) {
                debugPrint('phone auth error!');
              }
            }),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    final savedUserInfo = await ref
                        .read(userInfoStateProvider.notifier)
                        .getUserInfo();

                    debugPrint('savedUserInfo: $savedUserInfo');
                    debugPrint('isPhoneAuthed: ${signUpInfo.isPhoneAuthed}');
                    debugPrint('isTermsChecked: ${signUpInfo.isTermsChecked}');

                    if (savedUserInfo != null &&
                        signUpInfo.isPhoneAuthed &&
                        signUpInfo.isTermsChecked) {
                      if (context.mounted) {
                        context.go('/');
                      }
                    } else {
                      debugPrint('signup error!');
                    }
                  } catch (e) {
                    debugPrint('phone auth error!');
                  }
                },
                child: const Text('sign up')),
          ],
        ),
      ),
    );
  }
}
