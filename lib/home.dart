import 'dart:convert';

import 'package:bubbled_navigation_bar/bubbled_navigation_bar.dart';
import 'package:epasbar/OpenPDF.dart';
import 'package:epasbar/animasi/FadeAnimation.dart';
import 'package:epasbar/constant.dart';

import 'package:epasbar/widgets/counter.dart';
import 'package:epasbar/widgets/myheader.dart';
import 'package:epasbar/widgets/myheaderhome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = ScrollController();
  double offset = 0;

  SharedPreferences pref;
  String id_user;
  String nama_lengkap;
  String no_telepon;
  String total;
  String total_pdp;
  String total_positif;
  int i_total;
  int i_total_pdp;
  int i_total_positif;

  String tanggal1;
  String tanggal2;
  String tanggal3;
  String nama_file1;
  String nama_file2;
  String nama_file3;
  String judul1;
  String judul2;
  String judul3;

  String total_bansos;
  String total_penerima;
  int i_total_penerima;
  int i_total_bansos;

  Future<List<DataDokumen>> futureDokumen;

  dataAkun() async {
    pref = await SharedPreferences.getInstance();

    setState(() {
      id_user = pref.getString('id_user');
      nama_lengkap = pref.getString('nama_lengkap');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    dataAkun();
    get_odp();
    get_pdp();
    get_positif();
    get_dokumen();
    get_bansos();

    futureDokumen = _getDataDokumen();
    super.initState();
  }

  List<DataDokumen> data_masuk = [];
  Future<List<DataDokumen>> _getDataDokumen() async {
    String URL =
        "https://lapor.pasamanbaratkab.go.id/api_android/get_dokumen.php";

    var data = await http.get(URL);

    var jsonData = json.decode(data.body);

    data_masuk = [];

    for (var u in jsonData) {
      DataDokumen modelData = DataDokumen(
          u['id_dokumen'], u['nama_dokumen'], u['nama_file'], u['tanggal']);

      data_masuk.add(modelData);
    }

    print("dokumen : ${data_masuk.length}");
    print("dokumen : ${jsonData}");

    return data_masuk;
  }

  void get_odp() async {
    var jsonResponse = null;
    var response = await http
        .get("https://corona.pasamanbaratkab.go.id/api_corona/get_odp.php");

    jsonResponse = json.decode(response.body);
    if (jsonResponse != null) {
      setState(() {
        var data = jsonResponse[0];
        total = data['total'];
        i_total = int.parse(total);
      });

      print(i_total);
    }
  }

  void get_pdp() async {
    var jsonResponse = null;
    var response = await http
        .get("https://corona.pasamanbaratkab.go.id/api_corona/get_pdp.php");

    jsonResponse = json.decode(response.body);
    if (jsonResponse != null) {
      setState(() {
        var data = jsonResponse[0];
        total_pdp = data['total'];

        i_total_pdp = int.parse(total_pdp);
      });

      print(i_total_pdp);
    }
  }

  void get_positif() async {
    var jsonResponse = null;
    var response = await http
        .get("https://corona.pasamanbaratkab.go.id/api_corona/get_positif.php");

    jsonResponse = json.decode(response.body);
    if (jsonResponse != null) {
      setState(() {
        var data = jsonResponse[0];
        total_positif = data['total'];

        i_total_positif = int.parse(total_positif);
      });
      print(i_total_positif);
    }
  }

  void get_bansos() async {
    var jsonResponse = null;
    var response = await http
        .get("https://lapor.pasamanbaratkab.go.id/api_android/get_bansos.php");

    jsonResponse = json.decode(response.body);
    if (jsonResponse != null) {
      setState(() {
        var data = jsonResponse[0];
        total_bansos = data['total_bantuan'];
        total_penerima = data['total_penerima'];

        i_total_bansos = int.parse(total_bansos);
        i_total_penerima = int.parse(total_penerima);
      });
    }
  }

  void get_dokumen() async {
    var jsonResponse = null;
    var response = await http
        .get("https://lapor.pasamanbaratkab.go.id/api_android/get_dokumen.php");

    jsonResponse = json.decode(response.body);
    if (jsonResponse != null) {
      setState(() {
        var data = jsonResponse[0];
        var data2 = jsonResponse[1];
        var data3 = jsonResponse[2];

        tanggal1 = data['tanggal'];
        judul1 = data['nama_dokumen'];
        nama_file1 = data['nama_file'];

        tanggal2 = data2['tanggal'];
        judul2 = data2['nama_dokumen'];
        nama_file2 = data2['nama_file'];

        tanggal3 = data3['tanggal'];
        judul3 = data3['nama_dokumen'];
        nama_file3 = data3['nama_file'];
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    int your_number_of_rows = 5;
    double rowHeight =
        (MediaQuery.of(context).size.height - 56) / your_number_of_rows;
    return FutureBuilder(
        future: futureDokumen,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DataDokumen> data = snapshot.data;
            List<DataRow> rows = [];
            for (var i = 0; i < data.length; i++) {
              rows.add(DataRow(cells: <DataCell>[
                DataCell(
                  Text(
                    snapshot.data[i].tanggal.toString(),
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                DataCell(
                  Text(
                    snapshot.data[i].nama_dokumen.toString(),
                  ),
                ),
                DataCell(GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OpenPDF(nama_file: nama_file1)));
                    },
                    child: Icon(
                      Icons.launch,
                      color: Colors.blue[900],
                    ))),
              ]));
            }

            return Scaffold(
              body: SingleChildScrollView(
                controller: controller,
                child: Column(
                  children: <Widget>[
                    MyHeaderHome(
                      image: "assets/icons/Drcorona.svg",
                      textTop: "Selamat Datang",
                      textBottom: nama_lengkap,
                      offset: offset,
                    ),
                    // Container(
                    //   margin: EdgeInsets.symmetric(horizontal: 20),
                    //   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    //   height: 60,
                    //   width: double.infinity,
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(25),
                    //     border: Border.all(
                    //       color: Color(0xFFE5E5E5),
                    //     ),
                    //   ),
                    //   child: Row(
                    //     children: <Widget>[
                    //       SvgPicture.asset("assets/icons/maps-and-flags.svg"),
                    //       SizedBox(width: 20),
                    //       // Expanded(
                    //       //   child: DropdownButton(
                    //       //     isExpanded: true,
                    //       //     underline: SizedBox(),
                    //       //     icon: SvgPicture.asset("assets/icons/dropdown.svg"),
                    //       //     value: "Indonesia",
                    //       //     items: [
                    //       //       'Indonesia',
                    //       //       'Bangladesh',
                    //       //       'United States',
                    //       //       'Japan'
                    //       //     ].map<DropdownMenuItem<String>>((String value) {
                    //       //       return DropdownMenuItem<String>(
                    //       //         value: value,
                    //       //         child: Text(value),
                    //       //       );
                    //       //     }).toList(),
                    //       //     onChanged: (value) {},
                    //       //   ),
                    //       // ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              FadeAnimation(
                                1,
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Kasus Covid-19\n",
                                        style: kTitleTextstyle,
                                      ),
                                      // TextSpan(
                                      //   text: "Data terakhir diupdate pada 28",
                                      //   style: TextStyle(
                                      //     color: kTextLightColor,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(),
                              // FadeAnimation(
                              //   1,
                              //   Text(
                              //     "Selengkapnya",
                              //     style: TextStyle(
                              //       color: kPrimaryColor,
                              //       fontWeight: FontWeight.w600,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          SizedBox(height: 20),
                          FadeAnimation(
                            1,
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 4),
                                    blurRadius: 30,
                                    color: kShadowColor,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  FadeAnimation(
                                    1,
                                    Counter(
                                      color: kRecovercolor,
                                      number: i_total,
                                      title: "ODP",
                                    ),
                                  ),
                                  FadeAnimation(
                                    1,
                                    Counter(
                                      color: kDeathColor,
                                      number: i_total_pdp,
                                      title: "PDP",
                                    ),
                                  ),
                                  FadeAnimation(
                                    1,
                                    Counter(
                                      color: kInfectedColor,
                                      number: i_total_positif,
                                      title: "Positif",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: <Widget>[
                              FadeAnimation(
                                1,
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Data Bansos Covid-19\n",
                                        style: kTitleTextstyle,
                                      ),
                                      TextSpan(
                                        text: "Data terakhir diupdate pada 28",
                                        style: TextStyle(
                                          color: kTextLightColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(),
                              // FadeAnimation(
                              //   1,
                              //   Text(
                              //     "Selengkapnya",
                              //     style: TextStyle(
                              //       color: kPrimaryColor,
                              //       fontWeight: FontWeight.w600,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          SizedBox(height: 20),
                          FadeAnimation(
                            1,
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 4),
                                    blurRadius: 30,
                                    color: kShadowColor,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Counter(
                                    color: kInfectedColor,
                                    number: i_total_bansos,
                                    title: "Total Bantuan (KK)",
                                  ),
                                  Counter(
                                    color: kRecovercolor,
                                    number: i_total_penerima,
                                    title: "Total Sudah Menerima (KK)",
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: <Widget>[
                              FadeAnimation(
                                1,
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Daftar Dokumen\n",
                                        style: kTitleTextstyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(),
                              // FadeAnimation(
                              //   1,
                              //   Text(
                              //     "Selengkapnya",
                              //     style: TextStyle(
                              //       color: kPrimaryColor,
                              //       fontWeight: FontWeight.w600,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          FadeAnimation(
                              1,
                              Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 4),
                                        blurRadius: 30,
                                        color: kShadowColor,
                                      ),
                                    ],
                                  ),
                                  child: DataTable(
                                    headingRowHeight: 56.0,
                                      dataRowHeight: rowHeight,
                                      columns: <DataColumn>[
                                        DataColumn(label: Text("Tanggal")),
                                        DataColumn(label: Text("Judul")),
                                        DataColumn(label: Text("Aksi")),
                                      ],
                                      rows: rows))),
                          SizedBox(height: 10),

                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: <Widget>[
                          //     Text(
                          //       "Spread of Virus",
                          //       style: kTitleTextstyle,
                          //     ),
                          //     Text(
                          //       "See details",
                          //       style: TextStyle(
                          //         color: kPrimaryColor,
                          //         fontWeight: FontWeight.w600,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // Container(
                          //   margin: EdgeInsets.only(top: 20),
                          //   padding: EdgeInsets.all(20),
                          //   height: 178,
                          //   width: double.infinity,
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(20),
                          //     color: Colors.white,
                          //     boxShadow: [
                          //       BoxShadow(
                          //         offset: Offset(0, 10),
                          //         blurRadius: 30,
                          //         color: kShadowColor,
                          //       ),
                          //     ],
                          //   ),
                          //   child: Image.asset(
                          //     "assets/images/map.png",
                          //     fit: BoxFit.contain,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}

class DataDokumen {
  String id_dokumen;
  String nama_dokumen;
  String nama_file;
  String tanggal;

  DataDokumen(this.id_dokumen, this.nama_dokumen, this.nama_file, this.tanggal);
}
