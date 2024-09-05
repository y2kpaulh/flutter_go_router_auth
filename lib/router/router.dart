import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:user_auth_example/provider/sign_up_info_provider.dart';
import 'package:user_auth_example/router/router_observer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_auth_example/screen/home/home_screen.dart';
import '../provider/login_info_state_provider.dart';
import '../provider/user_info_state_provider.dart';
import '../screen/log_in/log_in_screen.dart';
import '../screen/profile/profile_screen.dart';
import '../screen/signup/sign_up_screen.dart';

part 'router.g.dart';

@riverpod
GoRouter router(RouterRef ref) {
  final userId = ref.watch(loginInfoStateProvider);
  final userDBInfo = ref.watch(userInfoStateProvider.notifier);
  final signUpInfo = ref.watch(signUpInfoStateProvider.notifier);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    observers: [RouterObserver()],
    redirect: (context, state) async {
      // 사용자 ID와 사용자 정보를 비동기적으로 가져옵니다.
      final userInfo = await userDBInfo.getUserInfo();

      debugPrint('저장된 userId: $userId');
      debugPrint('현재 화면: ${state.matchedLocation}');

      // 로그인 정보 확인
      final loggedIn = userId.isNotEmpty;
      final signedUp = userInfo != null;
      final termsAccepted = signUpInfo.isTermsChecked;
      final phoneAuthSuccess = signUpInfo.isPhoneAuthed;
      final loggingIn = state.matchedLocation == '/login';

      debugPrint('로그인 상태: $loggedIn, 로그인 화면: $loggingIn');

      if (!loggedIn && !loggingIn) {
        return '/login';
      }

      // 로그인하지 않은 경우
      if (!loggedIn) {
        // 로그인 화면에 있는 경우
        if (state.matchedLocation == '/login') {
          return null; // 로그인 화면에 머무름
        }
        return '/login'; // 로그인 화면으로 리디렉션
      }

      // 로그인한 경우
      if (!signedUp) {
        // 약관 동의와 번호 인증이 완료된 경우
        if (termsAccepted && phoneAuthSuccess) {
          return '/'; // 홈 화면으로 이동
        }
        return '/signup'; // 회원 가입 화면으로 이동
      }

      // 모든 조건을 만족하는 경우
      return null; // 현재 위치 유지
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: '/login',
        name: 'logIn',
        builder: (BuildContext context, GoRouterState state) {
          return const LogInScreen();
        },
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (BuildContext context, GoRouterState state) {
          return const SignUpScreen();
        },
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (BuildContext context, GoRouterState state) {
          return const ProfileScreen();
        },
      ),
    ],
  );
}
