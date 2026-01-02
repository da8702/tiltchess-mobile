import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supa = Supabase.instance.client;
    final user = supa.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TiltChess'),
        actions: [
          TextButton(
            onPressed: () => supa.auth.signOut(),
            child: const Text('Sign out'),
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Logged in as:\n${user?.email}',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}