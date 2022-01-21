import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isloading = false;
  List articleList = [];
  fetchArticle() async {
    setState(() {
      isloading = true;
    });
    try {
      final res = await get(Uri.parse(
          "https://newsapi.org/v2/everything?domains=wsj.com&apiKey=c30132447ba64b368ac062978176570a"));
      Map data = jsonDecode(res.body);

      if (data['status'] == 'ok') {
        articleList = data['articles'];

        setState(() {
          isloading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchArticle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('News Api'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 800,
          width: double.infinity,
          child: isloading == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: articleList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(8),
                      height: 120,
                      child: Row(
                        children: [
                          Card(
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24)),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Image.network(
                                articleList[index]["urlToImage"],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Column(
                              children: [
                                Text(
                                  articleList[index]["author"],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  articleList[index]["title"],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  articleList[index]["description"],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text("Published At -"),
                                Text(
                                  articleList[index]["publishedAt"],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
