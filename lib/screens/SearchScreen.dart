import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(28, 28, 30, 100),
                    borderRadius: BorderRadius.circular(10)),
                child: const TextField(
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      decorationThickness: 0),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    border: InputBorder.none,
                    hintText: "Enter a search dream",
                    hintStyle: TextStyle(fontSize: 20, color: Colors.white),
                    labelStyle: TextStyle(fontSize: 20),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              )
              // Align(
              //   alignment: Alignment.topLeft,
              //   child: Text(
              //     'Popular Dream Top 20',
              //     style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 20,
              //         fontWeight: FontWeight.bold),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
