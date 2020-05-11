import 'package:epasbar/admin/tindaklanjuti.dart';
import 'package:epasbar/animasi/FadeAnimation.dart';
import 'package:epasbar/constant.dart';
import 'package:epasbar/widgets/counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DetailLaporanAdmin extends StatefulWidget {
  String id_lapor;
  String id_user;
  String nama_kategori;
  String keterangan_laporan;
  String foto_laporan;
  String tanggal;
  String status;
  String nama_user;
  String no_telp_user;
  String alamat_user;

  DetailLaporanAdmin(
      this.id_lapor,
      this.id_user,
      this.nama_kategori,
      this.keterangan_laporan,
      this.foto_laporan,
      this.tanggal,
      this.status,
      this.nama_user,
      this.no_telp_user,
      this.alamat_user);
  @override
  _DetailLaporanAdminState createState() => _DetailLaporanAdminState(
      id_lapor,
      id_user,
      nama_kategori,
      keterangan_laporan,
      foto_laporan,
      tanggal,
      status,
      nama_user,
      no_telp_user,
      alamat_user);
}

class _DetailLaporanAdminState extends State<DetailLaporanAdmin> {
  String id_lapor;
  String id_user;
  String nama_kategori;
  String keterangan_laporan;
  String foto_laporan;
  String tanggal;
  String status;
  String nama_user;
  String no_telp_user;
  String alamat_user;

  _DetailLaporanAdminState(
      this.id_lapor,
      this.id_user,
      this.nama_kategori,
      this.keterangan_laporan,
      this.foto_laporan,
      this.tanggal,
      this.status,
      this.nama_user,
      this.no_telp_user,
      this.alamat_user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Laporan"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
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
                                text: "Data pelapor",
                                style: kTitleTextstyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(
                                "Nama : " + widget.nama_user,
                              ),
                              SizedBox(height: 10),
                              Text("No Telp : " + widget.no_telp_user),
                              SizedBox(height: 10),
                              Text("Alamat : " + widget.alamat_user),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                              child: Text(
                                  "Jenis Laporan : " + widget.nama_kategori))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
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
                        children: <Widget>[
                          Flexible(child: Text("Keterangan : ")),
                          Flexible(child: Text(widget.keterangan_laporan))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(child: Text("Status : " + widget.status))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                              child:
                                  Text("Tanggal Laporan : " + widget.tanggal))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Stack(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          await showDialog(
                              context: context,
                              builder: (_) => ImageDialog(widget.foto_laporan));
                        },
                        child: CircleAvatar(
                          backgroundImage: widget.foto_laporan == ""
                              ? NetworkImage(
                                  'https://git.unilim.fr/assets/no_group_avatar-4a9d347a20d783caee8aaed4a37a65930cb8db965f61f3b72a2e954a0eaeb8ba.png')
                              : NetworkImage(
                                  "https://lapor.pasamanbaratkab.go.id/image/" +
                                      widget.foto_laporan),
                          radius: 50.0,
                        ),
                      ),
                    ],
                  ),
                  Text('Lampiran foto',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 10.0)),
                  SizedBox(
                    height: 40,
                  ),
                  FadeAnimation(
                    1.6,
                    FlatButton(
                      onPressed: () {
                         Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TindakLanjuti(id_lapor

                                  

                                   ),
                              ));
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
                            "Tindak lanjuti",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageDialog extends StatelessWidget {
  String foto_laporan;
  ImageDialog(this.foto_laporan);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
       width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 1.5,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: foto_laporan == "" ? NetworkImage(
                                  'https://git.unilim.fr/assets/no_group_avatar-4a9d347a20d783caee8aaed4a37a65930cb8db965f61f3b72a2e954a0eaeb8ba.png') : NetworkImage(
                    "https://lapor.pasamanbaratkab.go.id/image/" +
                        foto_laporan),
                fit: BoxFit.cover)),
      ),
    );
  }
}
