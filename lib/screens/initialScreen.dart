import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dreams_come_true_app/screens/HomeScreen.dart';
import 'package:dreams_come_true_app/screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class InitalScreen extends StatefulWidget {
  const InitalScreen({super.key});

  @override
  State<InitalScreen> createState() => _InitalScreenState();
}

class _InitalScreenState extends State<InitalScreen> {
  var logger = Logger();

  Future<String?> _fetchLoadInitalData() async {
    final LocalStorage storage = LocalStorage('token');
    await storage.ready;

    final data = storage.getItem('access_token');
    return data as String?;
  }

  Future<bool> _fetchAccessTokenCheck() async {
    final dio = Dio();

    try {
      final apiUrl = '${dotenv.env['BASE_URL']}/auth/check';

      final LocalStorage storage = LocalStorage('token');
      await storage.ready;

      final token = storage.getItem('access_token') as String;
      dio.options.headers['Authorization'] = "Bearer $token";

      final response = await dio.get(apiUrl);

      if (response.data['statusCode'] == HttpStatus.ok) {
        return true;
      } else {
        final LocalStorage storage = LocalStorage('token');
        await storage.ready;
        storage.deleteItem('access_token');
        return false;
      }
    } catch (e) {
      final LocalStorage storage = LocalStorage('token');
      await storage.ready;
      storage.deleteItem('access_token');
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: _fetchLoadInitalData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('오류 발생: ${snapshot.error}');
            } else {
              final token = snapshot.data;

              if (token != null) {
                _fetchAccessTokenCheck().then((value) => {
                      if (value == true)
                        {const HomeScreen()}
                      else
                        {const LoginScreen()}
                    });
                return const LoginScreen();
              } else {
                return const LoginScreen();
              }
            }
          },
        ),
      ),
    );
  }
}
