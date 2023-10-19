import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dreams_come_true_app/screens/HomeScreen.dart';
import 'package:dreams_come_true_app/screens/MainScreen.dart';
import 'package:dreams_come_true_app/screens/SignupScreen.dart';
import 'package:dreams_come_true_app/utils/Toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:localstorage/localstorage.dart';
import 'package:logger/logger.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var logger = Logger();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void _submitLogInHandler() async {
    if (_formKey.currentState!.validate()) {
      // todo 로그인 로직 수행

      final dio = Dio();

      try {
        final apiUrl = '${dotenv.env['BASE_URL']}/auth/login';

        final data = {'email': _email, 'password': _password};

        final response = await dio.post(apiUrl, data: data);

        if (response.statusCode == HttpStatus.ok) {
          final LocalStorage storage = LocalStorage('token');
          await storage.ready;

          storage.setItem('access_token', response.data['access_token']);
          storage.setItem('refresh_token', response.data['refresh_token']);

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const MainScreen()));
        } else if (response.data['statusCode'] == HttpStatus.unauthorized) {
          showToast(response.data['message']);
        }
      } on DioException catch (e) {
        final response = e.response;
        if (response?.statusCode == HttpStatus.unauthorized) {
          showToast('입력된 정보가 틀립니다. 다시 시도해주세요');
        } else {
          showToast('잠시후 다시 시도해주세요');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/BackgroundLogin.jpg'),
                  fit: BoxFit.cover)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Column(
              children: <Widget>[
                const Expanded(
                  flex: 2,
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'DREAMS COME TRUE',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 38,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            '당신의 꿈을 들려주세요',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    width: double.infinity,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                decorationThickness: 0),
                            decoration: const InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white))),
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return '이메일을 입력하세요.';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _email = value;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            obscureText: true,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                decorationThickness: 0),
                            decoration: const InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white))),
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return '비밀번호를 입력하세요.';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _password = value;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(children: [
                    GestureDetector(
                        onTap: () {
                          _submitLogInHandler();
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white70),
                          child: const Center(child: Text('LOG IN')),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignupScreen()));
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.amber),
                          child: const Center(
                              child: Text(
                            'SIGN UP',
                            style: TextStyle(color: Colors.white),
                          )),
                        )),
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
