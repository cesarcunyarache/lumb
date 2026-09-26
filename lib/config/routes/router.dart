import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lumb/presentation/screen/auth/views/get_started_view.dart';
import 'package:lumb/presentation/screen/auth/views/sign_in_view.dart';
import 'package:lumb/presentation/screen/auth/views/sign_up_view.dart';
import 'package:lumb/presentation/screen/home/home_page.dart';
import 'package:lumb/presentation/screen/oboarding/onboarding_view.dart';



class AppRouter {
  late final String? initialRoute;
  late final GoRouter router;

  AppRouter(this.initialRoute) {
    router = GoRouter(
      initialLocation: initialRoute,
      routes: [
        GoRoute(
            path: '/onBoarding',
            name: '/onBoarding',
            pageBuilder: (context, state) =>
                const CupertinoPage(child: OnboardingView())),
        GoRoute(
          path: '/getStarted',
          name: '/getStarted',
          pageBuilder: (context, state) => const CupertinoPage(
            child: GetStartedView(),
          ),
        ),
        GoRoute(
          path: '/home',
          name: '/home',
          builder: (context, state) => const MainWrapper(),
        ),
        GoRoute(
          path: '/signIn',
          name: '/signIn',
          pageBuilder: (context, state) => const MaterialPage(
            child: SignInView(),
          ),
        ),
        GoRoute(
          path: '/signUp',
          name: '/signUp',
          pageBuilder: (context, state) => const MaterialPage(
            child: SignUpView(),
          ),
        ),
      ],
    );
  }
}
