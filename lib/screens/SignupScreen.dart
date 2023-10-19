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
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('홈 화면'),
        ),
        body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/BackgroundSignUp.jpg'),
                fit: BoxFit.cover),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(),
                      child: Column(children: <Widget>[
                        TextFormField(
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              decorationThickness: 0),
                          decoration: const InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white))),
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
                        const SizedBox(height: 40),
                        TextFormField(
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              decorationThickness: 0),
                          decoration: const InputDecoration(
                              labelText: 'Username',
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white))),
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return '사용자 이름 입력하세요.';
                            }
                            return null;
                          },
                          onChanged: (value) => _username = value,
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          obscureText: true,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                          decoration: const InputDecoration(
                              labelText: 'password',
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white))),
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return '비밀번호를 입력하세요.';
                            }
                            return null;
                          },
                          onChanged: (value) => _password = value,
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          obscureText: true,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                          decoration: const InputDecoration(
                              labelText: 'Password Confirm',
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white))),
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
                  ),
                  Expanded(
                    flex: 0,
                    child: GestureDetector(
                      onTap: () {
                        _submitSignUpHandler();
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
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
