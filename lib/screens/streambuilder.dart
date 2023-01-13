import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:starwars/database/StarWars.dart';
import 'package:http/http.dart' as http;


class StreamBuild extends StatefulWidget {
  const StreamBuild({Key? key}) : super(key: key);

  @override
  State<StreamBuild> createState() => _StreamBuildState();
}

class _StreamBuildState extends State<StreamBuild> {
  StreamController<List<String?>> _streamController = StreamController();
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

  Future<void> getAllUsers() async{
      Future.delayed(const Duration(seconds: 2), () async{
        _streamController.add((data));
      });
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
      appBar: AppBar(title: const Text("Star Wars"), centerTitle: true,),
      body: StreamBuilder(
        stream: _streamController.stream,
        builder: (context, AsyncSnapshot<List<String?>> snapshot) {
          if(!snapshot.hasData){
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Card(child: Text(data[index]!));
                }
            );
          }
        },
      ),
    );
  }
}
