import 'package:flutter/material.dart';
import 'package:news_flutter_app/services/api_services.dart';
import 'package:news_flutter_app/services/sotrage_services.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/Hits.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ApiService client = ApiService();
  StorageService storageService = StorageService();
  late DateTime selectedDate;
  late List<Hits> filteredNews;

  @override
  void initState() {
    selectedDate = DateTime.now();
    filteredNews = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search by specific date'),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: selectedDate,
            firstDay: DateTime(2000),
            lastDay: DateTime.now(),
            availableGestures: AvailableGestures.all,
            onDaySelected: _onDaySelected,
            selectedDayPredicate: (DateTime date) {
              return isSameDay(date, selectedDate);
            },
          ),
          Expanded(
            child: FutureBuilder<List<Hits>>(
              future: getAllListByDate(),
              builder: (BuildContext context, AsyncSnapshot<List<Hits>> snapshot) {
                if (snapshot.hasData) {
                   List<Hits> news = snapshot.data!;
                  return ListView.builder(
                    itemCount: news.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Hits hit = news[index];
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
                                Text('Published: ${hit.createdAt?.substring(0, 10) ?? ''}'),
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
                                  storageService.storeData(hit);
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );

                } else if (snapshot.hasError) {
                  return const Center(
                    child: Icon(Icons.error_outline),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Hits>> getAllListByDate() async {
    List<Hits> news = await client.getNews();
    filteredNews = sortedBySpecificDate(news);
    return filteredNews;
  }

  List<Hits> sortedBySpecificDate(List<Hits> news) {
    return news.where((hit) {
      DateTime newsDate = DateTime.parse(hit.createdAt!.substring(0, 10));
      return newsDate.year == selectedDate.year &&
          newsDate.month == selectedDate.month &&
          newsDate.day == selectedDate.day;
    }).toList();
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      selectedDate = day;
    });
    getAllListByDate();
  }

  Future<void> _launchUrl(String urlString) async {
    Uri uri = Uri.parse(urlString);
    if (!await launchUrl(uri)) {
      throw "can not launch url $uri";
    }
    await launchUrl(uri);
  }
}
