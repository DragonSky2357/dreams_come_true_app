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
          final LocalStorage storage = LocalStorage('user');

          await storage.ready;

          storage.setItem('avatar', response.data['avatar']);
          storage.setItem('username', response.data['username']);
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
              color: Colors.black,
              image: DecorationImage(
                  image: AssetImage('assets/images/category7.png'),
                  opacity: 0.3,
                  fit: BoxFit.cover)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 100, 20, 10),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome back',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Sign in to discover, watch, and enjoy of dreams',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
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
                          onChanged: (value) {
                            _password = value;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Column(children: [
                  GestureDetector(
                      onTap: () {
                        _submitLogInHandler();
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.deepPurple),
                        child: const Center(
                            child: Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white),
                        )),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Forget your password?',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
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
                          onPressed: () {},
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
                          onPressed: () {},
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
                ]),
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupScreen()));
                  },
                  child: const Text(
                    'Need an account? Register',
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
