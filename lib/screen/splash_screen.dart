import 'package:flutter/material.dart';
import 'package:quran_app/screen/home_page_screen.dart';

import '../helper/read_from_json.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Future _future = Future.delayed(
    const Duration(seconds: 4),
  );

  late final Future<List> data;

  Future readJson() async {
    dynamic jsonData = await JsonReader().readJson();
    data = await jsonData;
    return data;
  }

  @override
  void initState() {
    readJson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MyHomePage();
        } else {
          return Scaffold(
              backgroundColor: const Color(0xffE0C9A6),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 300,
                      child: Image.asset(
                        'assets/images/quran.png',
                      ),
                    ),
                    const Text(
                      'القرآن الكريم ',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff6f4c26)),
                    )
                  ],
                ),
              ));
        }
      },
    );
  }
}
