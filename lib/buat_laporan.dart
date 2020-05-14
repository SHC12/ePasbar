import 'dart:convert';
import 'dart:io';

import 'package:epasbar/animasi/FadeAnimation.dart';
import 'package:epasbar/widgets/myheader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuatLaporan extends StatefulWidget {
  @override
  _BuatLaporanState createState() => _BuatLaporanState();
}

class _BuatLaporanState extends State<BuatLaporan> {
  final controller = ScrollController();
  double offset = 0;

  String id_user;

  ProgressDialog pr;

  TextEditingController tf_ket_laporan = new TextEditingController();

  List<Object> images = List<Object>();
  Future<File> _imageFile;
  File _image;
  
  List kategoriList;
  String _myKategori;
  
  List subkategoriList;
  String _mySubKategori;

  Future<String> _getKategoriList() async {
    await http
        .get("https://lapor.pasamanbaratkab.go.id/api_android/kategori.php")
        .then((response) {
      var data = json.decode(response.body);
      print(data);
      setState(() {
        kategoriList = data;
      });
    });
  }
  Future<String> _getSubKategoriList() async {
    await http
        .get("https://lapor.pasamanbaratkab.go.id/api_android/get_sub_kategori.php?kategori="+_myKategori)
        .then((response) {
      var data = json.decode(response.body);
      print(data);
      setState(() {
        subkategoriList = data;
      });
    });
  }

  Future getDataPengguna() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id_user = prefs.getString('id_user');
  }

  @override
  void initState() {
    // TODO: implement initState
    _getKategoriList();
    _getSubKategoriList();
    getDataPengguna();
    super.initState();
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
        controller: controller,
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
                      value: _myKategori,
                      hint: Text("Pilih Kategori Pelaporan"),
                      onChanged: (String newValue) {
                        setState(() {
                          _myKategori = newValue;
                          _getSubKategoriList();
                          print(_myKategori);
                        });
                      },
                      items: kategoriList?.map((item) {
                            return new DropdownMenuItem(
                              child: new Text(item['nama_kategori']),
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
                      value: _mySubKategori,
                      hint: Text("Pilih Jenis Pelaporan"),
                      onChanged: (String newValue) {
                        setState(() {
                          _mySubKategori = newValue;
                          print(_mySubKategori);
                        });
                      },
                      items: subkategoriList?.map((item) {
                            return new DropdownMenuItem(
                              child: new Text(item['nama_sub_kategori']),
                              value: item['id_sub'].toString(),
                            );
                          })?.toList() ??
                          [],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: tf_ket_laporan,
                    minLines: 1,
                    maxLines: 10,
                    decoration: new InputDecoration(
                        hintText: "Masukkan Keterangan Laporan Anda",
                        labelText: "Keterangan",
                        border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(20.0))),
                  ),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: _image == null
                          ? NetworkImage(
                              'https://git.unilim.fr/assets/no_group_avatar-4a9d347a20d783caee8aaed4a37a65930cb8db965f61f3b72a2e954a0eaeb8ba.png')
                          : FileImage(_image),
                      radius: 50.0,
                    ),
                    InkWell(
                      onTap: _onAlertPress,
                      child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.0),
                              color: Colors.black),
                          margin: EdgeInsets.only(left: 70, top: 70),
                          child: Icon(
                            Icons.photo_camera,
                            size: 25,
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
                Text('Tambahkan Gambar',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0)),
              ],
            ),
            SizedBox(height: 20),
            FadeAnimation(
              1.6,
              FlatButton(
                onPressed: () {
                  String ket_lap = tf_ket_laporan.text;

                  if (ket_lap != null && _image != null) {
                    _startUploading();
                  } else if (_myKategori == null) {
                    messageAllertGagal("Silahkan pilih jenis laporan", "Gagal");
                  } else if (ket_lap == null) {
                    messageAllertGagal(
                        "Silahkan isi keterangan aduan", "Gagal");
                  } else {
                    _startUploadingNonImage();
                  }
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

  void _onAlertPress() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Text('Galeri'),
                  ],
                ),
                onPressed: getGalleryImage,
              ),
            ],
          );
        });
  }

  Future getGalleryImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
      Navigator.pop(context);
    });
  }

  Uri apiUrl = Uri.parse(
      'https://lapor.pasamanbaratkab.go.id/api_android/buat_laporan.php');
  Future<Map<String, dynamic>> _uploadLaporan(File image) async {
    setState(() {
      pr.show();
    });

    final mimeTypeData =
        lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');

    final imageUploadRequest = http.MultipartRequest('POST', apiUrl);

    final file = await http.MultipartFile.fromPath('gbr1', image.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));

    imageUploadRequest.files.add(file);

    imageUploadRequest.fields['id_user'] = id_user;
    imageUploadRequest.fields['kategori'] = _myKategori;
    imageUploadRequest.fields['sub_kategori'] = _mySubKategori;
    imageUploadRequest.fields['ket_laporan'] = tf_ket_laporan.text;

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

  Future<Map<String, dynamic>> _uploadLaporanNonImage() async {
    setState(() {
      pr.show();
    });



    final imageUploadRequest = http.MultipartRequest('POST', apiUrl);

  
  

    imageUploadRequest.fields['id_user'] = id_user;
    imageUploadRequest.fields['kategori'] = _myKategori;
      imageUploadRequest.fields['sub_kategori'] = _mySubKategori;
    imageUploadRequest.fields['ket_laporan'] = tf_ket_laporan.text;

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
    String laporan = tf_ket_laporan.text;
    String kategori = _myKategori;
    if (laporan != null && kategori != null) {
      final Map<String, dynamic> response = await _uploadLaporan(_image);

      if (response == null) {
        pr.hide();
        messageAllert('Data Berhasil Dikirim', 'Sukses');
      } else {
        messageAllertGagal('Data tidak boleh ada yang kosong', 'Gagal');
      }
    }
  }
  void _startUploadingNonImage() async {
    String laporan = tf_ket_laporan.text;
    String kategori = _myKategori;
    if (laporan != null && kategori != null) {
      final Map<String, dynamic> response = await _uploadLaporanNonImage();

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
