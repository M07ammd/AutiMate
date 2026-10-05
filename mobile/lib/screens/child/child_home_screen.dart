import 'package:flutter/material.dart';
import 'learning_screen.dart';
import 'Skills_Screens/skills_screen.dart';
import 'package:atuimate_app/screens/child/emotions/emotions_learn_screen.dart';
import 'CommunicationScreen .dart';
import 'routine/choose_routine_screen.dart';
import 'package:atuimate_app/screens/child/settings/settings_screen.dart';
import 'calming_corner_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:atuimate_app/widgets/ai_tracking_wrapper.dart';
import 'package:atuimate_app/screens/notifications_screen.dart';


class ChildHomeScreen extends StatefulWidget {
  const ChildHomeScreen({super.key});

  @override
  State<ChildHomeScreen> createState() => _ChildHomeScreenState();
}

class _ChildHomeScreenState extends State<ChildHomeScreen> {
  int _currentIndex = 0;
  String token = "";

  void _goToSkills() {
    setState(() {
      _currentIndex = 1;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchToken();
  }

  Future<void> fetchToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("accessToken") ?? "";
    setState(() {});
  }

  Widget _buildScreen() {
    switch (_currentIndex) {
      case 0:
        return _HomeBody(
          key: const ValueKey('home'),
          onGamesTap: _goToSkills,
          token: token,
        );
      case 1:
        return const SkillsScreen(key: ValueKey('skills'));
      case 2:
        return const ChooseRoutineScreen(key: ValueKey('routine'));
      case 3:
        return AITrackingWrapper(
          gameName: "Learning",
          child: const LearningScreen(key: ValueKey('learning')),
        );
      case 4:
        return const SettingsScreen(key: ValueKey('settings'));
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F8),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.2, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: _buildScreen(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Color(0xFF45BB89),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            );
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videogame_asset),
            label: "Skills",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Routine",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: "Learning",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  final VoidCallback onGamesTap;
  final String token;

  const _HomeBody({
    super.key,
    required this.onGamesTap,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                  ],
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                  child: const CircleAvatar(
                    backgroundImage:
                    AssetImage('assets/images/profilech.png'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: const DecorationImage(
                  image: AssetImage('assets/images/welcome.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _HomeCard(
                  title: "Emotions",
                  image: "assets/images/emotions.png",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AITrackingWrapper(
                          gameName: "Emotions",
                          child: EmotionsScreen(),
                        ),
                      ),
                    );
                  },
                ),
                _HomeCard(
                  title: "Games",
                  image: "assets/images/Games.png",
                  onTap: onGamesTap,
                ),
                _HomeCard(
                  title: "Communication",
                  image: "assets/images/Communication.png",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AITrackingWrapper(
                          gameName: "Communication",
                          child: CommunicationScreen(),
                        ),
                      ),
                    );
                  },
                ),
                _HomeCard(
                  title: "Routine",
                  image: "assets/images/routine.png",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChooseRoutineScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Daily Motivation Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xffFFF3E0),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xffFFE0B2), width: 2),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      'assets/images/profile.jpg',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Today's Message 🌟",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffE65100),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "You are an amazing hero today! Let's play and learn together!",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xffE65100),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Calming Corner Button
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CalmingCornerScreen(),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4DD0E1), Color(0xFF26C6DA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF26C6DA).withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.spa, color: Colors.white, size: 28),
                    SizedBox(width: 12),
                    Text(
                      "Calming & Relaxation Corner",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onTap;

  const _HomeCard({
    required this.title,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xffE8F4FF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Expanded(child: Image.asset(image)),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),          ],
        ),
      ),
    );
  }
}