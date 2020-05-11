import 'dart:convert';

import 'package:epasbar/animasi/FadeAnimation.dart';
import 'package:epasbar/buat_laporan.dart';
import 'package:epasbar/detail_laporan.dart';
import 'package:epasbar/widgets/myheader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

import 'dart:ui' as ui;

import 'package:shared_preferences/shared_preferences.dart';

class Pelaporan extends StatefulWidget {
  @override
  _PelaporanState createState() => _PelaporanState();
}

class _PelaporanState extends State<Pelaporan> {
  final controller = ScrollController();
  double offset = 0;

  String id_user;
  Future getDataPengguna() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id_user = prefs.getString('id_user');
  }

  Future<List<DataLapor>> futureList;

  Future<List<DataLapor>> _getData() async {
    String URL =
        "https://lapor.pasamanbaratkab.go.id/api_android/get_laporan.php?id_user=";
    String URL_LENGKAP;

    URL_LENGKAP = URL + id_user;

    var data = await http.get(URL_LENGKAP);

    var jsonData = json.decode(data.body);

    List<DataLapor> data_masuk = [];

    for (var u in jsonData) {
      DataLapor modelData = DataLapor(u['id_lapor'], u['nama_kategori'],
          u['keterangan_laporan'], u['tanggal'], u['status']);

      data_masuk.add(modelData);
    }

    print(data_masuk.length);

    return data_masuk;
  }

  Future<List<DataLapor>> _refresh() {
    futureList = _getData();
    return futureList;
  }

  @override
  void initState() {
    // TODO: implement initState
    getDataPengguna();

    super.initState();
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  final double _borderRadius = 24;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            MyHeader(
              image: "assets/icons/lapor.svg",
              textTop: "",
              textBottom: "",
              offset: offset,
            ),
            FutureBuilder(
                future: _getData(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  print(snapshot.data);
                  if (snapshot.data == null) {
                    return Center(
                      child: FadeAnimation(
                        1.6,
                        FlatButton(
                          onPressed: () {
                            setState(() {
                              _getData();
                            });
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.blue[900]),
                            child: Center(
                              child: Text(
                                "Cek Laporan",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                    // return Container(child: Center(child: Text("Loading...")));
                    // return Center(
                    //   child: SpinKitDoubleBounce(
                    //     color: Colors.blueGrey,
                    //     size: 50.0,
                    //   ),
                    // );
                  } else if (snapshot.hasData) {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (snapshot.data.length >= 0) {
                              print(snapshot.data);
                              return Container(
                                child: GestureDetector(
                                  onTap: () {
                                    
                                    Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailLaporan(

                                  snapshot.data[index].id_lapor,
                                  snapshot.data[index].nama_kategori,
                                  snapshot.data[index].keterangan_laporan,
                                  snapshot.data[index].tanggal,
                                  snapshot.data[index].status

                                   ),
                              ));
                                  },
                                  child: new Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                8,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      _borderRadius),
                                              gradient: LinearGradient(
                                                  colors: [
                                                    Color(0xff6DC8F3),
                                                    Color(0xff73A1F9)
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight),
                                            ),
                                          ),
                                          Positioned(
                                            right: 0,
                                            bottom: 0,
                                            top: 0,
                                            child: CustomPaint(
                                              size: Size(100, 150),
                                              painter: CustomCardShapePainter(
                                                  _borderRadius,
                                                  Color(0xff6DC8F3),
                                                  Color(0xff73A1F9)),
                                            ),
                                          ),
                                          Positioned.fill(
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: snapshot.data[index]
                                                              .status ==
                                                          'Belum Ditindaklanjuti'
                                                      ? Icon(Icons.access_time,
                                                          color: Colors.white)
                                                      : Icon(Icons.check_circle,
                                                          color: Colors.white),
                                                  flex: 2,
                                                ),
                                                Expanded(
                                                  flex: 4,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Flexible(
                                                        child: Text(
                                                          snapshot.data[index]
                                                              .nama_kategori,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          snapshot.data[index]
                                                              .keterangan_laporan,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 16),
                                                      Row(
                                                        children: <Widget>[
                                                          Icon(
                                                            Icons.date_range,
                                                            color: Colors.white,
                                                            size: 16,
                                                          ),
                                                          SizedBox(
                                                            width: 8,
                                                          ),
                                                          Flexible(
                                                            child: Text(
                                                              snapshot
                                                                  .data[index]
                                                                  .tanggal,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    height: 64,
                                                    width: 64,
                                                  ),
                                                  flex: 2,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          }),
                    );
                  }
                }),
          ],
        ),
      ),
      floatingActionButton: FadeAnimation(
        1,
        new FloatingActionButton(
            child: new Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BuatLaporan(),
                  ));
            }),
      ),
    );
  }
}

class CustomCardShapePainter extends CustomPainter {
  final double radius;
  final Color startColor;
  final Color endColor;

  CustomCardShapePainter(this.radius, this.startColor, this.endColor);

  @override
  void paint(Canvas canvas, Size size) {
    var radius = 24.0;

    var paint = Paint();
    paint.shader = ui.Gradient.linear(
        Offset(0, 0), Offset(size.width, size.height), [
      HSLColor.fromColor(startColor).withLightness(0.8).toColor(),
      endColor
    ]);

    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius, 0)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class DataLapor {
  String id_lapor;
  String nama_kategori;
  String keterangan_laporan;
  String tanggal;
  String status;

  DataLapor(this.id_lapor, this.nama_kategori, this.keterangan_laporan,
      this.tanggal, this.status);
}
