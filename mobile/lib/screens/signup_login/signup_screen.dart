
import 'package:flutter/material.dart';
import '../../../widgets/custom_text_filed.dart';
import '../../../services/api_service.dart';
import 'package:atuimate_app/screens/signup_login/login_screen.dart';
import 'package:dio/dio.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  bool isLoading = false;

  String? nameError;
  String? emailError;
  String? phoneError;
  String? passwordError;
  String? confirmPasswordError;

  bool nameValid = false;
  bool emailValid = false;
  bool phoneValid = false;
  bool passwordValid = false;
  bool confirmValid = false;

  void validate() {
    setState(() {
      // NAME
      if (nameController.text.trim().isEmpty) {
        nameError = "Required";
        nameValid = false;
      } else {
        nameError = null;
        nameValid = true;
      }

      // EMAIL
      if (emailController.text.trim().isEmpty) {
        emailError = "Required";
        emailValid = false;
      } else {
        emailError = null;
        emailValid = true;
      }

      // PHONE
      if (phoneController.text.trim().isEmpty) {
        phoneError = "Required";
        phoneValid = false;
      } else {
        phoneError = null;
        phoneValid = true;
      }

      // PASSWORD
      if (passwordController.text.isEmpty) {
        passwordError = "Required";
        passwordValid = false;
      } else {
        passwordError = null;
        passwordValid = true;
      }

      // CONFIRM PASSWORD
      if (confirmPasswordController.text.isEmpty) {
        confirmPasswordError = "Required";
        confirmValid = false;
      } else if (passwordController.text !=
          confirmPasswordController.text) {
        confirmPasswordError = "Passwords do not match";
        confirmValid = false;
      } else {
        confirmPasswordError = null;
        confirmValid = true;
      }
    });
  }

  Future<void> register() async {
    validate();

    if (!(nameValid &&
        emailValid &&
        phoneValid &&
        passwordValid &&
        confirmValid)) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final api = ApiService();

      final response = await api.registerParent(
        fullName: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        confirmPassword: confirmPasswordController.text.trim(),
        phone: phoneController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.data["message"] ?? "Registered")),
      );
    } catch (e) {
      if (e is DioException) {
        final message = e.response?.data["message"];

        setState(() {
          if (message == "Email already exists") {
            emailError = "Email already exists";
            emailValid = false;
          }

          if (message == "Passwords do not match" ||
              message == "Passwords don't match") {
            confirmPasswordError = "Passwords do not match";
            confirmValid = false;
          }
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration Failed")),
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
              Image.asset("assets/images/image.png", height: 200),

              const SizedBox(height: 20),

              CustomTextField(
                hint: "Full name",
                icon: Icons.person_outline,
                controller: nameController,
                errorText: nameError,
                onChanged: (_) => validate(),
              ),

              const SizedBox(height: 15),

              CustomTextField(
                hint: "Valid email",
                icon: Icons.email_outlined,
                controller: emailController,
                errorText: emailError,
                onChanged: (_) => validate(),
              ),

              const SizedBox(height: 15),

              CustomTextField(
                hint: "Phone number",
                icon: Icons.phone_outlined,
                controller: phoneController,
                errorText: phoneError,
                onChanged: (_) => validate(),
              ),

              const SizedBox(height: 15),

              CustomTextField(
                hint: "Strong password",
                icon: Icons.lock_outline,
                isPassword: true,
                controller: passwordController,
                errorText: passwordError,
                onChanged: (_) => validate(),
              ),

              const SizedBox(height: 15),

              CustomTextField(
                hint: "Confirm password",
                icon: Icons.lock_outline,
                isPassword: true,
                controller: confirmPasswordController,
                errorText: confirmPasswordError,
                onChanged: (_) => validate(),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: isLoading ? null : register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF45BB89),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Sign up",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Do you have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Log in",
                      style: TextStyle(
                        color: Color(0xFF45BB89),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}