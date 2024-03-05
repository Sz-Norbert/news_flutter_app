import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Hits.dart';

class StorageService {

  Future<void> storeData(Hits hits) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = hits.objectID!;
    String newsData = jsonEncode(hits.toJson());
    await prefs.setString(key, newsData);
  }

  Future<List<Hits>> getAllSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> keys = prefs.getKeys().toList();
    List<Hits> savedArticles = [];
    for (String key in keys) {
      Map<String, dynamic> details = jsonDecode(prefs.getString(key)!);
      Hits hit = Hits.fromJson(details);
      savedArticles.add(hit);
    }
    return savedArticles;
  }


  Future<void> removeData(String objectId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = objectId;
    await prefs.remove(key);
  }
}
