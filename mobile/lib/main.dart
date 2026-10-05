import 'package:atuimate_app/screens/signup_login/account_created_screen.dart';
import 'package:atuimate_app/screens/signup_login/password_success_screen.dart';
import 'package:atuimate_app/screens/signup_login/update_password_screen.dart';
import 'package:flutter/material.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/signup_login/signup_screen.dart';
import 'screens/onboarding/third_welcome_screen.dart';
import 'screens/signup_login/child_signup_screen.dart';
import 'screens/signup_login/login_screen.dart';
import 'screens/signup_login/verification_email_screen.dart';
import 'screens/child/child_home_screen.dart';
import 'screens/child/learning_screens/arabic_alphabet_learning_screen.dart';
import 'package:atuimate_app/screens/child/learning_screens/colors _screen.dart';
import 'package:atuimate_app/screens/child/routine/choose_routine_screen.dart';
import 'package:atuimate_app/screens/child/Skills_Screens/Math/game_screen.dart';
import 'screens/splash_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: '/splash',

      routes: {
        "/onboarding": (context) => const OnboardingScreen(),
        "/signup": (context) => const SignUpScreen(),
        "/thirdWelcome": (context) => const ThirdWelcomeScreen(),
        "/childSignup": (context) => const ChildSignUpScreen(),
        "/login": (context) => const LoginScreen(),
        "/verifyEmail": (context) => const VerificationEmailScreen(),
        "/updatePassword": (context) => const UpdatePasswordScreen(),
        "/resetSuccess": (context) => const PasswordResetSuccessScreen(),
        "/accountCreated": (context) => const AccountCreatedScreen(),
        "/childHome": (context) => const ChildHomeScreen(),
        "/arabic_alphabet": (context) => const ArabicAlphabetScreen(),
        "/colors": (context) => ColorsScreen(),
        "/chooseRoutine": (context) => const ChooseRoutineScreen(),
        "/GameScreen": (context) => const GameScreen(),
        "/splash": (context) => const SplashScreen(),
      },
    );
  }
}
