import 'dart:convert';

import 'package:epasbar/animasi/FadeAnimation.dart';
import 'package:epasbar/constant.dart';
import 'package:epasbar/widgets/myheader.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HasilTindakan extends StatefulWidget {
  String id_lapor;
  HasilTindakan(this.id_lapor);

  @override
  _HasilTindakanState createState() => _HasilTindakanState(id_lapor);
}

class _HasilTindakanState extends State<HasilTindakan> {
  String id_lapor;
  _HasilTindakanState(this.id_lapor);
  double offset = 0;
  String nama;
  String tindakan;
  String tanggal;
  String foto;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_tindakan();
  }

   void get_tindakan() async {
    var jsonResponse = null;
    var response = await http
        .get("https://lapor.pasamanbaratkab.go.id/api_android/get_tindakan.php?id_lapor="+id_lapor);

    jsonResponse = json.decode(response.body);
    if (jsonResponse != null) {
      setState(() {
        var data = jsonResponse[0];
        nama = data['nama_lengkap'];
        tindakan = data['tindakan'];
        tanggal = data['tanggal'];
        foto = data['foto'];
      
      });

    
    }
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
                        child: Text("Dari : " + nama))
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
                    Flexible(child: Text("Keterangan : "+tindakan)),
                    Flexible(child: Text(""))
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
                    Flexible(child: Text("Tanggal Tanggapan : "+tanggal ))
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
                              builder: (_) => ImageDialog(foto));
                        },
                        child: CircleAvatar(
                          backgroundImage: foto == ""
                              ? NetworkImage(
                                  'https://git.unilim.fr/assets/no_group_avatar-4a9d347a20d783caee8aaed4a37a65930cb8db965f61f3b72a2e954a0eaeb8ba.png')
                              : NetworkImage(
                                  "https://lapor.pasamanbaratkab.go.id/image/" +
                                      foto),
                          radius: 50.0,
                        ),
                      ),
                    ],
                  ),
                  Text('Lampiran foto',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 10.0)),
          ],
        ),
      ),
      
    );
  }
}

class ImageDialog extends StatelessWidget {
  String foto;
  ImageDialog(this.foto);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 1.5,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: foto == "" ? NetworkImage(
                                  'https://git.unilim.fr/assets/no_group_avatar-4a9d347a20d783caee8aaed4a37a65930cb8db965f61f3b72a2e954a0eaeb8ba.png') : NetworkImage(
                    "https://lapor.pasamanbaratkab.go.id/image/" +
                        foto),
                fit: BoxFit.cover)),
      ),
    );
  }
}