import 'package:epasbar/admin/laporan_admin.dart';
import 'package:epasbar/constant.dart';
import 'package:epasbar/home.dart';
import 'package:epasbar/pelaporan.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  String level;

  Future getDataPengguna() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    level = prefs.getString('level');
  }

  int _currentindex = 0;

  final List<Widget> _children = [HomeScreen(), Pelaporan()];
  final List<Widget> _children2 = [HomeScreen(), PelaporanAdmin()];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataPengguna();
  }
  
  void onTappedBar(int index) {
    setState(() {
      _currentindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: level == '1' ? _children2[_currentindex] : _children[_currentindex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTappedBar,
          currentIndex: _currentindex,
          items: [
            BottomNavigationBarItem(
                icon: new Icon(Icons.home), title: new Text("Beranda")),
            BottomNavigationBarItem(
                icon: new Icon(Icons.event_note), title: new Text("Lapor")),
          ]),
    );
  }
}
