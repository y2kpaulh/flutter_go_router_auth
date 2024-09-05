import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../provider/login_info_state_provider.dart';

class LogInScreen extends StatefulHookConsumerWidget {
  const LogInScreen({super.key});

  @override
  ConsumerState<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends ConsumerState<LogInScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (!_isLoading) ? AppBar(
        title: const Text('Login'),
      ) : null,
      body: Stack(
        children: [
          Center(
            child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          // 현재 context를 변수에 저장
                          final currentContext = context;
                          if (currentContext.mounted) {
                            setState(() {
                              _isLoading = true;
                            });
                          }

                          try {
                            await ref
                                .read(loginInfoStateProvider.notifier)
                                .saveUserId('test-user');

                          if (currentContext.mounted) {
                            setState(() {
                              _isLoading = false;
                            });
                              currentContext.go('/');
                            }
                          } catch (e) {
                            debugPrint('user Id 저장 실패: $e');
                            setState(() {
                              _isLoading = false;
                            });
                            // 사용자에게 오류 알림 (예: SnackBar)
                            if (currentContext.mounted) {
                              ScaffoldMessenger.of(currentContext).showSnackBar(
                                SnackBar(content: Text('로그인 중 오류가 발생했습니다.$e')),
                              );
                            }
                          }
                        },
                        child: const Text('Login'))
                  ],
                ),
          ),
          if(_isLoading)
            Stack(
              children: [
                Container(
                  color: Colors.black12,
                ),
                const Center(child: CircularProgressIndicator()),
              ],
            )
        ],
      ),
    );
  }
}
