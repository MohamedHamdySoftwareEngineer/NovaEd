import 'package:novaed_app/features/choice_screen/presentation/views/choice_screen.dart';
import 'package:novaed_app/features/home/presentation/views/home_view.dart';
import 'package:novaed_app/features/quiz_screen/presentation/views/quiz_screen.dart';
import 'package:novaed_app/features/sign_in/presentation/views/login.dart';
import 'package:novaed_app/features/splash/presentation/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/User Profile/Presentation/views/user_profile.dart';

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
          // You need to extract collectionId from state.extra or another source
          // For demonstration, let's assume state.extra is a Map<String, int>
          final extra = state.extra as Map<String, int>;
          final submissionId = extra['submissionId']!;
          final collectionId = extra['collectionId']!;
          return QuizScreen(
              submissionId: submissionId, collectionId: collectionId);
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

  static Future<T?> toQuizScreen<T>(BuildContext context,
          {required int submissionId, required int collectionId}) =>
      context.push<T>(rQuizScreen, extra: {
        'submissionId': submissionId,
        'collectionId': collectionId,
      });

  static Future<T?> toChoiceScreen<T>(BuildContext context) =>
      context.push<T>(rChoiceScreen);

  static Future<T?> toSettingsScreen<T>(BuildContext context) =>
      context.push<T>(rSettingsScreen);

  static Future<T?> toUserProfile<T>(BuildContext context,
          {int initialIndex = 0}) =>
      context.push<T>(rUserProfile, extra: initialIndex);

  static void toBack<T>(BuildContext context, [T? result]) =>
      context.pop(result);
}
