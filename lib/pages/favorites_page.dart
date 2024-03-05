import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:news_flutter_app/models/Hits.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/sotrage_services.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  StorageService storageService = StorageService();

  Future<void> _launchUrl(String urlSting) async {
    Uri uri = Uri.parse(urlSting);
    if (!await launchUrl(uri)) {
      throw "can not launch url $uri";
    }
    await launchUrl(uri);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("favorites"),

      ),
      body: FutureBuilder(
          future: storageService.getAllSavedData(),
          builder: (BuildContext context, AsyncSnapshot<List<Hits>> snapshot) {
            if (snapshot.hasData) {
              List<Hits> news = snapshot.data!;
              return ListView.builder(
                  itemCount: news.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Hits hit = news[index];
                    return GestureDetector(
                      onTap: () {
                        _launchUrl(hit.url!);
                      },
                      child: Container(
                        margin:  EdgeInsets.all(12.0),
                        padding:  EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 3.0),
                          ],
                        ),
                        child: Slidable(
                          endActionPane: ActionPane(
                            motion: StretchMotion(),
                            children: [
                              SlidableAction(
                                icon: Icons.delete,
                                backgroundColor: Colors.red,
                            onPressed: (context) => deleteFunction(context,hit.objectID!)
                              )
                            ],
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            title: Text(hit.title ?? ''),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Author: ${hit.author ?? ''}'),
                                Text('Published: ${hit.createdAt ?? ''}'),
                                Text('Comments: ${hit.numComments ?? ''}'),
                                Text('Points: ${hit.points ?? ''}'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );


  }
  void deleteFunction(BuildContext context, String objectId) {
    setState(() {
      storageService.removeData(objectId);
    });
  }

}
