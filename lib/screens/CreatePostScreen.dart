import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:dreams_come_true_app/screens/HomeScreen.dart';
import 'package:dreams_come_true_app/utils/Toast.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  var logger = Logger();

  String _image = '';
  bool _isLoadingImage = false;

  String _title = '';
  String _describe = '';
  final List<String> _tags = [];
  final _tagsController = TextEditingController();

  Future<void> _onClickImageCreateHandler() async {
    setState(() {
      _isLoadingImage = true;
    });

    final dio = Dio();

    try {
      final apiUrl = '${dotenv.env['BASE_URL']}/post/createimage';

      final LocalStorage storage = LocalStorage('token');
      await storage.ready;

      final token = storage.getItem('access_token') as String;

      final data = {
        'title': _title,
      };

      final response = await dio.post(apiUrl,
          data: data,
          options: Options(headers: {'authorization': 'Bearer $token'}));

      if (response.statusCode == HttpStatus.created) {
        setState(() {
          _image = response.data['image'];
          _isLoadingImage = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingImage = false;
      });
      showToast('잠시후 다시 시도해주세요');
    }
  }

  Future<void> _onClickSubmitHandler(BuildContext context) async {
    bool result = false;

    AlertDialog alert = AlertDialog(
      title: const Text('당신의 꿈을 공유할까요?'),
      actions: [
        TextButton(
          onPressed: () {
            result = false;
            Navigator.of(context).pop();
          },
          child: const Text("아직이요..."),
        ),
        TextButton(
          onPressed: () {
            result = true;
            Navigator.of(context).pop();
          },
          child: const Text("좋아요!!!"),
        )
      ],
    );

    await showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    final dio = Dio();

    if (result == true) {
      try {
        final apiUrl = '${dotenv.env['BASE_URL']}/post';

        final LocalStorage storage = LocalStorage('token');
        await storage.ready;

        final token = storage.getItem('access_token') as String;

        final data = {
          'title': _title,
          'describe': _describe,
          'tags': _tags,
          'image': _image
        };

        final response = await dio.post(apiUrl,
            data: data,
            options: Options(headers: {'authorization': 'Bearer $token'}));

        if (response.statusCode == HttpStatus.created) {
          showToast('포스트 생성 성공!!!');
          Navigator.pop(context);
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
        appBar: AppBar(
          title: const Text('New Dream'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                _onClickSubmitHandler(context);
              },
            )
          ],
          elevation: 0,
          backgroundColor: Colors.black,
        ),
        bottomSheet: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(),
                        child: Column(children: <Widget>[
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Upload Picture',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                              width: double.infinity,
                              height: 300,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10)),
                              child: _isLoadingImage
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : _image.isEmpty
                                      ? const SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: Center(
                                              child: Icon(Icons.download,
                                                  size: 50,
                                                  color: Colors.black)))
                                      : Image.network(
                                          '${dotenv.env['IMAGE_BASE_URL']}/$_image',
                                          fit: BoxFit.fill)),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    _onClickImageCreateHandler();
                                  },
                                  child: const Text(
                                    'Image Create',
                                    style: TextStyle(fontSize: 16),
                                  )),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: const Text(
                                    'Download Image',
                                    style: TextStyle(fontSize: 16),
                                  )),
                            ],
                          )
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          child: Column(children: [
                            Container(
                              decoration: const BoxDecoration(),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    width: double.infinity,
                                    decoration: const BoxDecoration(),
                                    child: Column(
                                      children: <Widget>[
                                        const Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            'Title',
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        TextFormField(
                                          maxLines: 5,
                                          style: const TextStyle(
                                              decorationThickness: 0),
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.zero,
                                            hintText: '제목을 입력하세요',
                                          ),
                                          validator: (value) {
                                            if (value != null &&
                                                value.isEmpty) {
                                              return '제목을 입력하세요.';
                                            }
                                            return null;
                                          },
                                          onChanged: (value) =>
                                              {_title = value},
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    width: double.infinity,
                                    decoration: const BoxDecoration(),
                                    child: Column(
                                      children: <Widget>[
                                        const Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            'Describe',
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        TextFormField(
                                          maxLines: 8,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            contentPadding: EdgeInsets.zero,
                                            hintText: '내용을 입력하세요',
                                          ),
                                          validator: (value) {
                                            if (value != null &&
                                                value.isEmpty) {
                                              return '내용을 입력하세요.';
                                            }
                                            return null;
                                          },
                                          onChanged: (value) =>
                                              {_describe = value},
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    width: double.infinity,
                                    decoration: const BoxDecoration(),
                                    child: Column(
                                      children: <Widget>[
                                        const Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            'Tag',
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        TextFormField(
                                          controller: _tagsController,
                                          onFieldSubmitted: (value) {
                                            if (_tags.length >= 6) {
                                              showToast('태그는 6개가 최대입니다.');
                                              return;
                                            }
                                            setState(() {
                                              _tags.add(value);
                                            });
                                            _tagsController.clear();
                                          },
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                            ),
                                            contentPadding: EdgeInsets.zero,
                                            hintText: '테그를 입력하세요',
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Wrap(
                                            children: _tags.map((tag) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: Chip(
                                                  label: Text(tag),
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          Random().nextInt(256),
                                                          Random().nextInt(256),
                                                          Random().nextInt(256),
                                                          Random()
                                                              .nextInt(256)),
                                                  onDeleted: () {
                                                    setState(() {
                                                      _tags.remove(tag);
                                                    });
                                                  },
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ]),
                        ),
                      )
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
