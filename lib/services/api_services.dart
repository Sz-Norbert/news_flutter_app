import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:news_flutter_app/models/Hits.dart';
import 'package:news_flutter_app/models/news_response.dart';

class ApiService{

  final endPoint=
      "https://hn.algolia.com/api/v1/search?tags=front_page";

  Future<List<Hits>> getNews() async{
    Response response= await get(Uri.parse(endPoint));

    if(response.statusCode==200){
      Map<String,dynamic> json = jsonDecode(response.body);
      List<dynamic> body= json['hits'];
      List<Hits> news= body.map((dynamic item) => Hits.fromJson(item) ).toList();
      return news;
    }else {
      throw ("cant get ");
    }
  }



}