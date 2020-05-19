import 'dart:convert';

import 'package:epasbar/animasi/FadeAnimation.dart';
import 'package:epasbar/widgets/myheader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

class OperOPD extends StatefulWidget {
  String id_lapor;
  OperOPD(this.id_lapor);



  @override
  _OperOPDState createState() => _OperOPDState(id_lapor);
}

class _OperOPDState extends State<OperOPD> {

  double offset = 0;
  List kategoriOPD;
  String _myKategoriOPD;
   ProgressDialog pr;

   String id_lapor;
   _OperOPDState(this.id_lapor);

  Future<String> _getOPDList() async {
    await http
        .get("https://lapor.pasamanbaratkab.go.id/api_android/get_opd.php")
        .then((response) {
      var data = json.decode(response.body);
      print(data);
      setState(() {
        kategoriOPD = data;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getOPDList();
  }

  @override
  Widget build(BuildContext context) {
     pr = new ProgressDialog(context, type: ProgressDialogType.Normal);

    //Optional
    pr.style(
      message: 'Mohon Tunggu...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    return Scaffold(

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
             MyHeader(
              image: "assets/icons/buat_laporan.svg",
              textTop: "",
              textBottom: "",
              offset: offset,
            ),
             Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Color(0xFFE5E5E5),
                ),
              ),
              child: Row(
                children: <Widget>[
                  SvgPicture.asset("assets/icons/maps-and-flags.svg"),
                  SizedBox(width: 20),
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      underline: SizedBox(),
                      icon: SvgPicture.asset("assets/icons/dropdown.svg"),
                      value: _myKategoriOPD,
                      hint: Text("Pilih Dinas Terkait"),
                      onChanged: (String newValue) {
                        setState(() {
                          _myKategoriOPD = newValue;
                          
                          print(_myKategoriOPD);
                        });
                      },
                      items: kategoriOPD?.map((item) {
                            return new DropdownMenuItem(
                              child: new Text(item['nama_lengkap']),
                              value: item['id_kategori'].toString(),
                            );
                          })?.toList() ??
                          [],
                    ),
                  ),
                ],
              ),
            ),
             SizedBox(height: 20),
            FadeAnimation(
              1.6,
              FlatButton(
                onPressed: () {
                  // String ket_lap = tf_ket_laporan.text;

                  // if (ket_lap != null && _image != null) {
                  //   _startUploading();
                  // } else if (_myKategori == null) {
                  //   messageAllertGagal("Silahkan pilih jenis laporan", "Gagal");
                  // } else if (ket_lap == null) {
                  //   messageAllertGagal(
                  //       "Silahkan isi keterangan aduan", "Gagal");
                  // } else {
                  //   _startUploadingNonImage();
                  // }

                  if(_myKategoriOPD == null){
                    messageAllertGagal("Silahkan pilih OPD terkait", "Gagal");
                  }else{
                      _startUploading();
                  }

                  print(id_lapor);
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
                      "KIRIM",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
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
   Uri apiUrl = Uri.parse(
      'https://lapor.pasamanbaratkab.go.id/api_android/oper_aduan.php');

  Future<Map<String, dynamic>> _updateLaporan() async {
    setState(() {
      pr.show();
    });



    final imageUploadRequest = http.MultipartRequest('POST', apiUrl);

  
  

    imageUploadRequest.fields['id_lapor'] = id_lapor;
    imageUploadRequest.fields['id_kategori'] = _myKategoriOPD;
     
    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200) {
        return null;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      String code = responseData['code'];
      if (code == 1) {
        _resetState();
        return responseData;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

void _resetState() {
    setState(() {
      pr.hide();
    });
  }

  void _startUploading() async {
    
    String opd = _myKategoriOPD;
    if ( opd != null) {
      final Map<String, dynamic> response = await _updateLaporan();

      if (response == null) {
        pr.hide();
        messageAllert('Data Berhasil Dikirim', 'Sukses');
      } else {
        messageAllertGagal('Data tidak boleh ada yang kosong', 'Gagal');
      }
    }
  }

   messageAllert(String msg, String ttl) {
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            title: Text(ttl),
            content: Text(msg),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Text('Ok'),
                  ],
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  messageAllertGagal(String msg, String ttl) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            title: Text(ttl),
            content: Text(msg),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Text('Oke'),
                  ],
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
