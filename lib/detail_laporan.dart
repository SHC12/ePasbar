import 'package:epasbar/animasi/FadeAnimation.dart';
import 'package:epasbar/constant.dart';
import 'package:epasbar/hasil_tindakan.dart';
import 'package:epasbar/widgets/myheader.dart';
import 'package:flutter/material.dart';

class DetailLaporan extends StatefulWidget {
  String id_lapor;
  String nama_kategori;
  String keterangan_laporan;
  String tanggal;
  String status;

  DetailLaporan(this.id_lapor, this.nama_kategori, this.keterangan_laporan,
      this.tanggal, this.status);

  @override
  _DetailLaporanState createState() => _DetailLaporanState(
      id_lapor, nama_kategori, keterangan_laporan, tanggal, status);
}

class _DetailLaporanState extends State<DetailLaporan> {
  String id_lapor;
  String nama_kategori;
  String keterangan_laporan;
  String tanggal;
  String status;

  double offset = 0;

  _DetailLaporanState(String this.id_lapor, String this.nama_kategori,
      String this.keterangan_laporan, String this.tanggal, String this.status);

  bool _isVisible = true;
  void showVerif() {
    if (status == "Belum Ditindaklanjuti") {
      setState(() {
        _isVisible = !_isVisible;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showVerif();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            MyHeader(
              image: "assets/icons/lapor.svg",
              textTop: "",
              textBottom: "",
              offset: offset,
            ),
            SizedBox(height: 20),
            FadeAnimation(
              1,
              Container(
                margin: EdgeInsets.only(right: 10, left: 10),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                        child: Text("Jenis Laporan : " + widget.nama_kategori))
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            FadeAnimation(
              1,
              Container(
                margin: EdgeInsets.only(right: 10, left: 10),
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
                  children: <Widget>[
                    Flexible(child: Text("Keterangan : ")),
                    Flexible(child: Text(widget.keterangan_laporan))
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            FadeAnimation(
              1,
              Container(
                margin: EdgeInsets.only(right: 10, left: 10),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(child: Text("Status : " + widget.status))
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            FadeAnimation(
              1,
              Container(
                margin: EdgeInsets.only(right: 10, left: 10),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(child: Text("Tanggal Laporan : " + widget.tanggal))
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Visibility(
              visible: _isVisible,
              child: FadeAnimation(
                1.6,
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HasilTindakan(widget.id_lapor),
                        ));
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.green[900]),
                    child: Center(
                      child: Text(
                        "Lihat Tanggapan",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
