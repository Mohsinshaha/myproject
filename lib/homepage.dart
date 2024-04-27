import 'dart:convert';
import 'dart:developer';
import 'package:api_example/Models/news_model.dart';
import 'package:http/http.dart' as httpClient;
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageStateState();

}
class _HomePageStateState extends State<HomePage> {
  Future<News_Model> fetchNews() async {
    var url = "https://newsapi.org/v2/top-headlines?country=in&category=business&apiKey=458f747e4a0e47be8b213e1285669c20";
    var response = await httpClient.get(Uri.parse(url));
    if(response.statusCode == 200){
      log(response.body);
      var result = jsonDecode(response.body);
      return News_Model.fromJson(result);
    }
    else{
      log('error');
      return News_Model();
    }
  }
  @override
  void initState() {
    super.initState();
    fetchNews();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: fetchNews(),
        builder: (_, snapshot){
          if(snapshot.hasData){
            return ListView.builder(
                itemBuilder: (context, index){
                return Card(
                  elevation: 7,
                  child: ListTile(
                    leading:CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data!.articles![index].urlToImage.toString()),
                    ) ,
                    title: Text(
                      snapshot.data!.articles![index].author.toString()
                    ),
                    subtitle: Text(
                        snapshot.data!.articles![index].description.toString()
                    ),
                  ),
                );
                },
              itemCount: snapshot.data!.articles!.length,
            );
          }
          else if(snapshot.hasError){
          return Center(
          child: Text('Error'),
          );
          }
          else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }

        },
      ),
    );
  }
}


