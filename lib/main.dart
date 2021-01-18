import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('CekAja')),
        body: MainListView(),
      ),
    );
  }
}

class Assetmobil {
  //int mobilid;
  //String mobilnoPolisi;
  //int mobilnoRangka;
  //String mobilnoMesin;
  int mobilid;
  String mobilnoPolisi;
  String mobilnoRangka;
  String mobilnoMesin;
  String mobilketerangan;
  String mobilstatus;
  String mobilrefNumberQrCode;

  Assetmobil(
      {this.mobilid,
      this.mobilnoPolisi,
      this.mobilnoRangka,
      this.mobilnoMesin,
      this.mobilketerangan,
      this.mobilstatus,
      this.mobilrefNumberQrCode});

  factory Assetmobil.fromJson(Map<String, dynamic> json) {
    return Assetmobil(
        mobilid: json['id'],
        mobilnoPolisi: json['noPolisi'],
        mobilnoRangka: json['noRangka'],
        mobilnoMesin: json['noMesin'],
        mobilketerangan: json['keterangan'],
        mobilstatus: json['status'],
        mobilrefNumberQrCode: json['refNumberQrCode']);
  }
}

class MainListView extends StatefulWidget {
  MainListViewState createState() => MainListViewState();
}

class MainListViewState extends State {
  final String apiURL = 'https://api.par-mobile.com/readAssetMobilJson.php';

  Future<List<Assetmobil>> fetchAssets() async {
    var response = await http.get(apiURL);

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      List<Assetmobil> assetList = items.map<Assetmobil>((json) {
        return Assetmobil.fromJson(json);
      }).toList();

      return assetList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  navigateToNextActivity(BuildContext context, int dataHolder) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SecondScreenState(dataHolder.toString())));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Assetmobil>>(
      future: fetchAssets(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return ListView(
          children: snapshot.data
              .map((data) => Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          navigateToNextActivity(context, data.mobilid);
                        },
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
                                  child: Text(data.mobilnoPolisi,
                                      style: TextStyle(fontSize: 21),
                                      textAlign: TextAlign.left))
                            ]),
                      ),
                      Divider(color: Colors.black),
                    ],
                  ))
              .toList(),
        );
      },
    );
  }
}

class SecondScreenState extends StatefulWidget {
  final String idHolder;
  SecondScreenState(this.idHolder);
  @override
  State<StatefulWidget> createState() {
    return SecondScreen(this.idHolder);
  }
}

class SecondScreen extends State<SecondScreenState> {
  final String idHolder;

  SecondScreen(this.idHolder);

  // API URL
  var url = 'https://api.par-mobile.com/getAssetMobilJson.php';

  Future<List<Assetmobil>> fetchAssets() async {
    var data = {'id': int.parse(idHolder)};

    var response = await http.post(url, body: json.encode(data));

    if (response.statusCode == 200) {
      print(response.statusCode);

      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      List<Assetmobil> assetList = items.map<Assetmobil>((json) {
        return Assetmobil.fromJson(json);
      }).toList();

      return assetList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
                title: Text('Showing Selected Item Details'),
                automaticallyImplyLeading: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context, false),
                )),
            body: FutureBuilder<List<Assetmobil>>(
              future: fetchAssets(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());

                return ListView(
                  children: snapshot.data
                      .map((data) => Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  print(data.mobilnoPolisi);
                                },
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 20, 0, 10),
                                          child: Text(
                                              'ID = ' + data.mobilid.toString(),
                                              style: TextStyle(fontSize: 21))),
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 10),
                                          child: Text(
                                              'No. Polisis = ' +
                                                  data.mobilnoPolisi,
                                              style: TextStyle(fontSize: 21))),
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 10),
                                          child: Text(
                                              'No. Rangka = ' +
                                                  data.mobilnoRangka,
                                              style: TextStyle(fontSize: 21))),
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 10),
                                          child: Text(
                                              'No. Mesin = ' +
                                                  data.mobilnoMesin,
                                              style: TextStyle(fontSize: 21))),
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 10),
                                          child: Text(
                                              'Keterangan = ' +
                                                  data.mobilketerangan,
                                              style: TextStyle(fontSize: 21))),
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 10),
                                          child: Text(
                                              'Status = ' + data.mobilstatus,
                                              style: TextStyle(fontSize: 21))),
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 10),
                                          child: Text(
                                              'QR Ref = ' +
                                                  data.mobilrefNumberQrCode,
                                              style: TextStyle(fontSize: 21))),
                                    ]),
                              )
                            ],
                          ))
                      .toList(),
                );
              },
            )));
  }
}
