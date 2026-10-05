import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:atuimate_app/services/api_service.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';
import 'faq_screen.dart';
import 'package:atuimate_app/screens/signup_login/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isNotificationsEnabled = true;

  String userName = "";
  bool isLoadingUser = true;

  bool isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    loadSettings();
    loadProfile();
  }

  // ================= PROFILE =================
  Future<void> loadProfile() async {
    try {
      final data = await ApiService.getProfile();

      setState(() {
        userName =
            data["fullName"] ??
                data["user"]?["fullName"] ??
                "User";

        isLoadingUser = false;
      });
    } catch (e) {
      print("PROFILE ERROR ❌ $e");
      setState(() => isLoadingUser = false);
    }
  }

  // ================= SETTINGS =================
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      isNotificationsEnabled =
          prefs.getBool('notifications') ?? true;
    });
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      'notifications',
      isNotificationsEnabled,
    );
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    try {
      await ApiService.logout();
    } catch (e) {
      print("Logout API error ❌ $e");
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
          (route) => false,
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: Column(
        children: [
          // 🔹 HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
              bottom: 40,
            ),
            decoration: const BoxDecoration(
              color: Color(0xff49B27D),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  "Settings",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -30),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                  ),
                ),
                child: ListView(
                  children: [
                    // 👤 USER
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(
                            "assets/images/profile.jpg",
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          isLoadingUser
                              ? "Loading..."
                              : userName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 30),

                    const Text(
                      "Account Settings",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 10),

                    ListTile(
                      leading:
                      const Icon(Icons.person_outline),
                      title:
                      const Text("Edit profile"),
                      trailing: const Icon(
                        Icons.chevron_right,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const EditProfileScreen(),
                          ),
                        );
                      },
                    ),

                    ListTile(
                      leading:
                      const Icon(Icons.lock_outline),
                      title: const Text(
                        "Change password",
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const ChangePasswordScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 15),

                    SwitchListTile(
                      title: const Text(
                        "Push notifications",
                      ),
                      value: isNotificationsEnabled,
                      activeColor:
                      const Color(0xff49B27D),
                      onChanged: (value) async {
                        setState(() {
                          isNotificationsEnabled =
                              value;
                        });

                        await saveSettings();
                      },
                    ),

                    const Divider(height: 30),

                    const Text(
                      "More",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 10),

                    ListTile(
                      leading:
                      const Icon(Icons.help_outline),
                      title: const Text("FAQs"),
                      trailing: const Icon(
                        Icons.chevron_right,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const FaqScreen(),
                          ),
                        );
                      },
                    ),

                    ListTile(
                      leading:
                      const Icon(Icons.share_outlined),
                      title: const Text(
                        "Share the app",
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                      ),
                      onTap: () {
                        Share.share(
                          "Check out this amazing app for kids learning!",
                        );
                      },
                    ),

                    // 🚨 LOGOUT
                    ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      title: const Text(
                        "Log out",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              AlertDialog(
                                title: const Text(
                                  "Confirm Logout",
                                ),
                                content: isLoggingOut
                                    ? const SizedBox(
                                  height: 50,
                                  child: Center(
                                    child:
                                    CircularProgressIndicator(),
                                  ),
                                )
                                    : const Text(
                                  "Are you sure you want to log out?",
                                ),
                                actions: isLoggingOut
                                    ? []
                                    : [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(
                                            context),
                                    child: const Text(
                                      "Cancel",
                                    ),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () async {
                                      setState(() {
                                        isLoggingOut =
                                        true;
                                      });

                                      await logout();

                                      setState(() {
                                        isLoggingOut =
                                        false;
                                      });
                                    },
                                    child:
                                    const Text(
                                      "Logout",
                                      style:
                                      TextStyle(
                                        color:
                                        Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}