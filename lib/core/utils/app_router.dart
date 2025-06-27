import 'package:novaed_app/features/choice_screen/presentation/views/choice_screen.dart';
import 'package:novaed_app/features/home/presentation/views/home_view.dart';
import 'package:novaed_app/features/quiz_screen/presentation/views/quiz_screen.dart';
import 'package:novaed_app/features/sign_in/presentation/views/login.dart';
import 'package:novaed_app/features/splash/presentation/views/splash_view.dart';
import 'package:novaed_app/features/user_profile/presentation/views/user_profile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/data/repositories/quiz_repository.dart';

abstract class AppRouter {
  // Route names
  static const rHomeView = '/HomeView';
  static const rSignIn = '/SignIn';
  static const rSignUp = '/SignUp';
  static const rChoiceScreen = '/ChoiceScreen';
  static const rQuizScreen = '/QuizScreen';
  static const rSettingsScreen = '/SettingsScreen';
  static const rUserProfile = '/UserProfile';

  // GoRouter configuration
  static final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashView()),
      GoRoute(path: rHomeView, builder: (context, state) => const HomeView()),
      GoRoute(path: rSignIn, builder: (context, state) => const LogIn()),
      GoRoute(
        path: rChoiceScreen,
        builder: (context, state) {
          // Extract initialIndex from extra or use default (1)
          final initialIndex = state.extra as int? ?? 1;
          return ChoiceScreen(initialIndex: initialIndex);
        },
      ),
      GoRoute(
        path: rQuizScreen,
        builder: (context, state) {
          final lessonId = int.parse(state.pathParameters['lessonId'] ?? '0');

          return RepositoryProvider<QuizRepository>(
            create: (_) => QuizRepository(
              dio: Dio(),
              storage: const FlutterSecureStorage(),
            ),
            child: QuizScreen(lessonId: lessonId),
          );
        },
      ),
      
      GoRoute(
        path: rUserProfile,
        builder: (context, state) {
          // Extract initialIndex from extra or use default (0)
          final initialIndex = state.extra as int? ?? 0;
          return UserProfile(initialIndex: initialIndex);
        },
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Text(
            'Oops! Page not found!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    ),
  );

  // Navigation methods
  static Future<T?> toHomeView<T>(BuildContext context) =>
      context.push<T>(rHomeView);

  static Future<T?> toSignIn<T>(BuildContext context) =>
      context.push<T>(rSignIn);

  static Future<T?> toChoiceScreen<T>(BuildContext context,
          {int initialIndex = 1}) =>
      context.push<T>(rChoiceScreen, extra: initialIndex);

  static Future<T?> toQuizScreen<T>(BuildContext context) =>
      context.push<T>(rQuizScreen);

  static Future<T?> toSettingsScreen<T>(BuildContext context) =>
      context.push<T>(rSettingsScreen);

  static Future<T?> toUserProfile<T>(BuildContext context,
          {int initialIndex = 0}) =>
      context.push<T>(rUserProfile, extra: initialIndex);

  static void toBack<T>(BuildContext context, [T? result]) =>
      context.pop(result);
}
