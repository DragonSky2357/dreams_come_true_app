import 'package:dio/dio.dart';
import 'package:dreams_come_true_app/models/Profile.dart';
import 'package:dreams_come_true_app/screens/PostScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_masonry_view/flutter_masonry_view.dart';
import 'package:localstorage/localstorage.dart';
import 'package:logger/logger.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var logger = Logger();

  Future<Profile?> _fetchUserData() async {
    final dio = Dio();

    try {
      final apiUrl = '${dotenv.env['BASE_URL']}/user/profile';

      final LocalStorage storage = LocalStorage('token');
      await storage.ready;

      final token = storage.getItem('access_token') as String;

      final response = await dio.get(apiUrl,
          options: Options(headers: {'authorization': 'Bearer $token'}));

      final data = response.data;

      Profile profile = Profile.fromJson(data);

      return profile;
    } catch (e) {
      logger.e(e);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: FutureBuilder(
            future: _fetchUserData(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('에러: ${snapshot.error}');
              } else {
                final data = snapshot.data;

                return Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Container(
                              decoration: const BoxDecoration(),
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/BackgroundProfile.png'),
                                            fit: BoxFit.cover),
                                      ),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            CircleAvatar(
                                              radius: 50,
                                              backgroundImage: NetworkImage(
                                                  '${dotenv.env['IMAGE_BASE_URL']}/avatar/${data?.avatar}'),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              '${data?.username}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ]),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      decoration: const BoxDecoration(),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Column(
                                                  children: <Widget>[
                                                    Text(
                                                      '${data?.post?.length}',
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    const Text(
                                                      'Posts',
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    )
                                                  ],
                                                ),
                                                const Column(
                                                  children: <Widget>[
                                                    Text(
                                                      '831',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      'Following',
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    )
                                                  ],
                                                ),
                                                const Column(
                                                  children: <Widget>[
                                                    Text(
                                                      '1520',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      'Followers',
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 1,
                                                  child: ElevatedButton(
                                                    onPressed: () {},
                                                    child: const Center(
                                                      child: Text('Add Post'),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: ElevatedButton(
                                                    onPressed: () {},
                                                    child: const Center(
                                                      child:
                                                          Text('Edit Profile'),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ]),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                                decoration: const BoxDecoration(),
                                child: SingleChildScrollView(
                                  child: MasonryView(
                                    listOfItem: data!.post!,
                                    numberOfColumn: 3,
                                    itemBuilder: (item) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PostScreen(id: item.id)));
                                        },
                                        child: Image.network(
                                            '${dotenv.env['IMAGE_BASE_URL']}/images/w200&h300/${item.image}'),
                                      );
                                    },
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ));
              }
            }),
          )),
    );
  }
}
