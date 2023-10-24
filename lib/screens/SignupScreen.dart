import 'dart:io';

import 'package:dreams_come_true_app/screens/LoginScreen.dart';
import 'package:dreams_come_true_app/utils/Toast.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var logger = Logger();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _username = '';
  String _password = '';
  String _passwordConfirm = '';

  void _submitSignUpHandler() async {
    final dio = Dio();

    if (_password != _passwordConfirm) {
      showToast('비밀번호가 다릅니다.');
    }

    try {
      final apiUrl = '${dotenv.env['BASE_URL']}/auth/signup';

      final data = {
        'email': _email,
        'username': _username,
        'password': _password,
      };

      final response = await dio.post(apiUrl, data: data);

      if (response.statusCode == HttpStatus.created) {
        showToast('회원가입 성공');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      } else if (response.data['statusCode'] == HttpStatus.conflict) {
        showToast(response.data['message']);
      }
    } on DioException catch (e) {
      final response = e.response;
      if (response?.statusCode == HttpStatus.conflict) {
        showToast(response?.data['message']);
      } else {
        showToast('잠시후 다시 시도해주세요');
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
              color: Colors.black,
              image: DecorationImage(
                  image: AssetImage('assets/images/category5.png'),
                  opacity: 0.3,
                  fit: BoxFit.cover)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 10),
            child: Column(
              children: [
                Container(
                  child: const Column(children: <Widget>[
                    Text(
                      'Hello!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Sign up to start drawing to your dreams',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 40),
                  ]),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(),
                        child: Column(children: <Widget>[
                          TextFormField(
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                decorationThickness: 0),
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: const TextStyle(color: Colors.white),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.0),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.0),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                              ),
                            ),
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
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                decorationThickness: 0),
                            decoration: InputDecoration(
                              labelText: 'Username',
                              labelStyle: const TextStyle(color: Colors.white),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.0),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.0),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return '사용자 이름 입력하세요.';
                              }
                              return null;
                            },
                            onChanged: (value) => _username = value,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            obscureText: true,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                decorationThickness: 0),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: const TextStyle(color: Colors.white),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.0),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.0),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return '비밀번호를 입력하세요.';
                              }
                              return null;
                            },
                            onChanged: (value) => _password = value,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            obscureText: true,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                decorationThickness: 0),
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              labelStyle: const TextStyle(color: Colors.white),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.0),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.0),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return '비밀번호를 입력하세요.';
                              }
                              return null;
                            },
                            onChanged: (value) => _passwordConfirm = value,
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      _submitSignUpHandler();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple),
                    child: const Center(
                      child: Text(
                        'Register',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          margin:
                              const EdgeInsets.only(left: 10.0, right: 20.0),
                          child: const Divider(
                            color: Colors.white,
                            height: 36,
                          )),
                    ),
                    const Text("OR", style: TextStyle(color: Colors.white)),
                    Expanded(
                      child: Container(
                          margin:
                              const EdgeInsets.only(left: 20.0, right: 10.0),
                          child: const Divider(
                            color: Colors.white,
                            height: 36,
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _submitSignUpHandler();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow),
                        child: const Center(
                          child: Text(
                            'Kakao',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _submitSignUpHandler();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white),
                        child: const Center(
                          child: Text(
                            'Google',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  child: const Text(
                    'Already an account? LogIn',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
