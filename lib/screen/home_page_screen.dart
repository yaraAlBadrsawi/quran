import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran_app/model/quran_data.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<int, List<QuranData>> pages = {};
  List<QuranData> quranData = [];
  List<String> suraList = [];
  bool showAppBar = false;
  List<dynamic> data = [];
  bool isFirstAya = false;
  final PageController _pageViewController = PageController();

  int pageNumber = 0;

  List<String> ayaList = []; //{'page':'aya'}

  int? pageVal;
  bool selectNewAyah = false;
  int selectedAyah = -1;

  Future<void> getData() async {
    String jsonString =
        await rootBundle.loadString('assets/json/hafs_smart.json');
    data = await jsonDecode(jsonString) as List;
    // print('jsonResponse : $data');
    // print('jsonResponse - length : ${data.length}');

    if (data.isNotEmpty) {
      for (var item in data) {
        QuranData qd = QuranData.fromMap(item);
        quranData.add(qd);
        ayaList.add(qd.aya_text_emlaey);
        if (!suraList.contains(qd.sura_name_ar)) {
          suraList.add(qd.sura_name_ar);
        }
        int page = qd.page;
        if (!pages.containsKey(page)) {
          pages[page] = [];
        }
        pages[page]!.add(qd);
      }
    } else {
      print('no data ');
    }

    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    dynamic args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      int argPage = 0;
      argPage = args[0];
      print('page was passed is : $argPage');
      selectedAyah = args[1];
      pageNumber = argPage;
      print(
          '_pageViewController.hasClients ::: ${_pageViewController.hasClients}');
      if (_pageViewController.hasClients) {
        _pageViewController.jumpToPage(argPage);
      }
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xffE0C9A6),
        appBar: showAppBar
            ? AppBar(
                actions: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      'ابحث في القرآن',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: AyaSearch(data: data),
                        );
                      },
                      icon: const Icon(Icons.search)),
                ],
                leading: IconButton(
                  icon: const Icon(Icons.list),
                  onPressed: () {
                    scaffoldKey.currentState!.openDrawer();
                  },
                ),
                automaticallyImplyLeading: false,
                elevation: 0,
                backgroundColor: const Color(0xff785d3e),
              )
            : null,
        drawer: Drawer(
          backgroundColor: const Color(0xffE0C9A6),
          child: ListView.builder(
            itemCount: suraList.length,
            itemBuilder: (_, index) {
              return ListTile(
                title: Text(
                  suraList[index],
                  style: const TextStyle(fontSize: 20, fontFamily: 'HafsSmart'),
                ),
                splashColor: const Color(0xff6f4c26),
                onTap: () {
                  int pageNumber = pages.keys.toList()[index];
                  Navigator.pop(context);

                  int initialPage = 0;

                  initialPage = data.firstWhere((element) =>
                      element['sura_name_ar'] == suraList[index])['page'];

                  _pageViewController.jumpToPage(initialPage - 1);

                  /// pages => {
                  /// 1: [QuranData(aya_text,aya_no,page_number,sura_name)]
                  /// 2: [QuranData(aya_text,aya_no,page_number,sura_name)]
                  /// 3: [QuranData(aya_text,aya_no,page_number,sura_name)]
                  /// 4: [QuranData(aya_text,aya_no,page_number,sura_name)]
                  /// 5: [QuranData(aya_text,aya_no,page_number,sura_name)]
                  /// 6: [QuranData(aya_text,aya_no,page_number,sura_name)]
                  /// 7: [QuranData(aya_text,aya_no,page_number,sura_name)]
                  /// ...
                  /// ...
                  /// }
                  // pages.forEach((key, value) {
                  //   print('value : ${value}');
                  // });
                },
              );
            },
          ),
        ),
        body: quranData.isEmpty
            ? const Center(
                child: CircularProgressIndicator(
                color: Color(0xff785d3e),
              ))
            : SafeArea(
                child: PageView.builder(
                    controller: _pageViewController,
                    clipBehavior: Clip.antiAlias,
                    scrollDirection: Axis.horizontal,
                    itemCount: data.length,
                    itemBuilder: (_, index) {
                      int pageNumber = pages.keys.toList()[index];

                      const Divider(
                        thickness: 1,
                        color: Colors.brown,
                      );

                      for (var aya in pages[pageNumber]!) {
                        return TextButton(
                          onPressed: () {
                            setState(() {
                              showAppBar = !showAppBar;
                            });
                          },
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              foregroundColor: const Color(0xff785d3e)),
                          child: Container(
                            decoration: index % 2 == 0
                                ? const BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                        Color(0x27000000),
                                        Colors.transparent,
                                        Colors.transparent,
                                        Colors.transparent,
                                        Colors.transparent
                                      ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight))
                                : const BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                        Color(0x27000000),
                                        Colors.transparent,
                                        Colors.transparent,
                                        Colors.transparent,
                                        Colors.transparent
                                      ],
                                        begin: Alignment.centerRight,
                                        end: Alignment.centerLeft)),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ListView(children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      ' الجزء  ${aya.jozz}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'HafsSmart'),
                                    ),
                                    Text(
                                      aya.sura_name_ar,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'HafsSmart'),
                                    ),
                                  ],
                                ),
                                aya.aya_no == 1
                                    ? Container(
                                        width: double.infinity,
                                        height: 50,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.zero,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: const Color(0xff785d3e)),
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Text(
                                          aya.sura_name_ar,
                                          style: const TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'HafsSmart'),
                                        ))
                                    : const Text(''),
                                const Divider(
                                  color: Colors.brown,
                                  thickness: 1,
                                ),
                                RichText(
                                  overflow: TextOverflow.visible,
                                  textAlign: pageNumber == 1 || pageNumber == 2
                                      ? TextAlign.center
                                      : TextAlign.justify,
                                  textDirection: TextDirection.rtl,
                                  text: TextSpan(
                                      text: '',
                                      style: const TextStyle(
                                        fontFamily: 'HafsSmart',
                                        color: Colors.black,
                                        fontSize: 24,
                                        // height: 2,
                                        textBaseline: TextBaseline.alphabetic,
                                      ),
                                      children: [
                                        for (var aya in pages[pageNumber]!) ...{
                                          TextSpan(
                                            text: '${aya.aya_text} ',
                                            style: const TextStyle(
                                              fontFamily: 'HafsSmart',
                                              color: Colors.black,
                                              fontSize: 25,
                                              height: 1.5,
                                            ),
                                            recognizer:
                                                LongPressGestureRecognizer()
                                                  ..onLongPress = () {
                                                    print('navigate');
                                                  },
                                          ),
                                        }
                                      ]),
                                ),
                                Text(
                                  '$pageNumber',
                                  style: const TextStyle(
                                      fontSize: 18, fontFamily: 'HafsSmart'),
                                ),
                              ]),
                            ),
                          ),
                        );
                      }
                    })),
      ),
    );
  }
}

class AyaSearch extends SearchDelegate {
  List<String> ayaList = [];
  List<dynamic> data = [];
  Map<int, List<QuranData>> pages = {};

  AyaSearch({required this.data});

  @override
  ThemeData appBarTheme(context) {
    return Theme.of(context).copyWith(
        scaffoldBackgroundColor: const Color(0xffE0C9A6),
        appBarTheme: const AppBarTheme(
          color: Color(0xff785d3e),
        ),
        focusColor: const Color(0xffE0C9A6),
        inputDecorationTheme:
            const InputDecorationTheme(border: InputBorder.none));
  }

  @override
  List<Widget>? buildActions(context) {
    return [
      IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            query = "";
            print('aya list : ${ayaList.length}');
          }),
    ];
  }

  @override
  Widget? buildLeading(context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(context) {
    List filteredData = [];

    if (query.isNotEmpty) {
      filteredData = data
          .where((element) =>
              element['aya_text_emlaey'].toString().contains(query.trim()))
          .toList();
      return ListView.separated(
        itemBuilder: (_, index) {
          return ListTile(
            onTap: () {
              print('filtered data page ::: ${filteredData[index]['page']}');

              Navigator.pushReplacementNamed(context, '/home', arguments: [
                filteredData[index]['page'],
                filteredData[index]['id']
              ]);
            },
            title: Text(
              filteredData[index]['aya_text'],
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontFamily: 'HafsSmart', fontSize: 19),
              textAlign: TextAlign.right,
            ),
            subtitle: Text(
              filteredData[index]['sura_name_ar'],
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),
            leading: Text(
              '  الصفحة ${filteredData[index]['page'].toString()}',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
        itemCount: filteredData.length,
      );
    } else {
      return const Text('');
    }
  }

  /// pages => {
  /// 1: [QuranData(aya_text,aya_no,page_number,sura_name)]
  /// 2: [QuranData(aya_text,aya_no,page_number,sura_name)]
  /// 3: [QuranData(aya_text,aya_no,page_number,sura_name)]
  /// 4: [QuranData(aya_text,aya_no,page_number,sura_name)]
  /// 5: [QuranData(aya_text,aya_no,page_number,sura_name)]
  /// 6: [QuranData(aya_text,aya_no,page_number,sura_name)]
  /// 7: [QuranData(aya_text,aya_no,page_number,sura_name)]
  /// ...
  /// ...
  /// }
  @override
  Widget buildSuggestions(context) {
    List filteredData = [];

    if (query.isNotEmpty) {
      filteredData = data
          .where((element) =>
              element['aya_text_emlaey'].toString().contains(query.trim()))
          .toList();
      return ListView.separated(
        itemBuilder: (_, index) {
          return ListTile(
            onTap: () {
              print('filtered data page ::: ${filteredData[index]['page']}');

              Navigator.pushReplacementNamed(context, '/home', arguments: [
                filteredData[index]['page'],
                filteredData[index]['id']
              ]);
            },
            title: Text(
              filteredData[index]['aya_text'],
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontFamily: 'HafsSmart', fontSize: 19),
              textAlign: TextAlign.right,
            ),
            subtitle: Text(
              filteredData[index]['sura_name_ar'],
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),
            leading: Text(
              '  الصفحة ${filteredData[index]['page'].toString()}',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
        itemCount: filteredData.length,
      );
    } else {
      return const Text('');
    }
  }
}
