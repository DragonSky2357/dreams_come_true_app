import 'package:dio/dio.dart';
import 'package:dreams_come_true_app/models/Post.dart';
import 'package:dreams_come_true_app/utils/Toast.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:localstorage/localstorage.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PostScreen extends StatefulWidget {
  final String id;

  const PostScreen({super.key, required this.id});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  var logger = Logger();
  late String? username = "";

  Future<Post?> _fetchPostData() async {
    final dio = Dio();
    final postId = widget.id;

    try {
      final apiUrl = '${dotenv.env['BASE_URL']}/post/$postId';

      final LocalStorage storage = LocalStorage('token');
      await storage.ready;

      final token = storage.getItem('access_token') as String;

      final response = await dio.get(apiUrl,
          options: Options(headers: {'authorization': 'Bearer $token'}));

      final data = response.data;

      Post post = Post.fromJson(data);
      username = post.writer?.username;

      return post;
    } catch (e) {
      logger.e(e);
    }
    return null;
  }

  Future<void> _onClickFavoriteHandler() async {
    final dio = Dio();
    final postId = widget.id;

    try {
      final apiUrl = '${dotenv.env['BASE_URL']}/post/$postId/like';

      final LocalStorage storage = LocalStorage('token');
      await storage.ready;

      final token = storage.getItem('access_token') as String;

      final response = await dio.patch(apiUrl,
          options: Options(headers: {'authorization': 'Bearer $token'}));

      final data = response.data;

      showToast('$username님께 전달할게요❤️');
    } catch (e) {
      logger.e(e);
    }
    return;
  }

  Widget _floatingCollapsed() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
      ),
      child: const Center(
        child: Text(
          "자세히 보기",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  Widget _floatingPanel(String descibe) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(24.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child:
            Text(descibe ?? "내용이 없어요ㅠㅠ", style: const TextStyle(fontSize: 14)),
      ),
    );
  }

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    final panelHeightOpen = MediaQuery.of(context).size.height * .80;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: FutureBuilder(
            future: _fetchPostData(),
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
                  child: Column(children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Stack(children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    '${dotenv.env['IMAGE_BASE_URL']}/images/w400&h500/${data?.image}'),
                                fit: BoxFit.cover),
                          ),
                        ),
                        Positioned(
                          top: 20,
                          right: 20,
                          child: Column(children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.download_for_offline),
                              color: Colors.white,
                              iconSize: 30,
                              onPressed: () {
                                logger.d('123');
                              },
                            ),
                            const SizedBox(height: 20),
                            IconButton(
                              icon: const Icon(Icons.favorite_border),
                              color: Colors.white,
                              iconSize: 30,
                              onPressed: () {
                                _onClickFavoriteHandler();
                              },
                            ),
                          ]),
                        )
                      ]),
                    ),
                    Expanded(
                      flex: 5,
                      child: Stack(children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          width: double.infinity,
                          decoration: const BoxDecoration(),
                          child: Column(children: <Widget>[
                            Container(
                              width: double.infinity,
                              height: 50,
                              decoration: const BoxDecoration(),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: Row(
                                        children: [
                                          Text(
                                              DateFormat('yyyy-MM-dd')
                                                  .parse('${data?.createdAt}')
                                                  .toString()
                                                  .split(' ')[0],
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                    const VerticalDivider(
                                        color: Colors.grey, thickness: 2),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.visibility,
                                              size: 20),
                                          const SizedBox(width: 10),
                                          Text('${data?.views}',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                    const VerticalDivider(
                                        color: Colors.grey, thickness: 2),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.favorite, size: 20),
                                          const SizedBox(width: 10),
                                          Text('${data?.likes}',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                            Container(
                              width: double.infinity,
                              height: 70,
                              decoration: const BoxDecoration(),
                              child: Row(children: <Widget>[
                                CircleAvatar(
                                  minRadius: 26,
                                  backgroundImage: NetworkImage(
                                      '${dotenv.env['IMAGE_BASE_URL']}/avatar/${data?.writer?.avatar}'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('${data?.writer?.username!}',
                                          style: const TextStyle(fontSize: 20)),
                                      const Text('followers 300k',
                                          style: TextStyle(fontSize: 12))
                                    ],
                                  ),
                                )
                              ]),
                            ),
                            Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(
                                      height: 20,
                                      thickness: 1,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text('${data?.title}',
                                        style: const TextStyle(
                                            color: Colors.indigo,
                                            fontSize: 15)),
                                    SizedBox(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.only(top: 10),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: data?.tags?.length as int,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: () {},
                                            child: Text(
                                              '#${data?.tags?[index].name} ',
                                              style: const TextStyle(
                                                  color: Colors.blue),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ]),
                            ),
                            Container(
                                child: const Row(
                              children: <Widget>[
                                Text('1',
                                    style: TextStyle(color: Colors.black)),
                                Text('2'),
                                Text('3'),
                              ],
                            ))
                          ]),
                        ),
                        SlidingUpPanel(
                          minHeight: 60,
                          maxHeight: MediaQuery.of(context).size.height * 0.8,
                          renderPanelSheet: false,
                          collapsed: _floatingCollapsed(),
                          panel: _floatingPanel(data?.describe as String),
                        )
                      ]),
                    ),
                  ]),
                );
              }
            })),
      ),
    );
  }
}
