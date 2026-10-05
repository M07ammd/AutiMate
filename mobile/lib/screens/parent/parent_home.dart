import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:atuimate_app/screens/parent/community_screen.dart';
import 'package:atuimate_app/screens/child/settings/settings_screen.dart';
import 'package:atuimate_app/screens/signup_login/child_signup_screen.dart';
import 'package:atuimate_app/services/api_service.dart';
import 'package:atuimate_app/screens/parent/chat_bot_screen.dart';
import 'package:atuimate_app/screens/parent/articles_section.dart';
import 'package:atuimate_app/screens/child/routine/report.dart';
import 'package:atuimate_app/screens/parent/progressscreen.dart';
import 'package:atuimate_app/screens/notifications_screen.dart';

class ParentHome extends StatefulWidget {
  const ParentHome({super.key});

  @override
  State<ParentHome> createState() => _ParentHomeState();
}

class _ParentHomeState extends State<ParentHome> {
  int currentIndex = 0;

  double gamesScore = 0;
  double tasksPercent = 0;

  List children = [];
  bool isLoading = true;

  late List<Widget> screens;

  @override
  void initState() {
    super.initState();

    screens = [
      homeBody(),
      const CommunityScreen(),
      const ParentReportScreen(),
      const ProgressScreen(),
      const SettingsScreen(),
    ];
    fetchChildren();
    fetchHomeData();
  }
  Future<void> fetchHomeData() async {
    try {
      final reports = await ApiService.getProgressReports();
      final today = reports['today'] ?? {};
      tasksPercent = ((today['percentage'] ?? 0)).toDouble();
      final games = reports['weeklyGames'] ?? [];
      if (games.isNotEmpty) {
        double total = 0;
        for (var g in games) {
          total += (g['score'] ?? 0).toDouble();
        }
        gamesScore = total / games.length;
      } else {gamesScore = 0;}
      setState(() {});
    } catch (e) {print("HOME ERROR ❌ $e");}
  }
  Future<void> fetchChildren() async {
    try {
      setState(() => isLoading = true);

      final response = await ApiService.getMyChildren();

      if (response.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        String? currentChildId = prefs.getString("childId");
        
        if (currentChildId == null || currentChildId.isEmpty) {
          String firstId = response[0]["id"] ?? response[0]["_id"] ?? "";
          if (firstId.isNotEmpty) {
            await prefs.setString("childId", firstId);
            fetchHomeData();
          }
        }
      }

      setState(() {
        children = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    screens[0] = homeBody();

    return Scaffold(
      backgroundColor: const Color(0xffF4F6F6),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: const Color(0xFF45BB89),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: "Community"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Reports"),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "Progress"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],),
      body: SafeArea(child: screens[currentIndex]),
    );}
  Widget homeBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ChatBotScreen()),
                  );
                },
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationsScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(width: 10),

                  const CircleAvatar(
                    backgroundImage: AssetImage(
                      "assets/images/profile.png",
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xff6CC4A1), Color(0xff45BB89)],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              children: [
                const Text(
                  "Child Progress",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Today’s Summary",
                  style: TextStyle(color: Colors.white70),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    progressCard("Games", gamesScore),
                    progressCard("Tasks", tasksPercent),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              featureCard(Icons.description, "Daily Report", () {
                setState(() => currentIndex = 2);
              }),
              featureCard(Icons.show_chart, "Progress Dashboard", () {
                setState(() => currentIndex = 3);
              }),
            ],
          ),

          const SizedBox(height: 25),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Manage Children",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF45BB89),
                      ),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ChildSignUpScreen(),
                          ),
                        );

                        if (result == true) fetchChildren();
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Add Child"),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                isLoading
                    ? const CircularProgressIndicator()
                    : Column(
                  children: children.map((child) {
                    return ListTile(
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        String id = child["id"] ?? child["_id"] ?? "";
                        if (id.isNotEmpty) {
                          await prefs.setString("childId", id);
                          fetchHomeData();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Selected child: ${child["childName"]}")),
                          );
                        }
                      },
                      leading: const CircleAvatar(
                        child: Icon(Icons.child_care),
                      ),
                      title: Text(child["childName"] ?? "My Child"),
                      subtitle: Text(
                        "Tap to select and view progress",
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const ArticlesSection(),
        ],
      ),
    );
  }

  Widget progressCard(String title, double value) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(title),

          const SizedBox(height: 10),

          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 70,
                width: 70,
                child: CircularProgressIndicator(
                  value: (value / 100).clamp(0, 1),
                  strokeWidth: 7,
                  backgroundColor: Colors.grey.shade200,
                  color: const Color(0xFF45BB89),
                ),
              ),
              Text(
                "${value.toInt()}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget featureCard(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF45BB89),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}