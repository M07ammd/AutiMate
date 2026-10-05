import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FAQs"),
        backgroundColor: const Color(0xff49B27D),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          ExpansionTile(
            title: Text("How to use the app?"),
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "You can explore learning, skills, and emotions easily from home screen.",
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text("Is the app free?"),
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Text("Yes, the basic version is free."),
              ),
            ],
          ),
          ExpansionTile(
            title: Text("How to contact support?"),
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Text("Email us at support@app.com"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
