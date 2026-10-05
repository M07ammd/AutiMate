/*import 'package:atuimate_app/screens/child/child_home_screen.dart';
import 'package:atuimate_app/screens/parent/parent_home.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/custom_text_filed.dart';
import '../../../services/api_service.dart';
import 'signup_screen.dart';
import 'package:atuimate_app/screens/signup_login/forget_password_screen .dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;
  bool isLoading = false;
  /// Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });
    try {
      final api = ApiService();
      final response = await api.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      print("LOGIN STATUS: ${response.statusCode}");
      print("LOGIN DATA: ${response.data}");
      final accessToken = response.data["accessToken"];
      final refreshToken = response.data["refreshToken"];
      final role = response.data["user"]?["role"];
      final fullName = response.data["user"]?["fullName"];
      final email = response.data["user"]?["email"];
      if (accessToken == null || refreshToken == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login failed")),
        );
        setState(() {isLoading = false;});
        return;
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("accessToken", accessToken);
      await prefs.setString("refreshToken", refreshToken);
      await prefs.setString("role", role ?? "");
      await prefs.setString("userId", response.data["user"]["id"]);
      if (fullName != null) {
        await prefs.setString("fullName", fullName);
      }
      if (email != null) {
        await prefs.setString("email", email);
      }
      if (role == "PARENT") {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const ParentHome(),
          ),
        );

      } else if (role == "CHILD") {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const ChildHomeScreen(),
          ),
        );

      } else {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unknown user role")),
        );

      }

    } on DioException catch (e) {

      print("LOGIN ERROR: ${e.response?.data}");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.response?.data["message"] ?? "Login Failed",
          ),
        ),
      );

    } catch (e) {

      print("LOGIN ERROR: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Failed")),
      );

    }

    setState(() {
      isLoading = false;
    });

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [

              const SizedBox(height: 20),

              Image.asset(
                "assets/images/image3.png",
                height: 200,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 20),

              CustomTextField(
                hint: "Enter your email",
                icon: Icons.email_outlined,
                controller: emailController,
              ),

              const SizedBox(height: 15),

              CustomTextField(
                hint: "Password",
                icon: Icons.lock_outline,
                isPassword: true,
                controller: passwordController,
              ),

              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    activeColor: const Color(0xFF45BB89),
                    onChanged: (v) {
                      setState(() {
                        rememberMe = v!;
                      });
                    },
                  ),
                  const Text("Remember me"),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgetPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Forgot password?",
                      style: TextStyle(color: Color(0xFF45BB89)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF45BB89),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: isLoading ? null : login,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Log in",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                        color: Color(0xFF45BB89),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),



              const SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }
}*/
import 'package:atuimate_app/screens/child/child_home_screen.dart';
import 'package:atuimate_app/screens/parent/parent_home.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/custom_text_filed.dart';
import '../../../services/api_service.dart';
import 'signup_screen.dart';
import 'package:atuimate_app/screens/signup_login/forget_password_screen .dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;
  bool isLoading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? emailError;
  String? passwordError;

  bool emailValid = false;
  bool passwordValid = false;

  void validate() {
    setState(() {
      // EMAIL
      if (emailController.text.trim().isEmpty) {
        emailError = "Required";
        emailValid = false;
      } else {
        emailError = null;
        emailValid = true;
      }

      // PASSWORD
      if (passwordController.text.isEmpty) {
        passwordError = "Required";
        passwordValid = false;
      } else {
        passwordError = null;
        passwordValid = true;
      }
    });
  }

  Future<void> login() async {
    validate();

    if (!(emailValid && passwordValid)) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final api = ApiService();

      final response = await api.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final accessToken = response.data["accessToken"];
      final refreshToken = response.data["refreshToken"];
      final role = response.data["user"]?["role"];
      final fullName = response.data["user"]?["fullName"];
      final email = response.data["user"]?["email"];

      if (accessToken == null || refreshToken == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login failed")),
        );
        setState(() => isLoading = false);
        return;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("accessToken", accessToken);
      await prefs.setString("refreshToken", refreshToken);
      await prefs.setString("role", role ?? "");
      await prefs.setString("userId", response.data["user"]["id"]);

      if (fullName != null) {
        await prefs.setString("fullName", fullName);
      }

      if (email != null) {
        await prefs.setString("email", email);
      }

      if (role == "PARENT") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ParentHome()),
        );
      } else if (role == "CHILD") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ChildHomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unknown user role")),
        );
      }
    } on DioException catch (e) {
      final message = e.response?.data["message"];

      setState(() {
        if (message != null) {
          if (message.toString().toLowerCase().contains("email")) {
            emailError = message;
            emailValid = false;
          }

          if (message.toString().toLowerCase().contains("password")) {
            passwordError = message;
            passwordValid = false;
          }
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message ?? "Login Failed")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Failed")),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              Image.asset(
                "assets/images/image3.png",
                height: 200,
              ),

              const SizedBox(height: 20),

              CustomTextField(
                hint: "Enter your email",
                icon: Icons.email_outlined,
                controller: emailController,
                errorText: emailError,
                onChanged: (_) => validate(),
              ),

              const SizedBox(height: 15),

              CustomTextField(
                hint: "Password",
                icon: Icons.lock_outline,
                isPassword: true,
                controller: passwordController,
                errorText: passwordError,
                onChanged: (_) => validate(),
              ),

              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    activeColor: const Color(0xFF45BB89),
                    onChanged: (v) {
                      setState(() {
                        rememberMe = v!;
                      });
                    },
                  ),
                  const Text("Remember me"),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const ForgetPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Forgot password?",
                      style: TextStyle(color: Color(0xFF45BB89)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: isLoading ? null : login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF45BB89),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text(
                    "Log in",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                        color: Color(0xFF45BB89),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}