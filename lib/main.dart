import 'package:flutter/material.dart';
import 'package:starwars/screens/asyncawait.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.blueGrey,
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color.fromRGBO(255, 232, 31, 1),
          )
      )
    ),
    home: const Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.asset("assets/img/Star_Wars_Logo.png", height: MediaQuery.of(context).size.height / 2, width: MediaQuery.of(context).size.width / 2),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) { return AsyncAwait(); })), child: const Text("Async / Await method")),
                TextButton(onPressed: () {}, child: const Text("Stream")),
                TextButton(onPressed: () {}, child: const Text("FutureBuilder")),
                TextButton(onPressed: () {}, child: const Text("StreamBuilder")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
