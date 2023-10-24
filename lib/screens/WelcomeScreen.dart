import 'package:dreams_come_true_app/screens/LoginScreen.dart';
import 'package:dreams_come_true_app/screens/SignupScreen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
                image: AssetImage('assets/images/category3.png'),
                opacity: 0.4,
                fit: BoxFit.cover)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const Text(
                  'Dreams Come True',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your dreams draw them and make them',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple),
                      child: const Text('Get started')),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  child: const Text('I aready have an account',
                      style: TextStyle(color: Colors.white)),
                )
              ]),
        ),
      ),
    ));
  }
}
