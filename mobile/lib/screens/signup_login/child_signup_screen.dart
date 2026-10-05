/*import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:atuimate_app/services/api_service.dart';
import 'package:atuimate_app/screens/parent/survrey/survey_screen.dart';

class ChildSignUpScreen extends StatefulWidget {
  const ChildSignUpScreen({super.key});

  @override
  State<ChildSignUpScreen> createState() => _ChildSignUpScreenState();
}

class _ChildSignUpScreenState extends State<ChildSignUpScreen> {
  String? gender;
  bool isLoading = false;

  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final dayController = TextEditingController();
  final monthController = TextEditingController();
  final yearController = TextEditingController();

  Future<void> createChild() async {
    if (gender == null) return;

    setState(() => isLoading = true);

    try {
      String dateOfBirth =
          "${yearController.text}-${monthController.text.padLeft(2, '0')}-${dayController.text.padLeft(2, '0')}";

      final response = await ApiService.createChild(
        childName: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        confirmPassword: confirmPasswordController.text.trim(),
        gender: gender!,
        dateOfBirth: dateOfBirth,
      );

      final childId = response.data["child"]["id"];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("childId", childId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Child added successfully")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SurveyScreen()),
      );

    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.response?.data["message"] ?? "Error"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    setState(() => isLoading = false);
  }

  Widget customField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool obscure = false,
    bool isPassword = false,
    VoidCallback? toggle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          icon: Icon(icon),
          hintText: hint,
          border: InputBorder.none,

          /// 👁 show/hide
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              obscure ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: toggle,
          )
              : null,
        ),
      ),
    );
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

              Image.asset("assets/images/image2.png", height: 180),

              const SizedBox(height: 10),

              customField(
                hint: "Child name",
                icon: Icons.person_outline,
                controller: nameController,
              ),

              const SizedBox(height: 15),

              customField(
                hint: "Valid email",
                icon: Icons.email_outlined,
                controller: emailController,
              ),

              const SizedBox(height: 15),

              customField(
                hint: "Password",
                icon: Icons.lock_outline,
                controller: passwordController,
                obscure: isPasswordHidden,
                isPassword: true,
                toggle: () {
                  setState(() {
                    isPasswordHidden = !isPasswordHidden;
                  });
                },
              ),

              const SizedBox(height: 15),

              customField(
                hint: "Confirm password",
                icon: Icons.lock_outline,
                controller: confirmPasswordController,
                obscure: isConfirmPasswordHidden,
                isPassword: true,
                toggle: () {
                  setState(() {
                    isConfirmPasswordHidden = !isConfirmPasswordHidden;
                  });
                },
              ),

              const SizedBox(height: 20),

              /// Gender
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Gender",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: const Text("Select gender"),
                    value: gender,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: const [
                      DropdownMenuItem(value: "MALE", child: Text("Male")),
                      DropdownMenuItem(value: "FEMALE", child: Text("Female")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        gender = value;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Date of birth
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Date of birth",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: customField(
                      hint: "Day",
                      icon: Icons.calendar_today_outlined,
                      controller: dayController,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: customField(
                      hint: "Month",
                      icon: Icons.calendar_today_outlined,
                      controller: monthController,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: customField(
                      hint: "Year",
                      icon: Icons.calendar_today_outlined,
                      controller: yearController,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

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
                  onPressed: isLoading ? null : createChild,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Save child info",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:atuimate_app/services/api_service.dart';
import 'package:atuimate_app/screens/parent/survrey/survey_screen.dart';

class ChildSignUpScreen extends StatefulWidget {
  const ChildSignUpScreen({super.key});

  @override
  State<ChildSignUpScreen> createState() => _ChildSignUpScreenState();
}

class _ChildSignUpScreenState extends State<ChildSignUpScreen> {
  String? gender;
  bool isLoading = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final dayController = TextEditingController();
  final monthController = TextEditingController();
  final yearController = TextEditingController();

  // errors
  String? nameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;
  String? genderError;
  String? dateError;

  void validate() {
    setState(() {
      nameError = null;
      emailError = null;
      passwordError = null;
      confirmPasswordError = null;
      genderError = null;
      dateError = null;

      if (nameController.text.trim().isEmpty) {
        nameError = "Required";
      }

      if (emailController.text.trim().isEmpty) {
        emailError = "Required";
      }

      if (passwordController.text.isEmpty) {
        passwordError = "Required";
      }

      if (confirmPasswordController.text.isEmpty) {
        confirmPasswordError = "Required";
      }

      if (passwordController.text != confirmPasswordController.text) {
        confirmPasswordError = "Passwords do not match";
      }

      if (gender == null) {
        genderError = "Select gender";
      }

      if (dayController.text.isEmpty ||
          monthController.text.isEmpty ||
          yearController.text.isEmpty) {
        dateError = "Invalid date";
      }
    });
  }

  Future<void> createChild() async {
    validate();

    if (nameError != null ||
        emailError != null ||
        passwordError != null ||
        confirmPasswordError != null ||
        genderError != null ||
        dateError != null) {
      return;
    }

    setState(() => isLoading = true);

    try {
      String dateOfBirth =
          "${yearController.text}-${monthController.text.padLeft(2, '0')}-${dayController.text.padLeft(2, '0')}";

      final response = await ApiService.createChild(
        childName: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        confirmPassword: confirmPasswordController.text.trim(),
        gender: gender!,
        dateOfBirth: dateOfBirth,
      );

      final childId = response.data["child"]["id"];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("childId", childId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.data["message"] ?? "Success")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SurveyScreen()),
      );
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.response?.data["message"] ?? "Error"),
        ),
      );
    }

    setState(() => isLoading = false);
  }

  Widget customField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    String? errorText,
    bool obscure = false,
    bool isPassword = false,
    VoidCallback? toggle,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: errorText != null ? Colors.red : Colors.green,
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            onChanged: onChanged,
            decoration: InputDecoration(
              icon: Icon(icon,
                  color: errorText != null ? Colors.red : Colors.green),
              hintText: hint,
              border: InputBorder.none,
              suffixIcon: isPassword
                  ? IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  color:
                  errorText != null ? Colors.red : Colors.green,
                ),
                onPressed: toggle,
              )
                  : null,
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
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

              Image.asset("assets/images/image2.png", height: 180),

              const SizedBox(height: 10),

              customField(
                hint: "Child name",
                icon: Icons.person_outline,
                controller: nameController,
                errorText: nameError,
                onChanged: (_) => validate(),
              ),

              const SizedBox(height: 15),

              customField(
                hint: "Valid email",
                icon: Icons.email_outlined,
                controller: emailController,
                errorText: emailError,
                onChanged: (_) => validate(),
              ),

              const SizedBox(height: 15),

              customField(
                hint: "Password",
                icon: Icons.lock_outline,
                controller: passwordController,
                obscure: true,
                isPassword: true,
                errorText: passwordError,
                toggle: () => setState(() {}),
                onChanged: (_) => validate(),
              ),

              const SizedBox(height: 15),

              customField(
                hint: "Confirm password",
                icon: Icons.lock_outline,
                controller: confirmPasswordController,
                obscure: true,
                isPassword: true,
                errorText: confirmPasswordError,
                toggle: () => setState(() {}),
                onChanged: (_) => validate(),
              ),

              const SizedBox(height: 20),

              /// Gender
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: genderError != null ? Colors.red : Colors.green,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: const Text("Select gender"),
                    value: gender,
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        gender = value;
                        validate();
                      });
                    },
                    items: const [
                      DropdownMenuItem(
                          value: "MALE", child: Text("Male")),
                      DropdownMenuItem(
                          value: "FEMALE", child: Text("Female")),
                    ],
                  ),
                ),
              ),

              if (genderError != null)
                const Text("Select gender",
                    style: TextStyle(color: Colors.red)),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: customField(
                      hint: "Day",
                      icon: Icons.calendar_today_outlined,
                      controller: dayController,
                      errorText: dateError,
                      onChanged: (_) => validate(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: customField(
                      hint: "Month",
                      icon: Icons.calendar_today_outlined,
                      controller: monthController,
                      errorText: dateError,
                      onChanged: (_) => validate(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: customField(
                      hint: "Year",
                      icon: Icons.calendar_today_outlined,
                      controller: yearController,
                      errorText: dateError,
                      onChanged: (_) => validate(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

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
                  onPressed: isLoading ? null : createChild,
                  child: isLoading
                      ? const CircularProgressIndicator(
                      color: Colors.white)
                      : const Text("Save child info",
                      style: TextStyle(color: Colors.white)),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
