import 'package:flutter/material.dart';

class CalmingCornerScreen extends StatefulWidget {
  const CalmingCornerScreen({super.key});

  @override
  State<CalmingCornerScreen> createState() => _CalmingCornerScreenState();
}

class _CalmingCornerScreenState extends State<CalmingCornerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String _instructionText = "Take a deep breath... (Inhale)";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10), // Total cycle: 10 seconds
    );

    _controller.addListener(() {
      setState(() {
        if (_controller.value < 0.4) {
          // 0 to 4 seconds: Inhale (scale up)
          _instructionText = "Take a deep breath... (Inhale)";
        } else if (_controller.value >= 0.4 && _controller.value < 0.6) {
          // 4 to 6 seconds: Hold
          _instructionText = "Hold your breath...";
        } else {
          // 6 to 10 seconds: Exhale (scale down)
          _instructionText = "Breathe out slowly... (Exhale)";
        }
      });
    });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA), // Light calming cyan
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF00796B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Calming Corner",
          style: TextStyle(
            color: Color(0xFF00796B),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Relaxation Time 🧘‍♂️",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF004D40),
              ),
            ),
            const SizedBox(height: 60),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                double scale = 1.0;
                if (_controller.value < 0.4) {
                  // Scale up from 1.0 to 2.0
                  scale = 1.0 + (_controller.value / 0.4);
                } else if (_controller.value >= 0.4 && _controller.value < 0.6) {
                  // Hold at 2.0
                  scale = 2.0;
                } else {
                  // Scale down from 2.0 to 1.0
                  scale = 2.0 - ((_controller.value - 0.6) / 0.4);
                }

                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF4DB6AC).withOpacity(0.6),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF80CBC4).withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 80),
            Text(
              _instructionText,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFF00695C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
