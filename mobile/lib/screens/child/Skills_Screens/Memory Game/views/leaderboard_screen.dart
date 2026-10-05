import 'package:flutter/material.dart';
import 'package:atuimate_app/services/api_service.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List players = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getLeaderboard();
  }

  Future<void> getLeaderboard() async {
    try {
      final response =
      await ApiService.dio.get("/games/leaderboard/MEMORY");

      setState(() {
        players = response.data;
        isLoading = false;
      });
    } catch (e) {
      print("Error ❌: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🏆 Leaderboard")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: players.length,
        itemBuilder: (context, index) {
          final player = players[index];

          return ListTile(
            leading: CircleAvatar(
              child: Text("${index + 1}"),
            ),
            title: Text(player["name"] ?? "Player"),
            subtitle: Text("Score: ${player["score"]}"),
          );
        },
      ),
    );
  }
}
