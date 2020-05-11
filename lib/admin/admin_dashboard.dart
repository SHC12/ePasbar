import 'package:epasbar/admin/laporan_admin.dart';
import 'package:epasbar/constant.dart';
import 'package:epasbar/home.dart';
import 'package:epasbar/pelaporan.dart';
import 'package:flutter/material.dart';




class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
   int _currentindex = 0;
  final List<Widget> _children = [
    HomeScreen(),
    PelaporanAdmin()
  ]; 

  void onTappedBar(int index){
    setState(() {
      _currentindex = index;
    });

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _children[_currentindex],      
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

