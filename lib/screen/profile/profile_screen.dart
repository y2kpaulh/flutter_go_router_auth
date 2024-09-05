import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_auth_example/provider/login_info_state_provider.dart';

import '../../provider/user_info_state_provider.dart';

class ProfileScreen extends StatefulHookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final userDBInfo = ref.watch(userInfoStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile'),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if(userDBInfo!=null)
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text('name: ${userDBInfo.name}'),
                 Text('phone: ${userDBInfo.phone}')
               ],
             ),
            const SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () async {
                // 현재 context를 변수에 저장
                final currentContext = context;

                try {
                  // 사용자 ID 삭제
                  await ref.read(loginInfoStateProvider.notifier).deleteUserId();
                  // 로그아웃 후 로그인 화면으로 이동
                  if (currentContext.mounted) {
                    currentContext.go('/login'); // 로그인 화면으로 리디렉션
                  }
                } catch (e) {
                  debugPrint('delete user id error: $e');
                  // 사용자에게 오류 알림 (예: SnackBar)
                  if (currentContext.mounted) {
                    ScaffoldMessenger.of(currentContext).showSnackBar(
                      const SnackBar(content: Text('로그아웃 중 오류가 발생했습니다.')),
                    );
                  }
                }
              },
              child: const Text('Log Out'),
            )
          ],
        ),
      ),
    );
  }
}
