import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:starwars/database/StarWars.dart';

class FutureBuild extends StatefulWidget {
  const FutureBuild({Key? key}) : super(key: key);

  @override
  State<FutureBuild> createState() => _FutureBuildState();
}

class _FutureBuildState extends State<FutureBuild> {
  late Future<List<String?>> _value;
  List<String?> data = [];
  String domain = "https://swapi.dev/api/people/?page=1&format=json";
  bool debugMode = false;

  getData(String domain) async {
    var client = http.Client();
    var url = Uri.parse(domain);
    var response = await client.get(url,
        headers: {"Content-type": "application/json", 'charset': 'utf-8'});
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      body["results"].forEach((v) {
        data.add(Results.fromJson(v).name);
      });
      if (debugMode) {
        print(data.toString());
      }

      if (!body["next"].toString().contains("null")) {
        if (debugMode) {
          print(body["next"]);
        }
        getData(body["next"]);
      }

      setState(() {});
      return "Success!";
    }
  }

  Future<void> getAllUsers() async {
      _value = Future(() => data);
  }

  @override
  void initState() {
    super.initState();
    getData(domain);
    getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Star Wars"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _value,
        builder: (BuildContext context, AsyncSnapshot<List<String?>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Text(data[index]!),
                );
              },
            );
          }
        },
      ),
    );
  }
}
