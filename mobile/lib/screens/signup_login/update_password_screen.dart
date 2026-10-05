import 'package:flutter/material.dart';
import '../../../services/api_service.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() =>
      _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  bool showPass1 = false;
  bool showPass2 = false;

  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  bool loading = false;

  String? passError;
  String? confirmError;

  void validate() {
    setState(() {
      passError = null;
      confirmError = null;

      if (passController.text.isEmpty) {
        passError = "Required";
      }

      if (confirmController.text.isEmpty) {
        confirmError = "Required";
      }

      if (passController.text.isNotEmpty &&
          confirmController.text.isNotEmpty &&
          passController.text != confirmController.text) {
        confirmError = "Passwords do not match";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String resetToken =
        ModalRoute.of(context)?.settings.arguments as String? ?? "";

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Update Your Password",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D3557),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 35),

            /// PASSWORD
            const Text(
              "Password",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D3557),
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: passController,
              obscureText: !showPass1,
              onChanged: (_) => validate(),
              decoration: InputDecoration(
                hintText: "password",
                errorText: passError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: passError != null ? Colors.red : Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: passError != null
                        ? Colors.red
                        : const Color(0xFF45BB89),
                  ),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    showPass1
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      showPass1 = !showPass1;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// CONFIRM PASSWORD
            const Text(
              "Confirm password",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D3557),
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: confirmController,
              obscureText: !showPass2,
              onChanged: (_) => validate(),
              decoration: InputDecoration(
                hintText: "confirm password",
                errorText: confirmError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: confirmError != null
                        ? Colors.red
                        : Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: confirmError != null
                        ? Colors.red
                        : const Color(0xFF45BB89),
                  ),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    showPass2
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      showPass2 = !showPass2;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 35),

            /// BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: loading
                    ? null
                    : () async {
                  validate();

                  if (passError != null || confirmError != null) {
                    return;
                  }

                  setState(() => loading = true);

                  try {
                    await ApiService.resetPassword(
                      token: resetToken,
                      newPassword: passController.text,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Password updated successfully ✔️",
                        ),
                      ),
                    );

                    Future.delayed(
                      const Duration(seconds: 3),
                          () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          "/login",
                              (route) => false,
                        );
                      },
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Something went wrong"),
                      ),
                    );
                  }

                  setState(() => loading = false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF45BB89),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: loading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text(
                  "Reset password",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}