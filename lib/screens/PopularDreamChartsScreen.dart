import 'package:dio/dio.dart';
import 'package:dreams_come_true_app/models/RankingPost.dart';
import 'package:dreams_come_true_app/screens/PostScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:localstorage/localstorage.dart';
import 'package:logger/logger.dart';

class PopularDreamChartsScreen extends StatefulWidget {
  const PopularDreamChartsScreen({super.key});

  @override
  State<PopularDreamChartsScreen> createState() =>
      _PopularDreamChartsScreenState();
}

class _PopularDreamChartsScreenState extends State<PopularDreamChartsScreen> {
  var logger = Logger();

  Future<List<RankingPost?>?> fetchData() async {
    final dio = Dio();

    try {
      final apiUrl = '${dotenv.env['BASE_URL']}/post/ranking';

      final LocalStorage storage = LocalStorage('user');
      await storage.ready;

      final token = storage.getItem('access_token') as String;

      final response = await dio.get(apiUrl,
          options: Options(headers: {'authorization': 'Bearer $token'}));

      final data = response.data;

      final List<RankingPost> rankingPosts = [];

      data.forEach((data) {
        RankingPost post = RankingPost(
            id: data['id'],
            title: data['title'],
            image: data['image'],
            writer: Writer.fromJson(data['writer']));

        rankingPosts.add(post);
      });

      return rankingPosts;
    } catch (e) {
      logger.e(e);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () {},
            ),
            // CircleAvatar(
            //   backgroundImage: NetworkImage(
            //     '${dotenv.env['IMAGE_BASE_URL']}/avatar/$_avatar',
            //   ),
            // )
          ],
        ),
        body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(color: Colors.black),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(children: <Widget>[
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Popular Dream Top 20',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                child: FutureBuilder(
                  future: fetchData(),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('에러: ${snapshot.error}');
                    } else {
                      List<RankingPost?>? data = snapshot.data!;

                      return Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PostScreen(
                                              id: '${data[index]?.id}')));
                                },
                                child: SizedBox(
                                  height: 80,
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 0),
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                          width: 100,
                                          '${dotenv.env['IMAGE_BASE_URL']}/images/w200&h300/${data[index]?.image}',
                                          fit: BoxFit.cover),
                                    ),
                                    title: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${data[index]?.writer?.username}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '${data[index]?.title}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    trailing: const SizedBox(
                                      height: double.infinity,
                                      child: Icon(
                                        Icons.keyboard_arrow_right_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      );
                    }
                  }),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
