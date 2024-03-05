import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:news_flutter_app/models/Hits.dart';
import 'package:news_flutter_app/util/custom_range_dialog_box.dart';
import 'package:news_flutter_app/pages/sorted_page.dart';
import 'package:news_flutter_app/util/custom_search_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_services.dart';
import '../services/sotrage_services.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiService client = ApiService();
  StorageService storageService = StorageService();
  final _toController = TextEditingController();
  final _fromController = TextEditingController();
  final serachController = TextEditingController();
  bool isSortedByPoints = false;
  bool isSortedByDate = false;
  late List<Hits> newsList;
  late List<Hits> mainNewsList;

  @override
  void initState() {
    super.initState();
    newsList = [];
    mainNewsList = [];
    fetchNews();
  }


  Future<void> _launchUrl(String urlString) async {
    Uri uri = Uri.parse(urlString);
    if (!await launchUrl(uri)) {
      throw "can not launch url $uri";
    }
    await launchUrl(uri);
  }

Future<List<Hits>> fetchNews() async {
    final fetchedNews = await client.getNews();
    setState(() {
      newsList = fetchedNews;
    });
    newsList=fetchedNews;
    return fetchedNews;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Flutter"),
            Text(
              " News",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Text(
              " TSG",
              style: TextStyle(fontSize: 22, color: Colors.orange),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              _handleSortOption(value);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'sortByPoints',
                child: ListTile(
                  leading: Icon(Icons.text_rotation_angleup),
                  title: Text('Sort by Points'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'sortByDate',
                child: ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text('Sort by Date'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'filterByPoints',
                child: ListTile(
                  leading: Icon(Icons.sort),
                  title: Text('filter by points'),
                ),
              ),
              const PopupMenuItem(
                value: 'filterByDate',
                child: ListTile(
                  leading: Icon(Icons.filter_4),
                  title: Text("filter by date"),
                ),
              ),
            ],
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            child: TextField(
              cursorColor: Colors.orange,
              controller: serachController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "key word",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.orange),
                ),
              ),
              onChanged: searchArticle,
            ),
          ),
          Expanded(
              child: FutureBuilder(
            future: fetchNews(),
            builder: (BuildContext context, AsyncSnapshot<List<Hits>> snapshot) {
              if(snapshot.hasData){
                return ListView.builder(

                  itemCount: mainNewsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Hits hit = mainNewsList[index];

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
                              Text(
                                  'Published: ${hit.createdAt?.substring(0, 10) ?? ''}'),
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

              }else {
                return Center(child: CircularProgressIndicator(),);
                  }
                },
          )),
        ],
      ),
    );
  }

  void _handleSortOption(String value) {
    switch (value) {
      case 'filterByPoints':
        {
          filterByPoints();
        }

        break;
      case 'sortByPoints':
        {
          sortByPoints();
        }
        break;
      case 'sortByDate':
        {
          sortByDate();
        }
        break;
      case 'filterByDate':
        {
          filterByDate();
        }
        break;
      case 'searchByKeyWord':
      default:
        break;
    }
  }

  void onFilterPresd(int from, int to) {
    List<Hits> sortedNewsList = [];

    if (isSortedByPoints == false) {
      newsList.sort((a, b) => (a.points ?? 0).compareTo(b.points ?? 0));
      isSortedByPoints = true;
      isSortedByDate = false;
    }

    int from = int.parse(_fromController.text);
    int to = int.parse(_toController.text);
    for (int i = 0; i < newsList.length; i++) {
      if (newsList[i].points! >= from && newsList[i].points! <= to) {
        sortedNewsList.add(newsList[i]);
      }
      if (newsList[i].points! > to) {
        break;
      }
    }

    Navigator.of(context).pop();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SortedPage(
          hits: sortedNewsList,
        ),
      ),
    );

    _toController.clear();
    _fromController.clear();
  }

  sortByPoints() {
    if (isSortedByPoints == false) {
      newsList.sort((a, b) => (a.points ?? 0).compareTo(b.points ?? 0));
      isSortedByPoints = true;
      isSortedByDate = false;
    }

    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => SortedPage(hits: newsList)));
  }

  void filterByPoints() {
    if (isSortedByPoints == false) {
      newsList.sort((a, b) => (a.points ?? 0).compareTo(b.points ?? 0));
      isSortedByPoints = true;
      isSortedByDate = false;
    }
    showDialog(
      context: context,
      builder: (context) {
        return RangeDialogBox(
          fromController: _fromController,
          toController: _toController,
          onCancel: () => Navigator.of(context).pop(),
          onSort: () => onFilterPresd(
              int.parse(_fromController.text), int.parse(_toController.text)),
        );
      },
    );
  }

  void sortByDate() {
    if (isSortedByDate == false) {
      newsList.sort((a, b) => (a.createdAt)!.compareTo(b.createdAt!));
      isSortedByPoints = false;
    }
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => SortedPage(hits: newsList)));
  }

  void filterByDate() async {
    List<Hits> filtredByDate = [];
    if (isSortedByDate == false) {
      newsList.sort((a, b) => (a.createdAt)!.compareTo(b.createdAt!));
      isSortedByPoints = false;
      isSortedByDate = true;
    }
    DateTimeRange? selectedDate = await showDateRangePicker(
      context: context,
      firstDate: DateTime(1000),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      for (int i = 0; i < newsList.length; i++) {
        DateTime newsDate = DateTime.parse(newsList[i].createdAt!);

        print(newsDate);
        if ((newsDate.isAfter(selectedDate.start) &&
                newsDate.isBefore(selectedDate.end)) ||
            (newsDate.year == selectedDate.start.year &&
                newsDate.month == selectedDate.start.month &&
                newsDate.day == selectedDate.start.day)) {
          filtredByDate.add(newsList[i]);
        }
      }
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SortedPage(hits: filtredByDate),
        ),
      );
    }
  }

  void searchArticle(String query) async {
    final suggestions = mainNewsList.where((article) {
      final articleTitle = article.title!.toLowerCase();
      final input = query.toLowerCase();
      return articleTitle.contains(input);
    }).toList();

    setState(() {
      mainNewsList = suggestions;

    });
  }
}
