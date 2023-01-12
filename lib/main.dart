import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'StarWars.dart';

void main() {
  runApp(const MaterialApp(
      home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  List<String?> data = [];
  String domain = "https://swapi.dev/api/people/?page=1&format=json";
  bool debugMode = false;

  getData(String domain) async {
    var client = http.Client();
    var url = Uri.parse(domain);
    var response = await client.get(url, headers:  {"Content-type": "application/json", 'charset':'utf-8'});
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      body["results"].forEach((v) {
        data.add(Results.fromJson(v).name);
      });
      if (debugMode) {
        print(data.toString());
      }

      if(!body["next"].toString().contains("null")) {
        if (debugMode) {
          print(body["next"]);
        }
        getData(body["next"]);
      }

      setState(() {});
      return "Success!";
    }
  }

  @override
  void initState() {
    super.initState();
    getData(domain);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Star Wars"), backgroundColor: Colors.blue),
      body: ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Text(data[index]!),
          );
        },
      ),
    );
  }
}