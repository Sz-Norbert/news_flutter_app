import 'Hits.dart';

class NewsResponse {
  List<Hits>? hits;

  NewsResponse(this.hits);

   NewsResponse.fromJson(Map<String,dynamic> json){
    if(json['hits']!=null){
      hits=<Hits>[];
      json['hits'].forEach((v)

      {
        hits!.add(new Hits.fromJson(v));
      });
    }
  }
}