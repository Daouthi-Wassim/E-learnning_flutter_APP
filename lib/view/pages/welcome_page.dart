import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../const/constants.dart';
import 'login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lotties/Home 3D Icon.json',
              fit: BoxFit.contain,
              repeat: true,
              animate: true,
            ),
            const SizedBox(height: 20),
            Text('Welcome to the app', style: textStyles.titleStyle),

            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
