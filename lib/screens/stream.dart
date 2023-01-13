import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:starwars/database/StarWars.dart';
import 'package:http/http.dart' as http;

class StreamScreen extends StatefulWidget {
  const StreamScreen({Key? key}) : super(key: key);

  @override
  State<StreamScreen> createState() => _StreamScreenState();
}

class _StreamScreenState extends State<StreamScreen> {
  StreamController<String?> controller = StreamController<String?>();
  late Stream stream = controller.stream;
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
        controller.add(Results.fromJson(v).name.toString());
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

  void addDataToTheList() {
    controller.stream.listen((event) {
      data.add(event);
    });
  }

  @override
  void initState() {
    super.initState();
    getData(domain);
    addDataToTheList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Star Wars"), centerTitle: true,),
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
