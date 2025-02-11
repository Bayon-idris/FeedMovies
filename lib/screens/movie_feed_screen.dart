import 'package:flutter/material.dart';

class MovieFeedScreen extends StatelessWidget {
  const MovieFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Feed Movies")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Aucune notification pour le moment"),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
