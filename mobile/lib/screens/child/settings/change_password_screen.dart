import 'package:flutter/material.dart';
import 'package:atuimate_app/services/api_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController oldPass = TextEditingController();
  final TextEditingController newPass = TextEditingController();

  bool isLoading = false;

  /// 👁️ التحكم في إظهار/إخفاء الباسورد
  bool showOldPassword = false;
  bool showNewPassword = false;

  /// 🟢 تغيير كلمة السر
  Future<void> changePassword() async {
    if (oldPass.text.isEmpty || newPass.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields ❗")),
      );
      return;
    }

    setState(() => isLoading = true);

    bool success = await ApiService.changePassword(
      currentPassword: oldPass.text,
      newPassword: newPass.text,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password Changed Successfully 🔐")),
      );

      oldPass.clear();
      newPass.clear();

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Wrong password or error ❌")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
        backgroundColor: const Color(0xff49B27D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// 🔴 Old Password
            TextField(
              controller: oldPass,
              obscureText: !showOldPassword,
              decoration: InputDecoration(
                labelText: "Old Password",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    showOldPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      showOldPassword = !showOldPassword;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// 🟢 New Password
            TextField(
              controller: newPass,
              obscureText: !showNewPassword,
              decoration: InputDecoration(
                labelText: "New Password",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    showNewPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      showNewPassword = !showNewPassword;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// 🔘 Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff49B27D),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: isLoading ? null : changePassword,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Update Password"),
            ),
          ],
        ),
      ),
    );
  }
}