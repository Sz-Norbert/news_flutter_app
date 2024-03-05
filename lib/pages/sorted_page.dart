import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/Hits.dart';

class SortedPage extends StatefulWidget {
  List<Hits> hits;

  SortedPage({super.key, required this.hits});

  @override
  State<SortedPage> createState() => _SortedPageState();
}

class _SortedPageState extends State<SortedPage> {
  @override
  void initState() {
    super.initState();
    print(widget.hits.length);
  }
  Future<void> _launchUrl(String urlString) async {
    Uri uri = Uri.parse(urlString);
    if (!await launchUrl(uri)) {
      throw "can not launch url $uri";
    }
    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("sorted by"),
      ),
      body: ListView.builder(
        itemCount: widget.hits.length,

        itemBuilder: (BuildContext context, int index) {
          Hits hit = widget.hits[index];
          return GestureDetector(
            onTap: () async {
              if (hit.url != null) {
                await _launchUrl(hit.url!);
              }
            },
            child: Container(
              margin: const EdgeInsets.all(12.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 3.0),
                ],
              ),
              child: ListTile(
                title: Text(hit.title ?? ''),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Author: ${hit.author ?? ''}'),
                    Text('Published: ${hit.createdAt!.substring(0,10) ?? ''}'),
                    Text('Comments: ${hit.numComments ?? ''}'),
                    Text('Points: ${hit.points ?? ''}'),
                  ],
                ),
                leading: IconButton(
                  icon: hit.isFavorite
                      ? const Icon(Icons.favorite)
                      : const Icon(Icons.favorite_border),
                  onPressed: () {
                    setState(() {
                      hit.isFavorite = !hit.isFavorite;
                    });
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
