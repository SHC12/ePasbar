import 'dart:convert';

import 'package:epasbar/admin/detail_laporan_admin.dart';
import 'package:epasbar/animasi/FadeAnimation.dart';
import 'package:epasbar/widgets/myheader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;

class PelaporanAdmin extends StatefulWidget {
  @override
  _PelaporanAdminState createState() => _PelaporanAdminState();
}

class _PelaporanAdminState extends State<PelaporanAdmin> {
  double offset = 0;
  SharedPreferences pref;
  String id_user;
  String kode_instansi;

  dataAkun() async {
    pref = await SharedPreferences.getInstance();

    setState(() {
      id_user = pref.getString('id_user') ?? '0';
      kode_instansi = pref.getString('kode_instansi') ?? '0';
    });

    print(kode_instansi);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataAkun();
  }

  Future<List<DataLaporAdmin>> futureList;
  Future<List<DataLaporAdmin>> _getData() async {
    String URL =
        "https://lapor.pasamanbaratkab.go.id/api_android/get_laporan_admin.php?kategori=";
    String URL_LENGKAP;

    URL_LENGKAP = URL + kode_instansi;

    var data = await http.get(URL_LENGKAP);

    var jsonData = json.decode(data.body);

    List<DataLaporAdmin> data_masuk = [];

    for (var u in jsonData) {
      DataLaporAdmin modelData = DataLaporAdmin(
          u['id_lapor'],
          u['id_user'],
          u['nama_kategori'],
          u['nama_sub_kategori'],
          u['keterangan_laporan'],
          u['foto_laporan'],
          u['tanggal'],
          u['status'],
          u['nama_user'],
          u['no_telp_user'],
          u['alamat_user']);

      data_masuk.add(modelData);
    }

    print(data_masuk.length);
    print(URL_LENGKAP);

    return data_masuk;
  }

  Future<List<DataLaporAdmin>> _refresh() {
    futureList = _getData();
    return futureList;
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
                                          builder: (context) =>
                                              DetailLaporanAdmin(
                                                  snapshot.data[index].id_lapor,
                                                  snapshot.data[index].id_user,
                                                  snapshot.data[index]
                                                      .nama_kategori,
                                                  snapshot.data[index]
                                                      .nama_sub_kategori,
                                                  snapshot.data[index]
                                                      .keterangan_laporan,
                                                  snapshot
                                                      .data[index].foto_laporan,
                                                  snapshot.data[index].tanggal,
                                                  snapshot.data[index].status,
                                                  snapshot
                                                      .data[index].nama_user,
                                                  snapshot
                                                      .data[index].no_telp_user,
                                                  snapshot
                                                      .data[index].alamat_user),
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

class DataLaporAdmin {
  String id_lapor;
  String id_user;
  String nama_kategori;
  String nama_sub_kategori;
  String keterangan_laporan;
  String foto_laporan;
  String tanggal;
  String status;
  String nama_user;
  String no_telp_user;
  String alamat_user;

  DataLaporAdmin(
      this.id_lapor,
      this.id_user,
      this.nama_kategori,
      this.nama_sub_kategori,
      this.keterangan_laporan,
      this.foto_laporan,
      this.tanggal,
      this.status,
      this.nama_user,
      this.no_telp_user,
      this.alamat_user);
}
