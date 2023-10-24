import 'package:dio/dio.dart';
import 'package:dreams_come_true_app/models/HomePost.dart';
import 'package:dreams_come_true_app/screens/CreatePostScreen.dart';
import 'package:dreams_come_true_app/screens/PostScreen.dart';
import 'package:dreams_come_true_app/screens/ProfileScreen.dart';
import 'package:dreams_come_true_app/screens/SearchScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masonry_view/flutter_masonry_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:localstorage/localstorage.dart';
import 'package:logger/logger.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var logger = Logger();
  late String _avatar = "";
  late String _username = "";
  int _selectedIndex = 0;
  final int _index = 0;

  late ScrollController _scrollController;
  late double _scrollPosition;

  _scrollListener() {
    //logger.d(_scrollController.position.pixels);
    // setState(() {
    //   _scrollPosition = _scrollController.position.pixels;
    // });
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 40, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<List<HomeScreenPost>?> _fetchPostData() async {
    final dio = Dio();

    try {
      final apiUrl = '${dotenv.env['BASE_URL']}/post';

      final LocalStorage storage = LocalStorage('user');
      await storage.ready;

      final token = storage.getItem('access_token') as String;

      final response = await dio.get(apiUrl,
          options: Options(headers: {'authorization': 'Bearer $token'}));

      final data = response.data;

      final List<HomeScreenPost> homeScreenPost = [];

      data.forEach((data) {
        HomeScreenPost post = HomeScreenPost(
            id: data['id'],
            title: data['title'],
            image: data['image'],
            writer: data['writer']['username']);

        homeScreenPost.add(post);
      });

      return homeScreenPost;
    } catch (e) {
      logger.e(e);
    }
    return null;
  }

  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
  ];

  List<dynamic> categories = [
    {
      'category': 'All',
      'image': 'assets/images/category1.png',
    },
    {
      'category': 'A',
      'image': 'assets/images/category2.png',
    },
    {
      'category': 'B',
      'image': 'assets/images/category3.png',
    },
    {
      'category': 'C',
      'image': 'assets/images/category4.png',
    },
    {
      'category': 'D',
      'image': 'assets/images/category5.png',
    },
  ];

  Future<void> fetchUserInfo() async {
    final LocalStorage storage = LocalStorage('user');
    await storage.ready;

    _avatar = storage.getItem('avatar') as String;
    _username = storage.getItem('username') as String;
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    //_scrollController.addListener(_scrollListener)
    //fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome $_username'),
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
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(children: <Widget>[
              Container(
                width: double.infinity,
                height: 60,
                decoration: const BoxDecoration(),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(8),
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: AssetImage(categories[index]['image']),
                                fit: BoxFit.cover)),
                        padding: const EdgeInsets.all(6),
                        child: Center(
                            child: Text(
                          '${categories[index]['category']}',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )));
                  },
                  separatorBuilder: (BuildContext contxt, int index) =>
                      const SizedBox(width: 5),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: FutureBuilder(
                  future: _fetchPostData(),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('에러: ${snapshot.error}');
                    } else {
                      return SingleChildScrollView(
                        controller: _scrollController,
                        child: MasonryView(
                          listOfItem: snapshot.data!,
                          numberOfColumn: 2,
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
                      );
                    }
                  })),
            ),
          )
        ]),
      ),
    );
  }
}
