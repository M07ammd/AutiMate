import 'package:flutter/material.dart';
import 'people_learning_screen.dart';
import 'school_learning_screen.dart';
import 'conversation_learning_screen.dart';
import 'numbers_learning_screen.dart';
import 'animals_learning_screen.dart';
import 'colors _screen.dart';
import 'eglish_alphabet_screen.dart';
import 'package:atuimate_app/screens/child/child_home_screen.dart';

class LearningScreen extends StatelessWidget {
  const LearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ================= APP BAR =================
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xff0F172A),
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ChildHomeScreen(),
              ),
            );
          },
        ),

        title: const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            "Learning",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0E2A47),
            ),
          ),
        ),
      ),
      // ================= BODY =================
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5F0), // Very light mint/light green
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 17,
              mainAxisSpacing: 17,
            ),
            itemCount: 8,
            itemBuilder: (context, index) {
              final items = [
                LearningGridItem(
                  title: 'People',
                  image: 'assets/images/people.png',
                  onTap: () => _navigateToScreen(context, 'people'),
                ),
                LearningGridItem(
                  title: 'School',
                  image: 'assets/images/school.png',
                  onTap: () => _navigateToScreen(context, 'school'),
                ),
                LearningGridItem(
                  title: 'Animals',
                  image: 'assets/images/animals.jpg',
                  onTap: () => _navigateToScreen(context, 'animals'),
                ),
                LearningGridItem(
                  title: 'Colors',
                  image: 'assets/images/colors.jpg',
                  onTap: () => _navigateToScreen(context, 'colors'),
                ),
                LearningGridItem(
                  title: 'Numbers',
                  image: 'assets/images/numbers.jpg',
                  onTap: () => _navigateToScreen(context, 'numbers'),
                ),
                LearningGridItem(
                  title: 'Arabic\nAlphabet',
                  image: 'assets/images/arabic_alphabet.jpg',
                  onTap: () => _navigateToScreen(context, 'arabic_alphabet'),
                ),
                LearningGridItem(
                  title: 'English\nAlphabet',
                  image: 'assets/images/english_alphabet.png',
                  onTap: () => _navigateToScreen(context, 'english_alphabet'),
                ),
                LearningGridItem(
                  title: 'Conversation',
                  image: 'assets/images/conversation.png',
                  onTap: () => _navigateToScreen(context, 'conversation'),
                ),
              ];
              return items[index];
            },
          ),
        ),
      ),
    );
  }

  void _navigateToScreen(BuildContext context, String screenName) {
    switch (screenName) {
      case 'people':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PeopleLearningScreen()),
        );
        break;
      case 'school':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SchoolLearningScreen()),
        );
        break;
      case 'conversation':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ConversationLearningScreen()),
        );
        break;
      case 'numbers':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NumbersLearningScreen()),
        );
        break;
      case 'colors':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ColorsScreen()),
        );
        break;
      case 'arabic_alphabet':
        Navigator.pushNamed(context, '/arabic_alphabet');
        break;
      case 'english_alphabet':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EnglishAlphabetScreen()),
        );
        break;
      case 'animals':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AnimalsLearningScreen()),
        );
        break;
      default:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Navigating to $screenName')));
    }
  }
}

// ==================== LEARNING CARD WIDGET ====================
class LearningGridItem extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onTap;

  const LearningGridItem({
    required this.title,
    required this.image,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(51),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image Container
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Image.asset(
                  image,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[400],
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Title Text
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF1B3A6B), // Dark blue
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'NotoSans',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
