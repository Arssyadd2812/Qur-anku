import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:belajar_flutter1/models/msiswa.dart';
import 'package:belajar_flutter1/models/api.dart';
import 'package:belajar_flutter1/views/create.dart';
import 'package:http/http.dart' as http;
import 'package:belajar_flutter1/views/detail.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  late Future<List<SiswaModel>> sw;
  final swListkey = GlobalKey<HomeState>();

  @override
  void initState() {
    super.initState();
    sw = getSwList();
  }

  Future<List<SiswaModel>> getSwList() async {
    final response = await http.get(Uri.parse(BaseUrl.data));
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    List<SiswaModel> sw = items.map<SiswaModel>((json) {
      return SiswaModel.fromJson(json);
    }).toList();
    return sw;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Data Siswa"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ), // AppBar
      body: Center(
        child: FutureBuilder<List<SiswaModel>>(
          future: sw,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                var data = snapshot.data[index];
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.person),
                    trailing: Icon(Icons.view_list),
                    title: Text(
                      data.nis + " " + data.nama,
                      style: TextStyle(fontSize: 20),
                    ), // Text
                    subtitle: Text(data.tplahir + "," + data.tglahir),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Details(sw: data),
                        ),
                      );
                    },
                  ), // ListTile
                ); // Card
              },
            ); // ListView.builder
          },
        ), // FutureBuilder
      ), // Center
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        hoverColor: Colors.green,
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => Create()));
        },
      ), // FloatingActionButton
    ); // Scaffold
  }
}
