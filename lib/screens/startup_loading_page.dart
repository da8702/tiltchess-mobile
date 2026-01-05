import 'package:flutter/material.dart';

class StartupLoadingPage extends StatelessWidget {
  const StartupLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'No',
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: 'Tilt ',
                style: TextStyle(color: Color(0xFFB71C1C)),
              ),
              TextSpan(
                text: 'Chess',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}
