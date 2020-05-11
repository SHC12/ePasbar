import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class OpenPDF extends StatefulWidget {
   final String nama_file;

  const OpenPDF({Key key, this.nama_file}) : super(key: key);
  @override
  _OpenPDFState createState() => _OpenPDFState(nama_file);
}

class _OpenPDFState extends State<OpenPDF> {
  String nama_file;
  _OpenPDFState(
    String this.nama_file
  );

  String urlPDFPath = "";
  String url;
  String url_lengkap = "http:/lapor.pasamanbaratkab.go.id/pdf";
  String localPath;

  @override
  void initState() { 
    // TODO: implement initState
    super.initState();
    loadPDF().then((value) {
      setState(() {
        localPath = value;
      });
    });

    print(nama_file);

    
  }
Future<String> loadPDF() async {
    var response = await http.get("https://lapor.pasamanbaratkab.go.id/pdf/"+nama_file);

    var dir = await getApplicationDocumentsDirectory();
    File file = new File("${dir.path}/gogo.pdf");
    file.writeAsBytesSync(response.bodyBytes, flush: true);
    return file.path;
  }

  // Future<File> getFileFromUrl(String url) async {
  //   try {
  //     var data = await http.get(url);
  //     var bytes = data.bodyBytes;
  //     var dir = await getApplicationDocumentsDirectory();
  //     File file = File("${dir.path}/host.pdf");

  //     File urlFile = await file.writeAsBytes(bytes);
  //     return urlFile;
  //   } catch (e) {
  //     throw Exception("Error opening url file");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dokumen",style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: localPath != null
          ? PDFView(
              filePath: localPath,
            )
          : Center(child: CircularProgressIndicator()),
    );

  }
}