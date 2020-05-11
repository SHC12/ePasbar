import 'dart:convert';

import 'package:epasbar/admin/admin_dashboard.dart';
import 'package:epasbar/animasi/FadeAnimation.dart';
import 'package:epasbar/daftar.dart';
import 'package:epasbar/home.dart';
import 'package:epasbar/second_main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSelected = false;

  bool _isLoading = false;

  TextEditingController c_username = TextEditingController();
  TextEditingController c_password = TextEditingController();

  void _radio() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  signIn(String username, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'no_hp': username, 'password': password};
    var jsonResponse = null;
    var response = await http.post(
        "https://lapor.pasamanbaratkab.go.id/api_android/login.php",
        body: data);

    jsonResponse = json.decode(response.body);

    setState(() {
      _isLoading = false;

      if (jsonResponse != null) {
        int success = jsonResponse['status'];
        String level = jsonResponse['level'];

        if (success == 1 && level == '1') {
          setState(() {
            Fluttertoast.showToast(
                msg: "Berhasil login",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                fontSize: 16.0);
            //   _isLoading = false;
          });
          sharedPreferences.setString("no_telepon", jsonResponse['no_telepon']);
          sharedPreferences.setString("level", jsonResponse['level']);
          sharedPreferences.setString(
              "kode_instansi", jsonResponse['kode_instansi']);
          sharedPreferences.setString("id_user", jsonResponse['id_user']);

          sharedPreferences.setString(
              "nama_lengkap", jsonResponse['nama_lengkap']);
          print(jsonResponse['daerah']);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => MyBottomNavigationBar()),
              (Route<dynamic> route) => false);
        }else if (success == 1 && level == '2') {
          setState(() {
            Fluttertoast.showToast(
                msg: "Berhasil login",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                fontSize: 16.0);
            //   _isLoading = false;
          });
          sharedPreferences.setString("level", jsonResponse['level']);
          sharedPreferences.setString("no_telepon", jsonResponse['no_telepon']);
          sharedPreferences.setString(
              "kode_instansi", jsonResponse['kode_instansi']);
          sharedPreferences.setString("id_user", jsonResponse['id_user']);

          sharedPreferences.setString(
              "nama_lengkap", jsonResponse['nama_lengkap']);
          print(jsonResponse['daerah']);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => MyBottomNavigationBar()),
              (Route<dynamic> route) => false);
        } else if (success == 2) {
          setState(() {
            Fluttertoast.showToast(
                msg:
                    "Akun anda belum diaktifkan, silahkan hubungi admin OPD Anda",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                fontSize: 16.0);

            //_isLoading = false;
          });
        } else {
          setState(() {
            Fluttertoast.showToast(
                msg: "Nomor telepon atau Kata Sandi Salah",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                fontSize: 16.0);

            //_isLoading = false;
          });
        }
      } else {
        print(response.body);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                Colors.blue[900],
                Colors.blue[800],
                Colors.blue[400]
              ])),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FadeAnimation(
                            1,
                            Text(
                              "Login",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 40),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        FadeAnimation(
                            1.3,
                            Text(
                              "Silahkan login",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60))),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 60,
                              ),
                              FadeAnimation(
                                  1.4,
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color.fromRGBO(
                                                  32, 132, 232, .3),
                                              blurRadius: 20,
                                              offset: Offset(0, 10))
                                        ]),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color:
                                                          Colors.grey[200]))),
                                          child: TextField(
                                            controller: c_username,
                                            decoration: InputDecoration(
                                                hintText: "Nomor telepon",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: InputBorder.none),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color:
                                                          Colors.grey[200]))),
                                          child: TextField(
                                            controller: c_password,
                                            obscureText: true,
                                            decoration: InputDecoration(
                                                hintText: "Kata sandi",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: InputBorder.none),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              SizedBox(
                                height: 40,
                              ),

                              //  GestureDetector(
                              //   onTap: (){
                              //     print('forget working working');
                              //   },
                              //   child:  Container(
                              //     child: FadeAnimation(1.5, Text("Forgot Password?", style: TextStyle(color: Colors.grey),)),
                              //   ),
                              //  ),

                              SizedBox(
                                height: 40,
                              ),
                              FadeAnimation(
                                1.6,
                                FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    signIn(c_username.text, c_password.text);
                                    print(c_username.text);
                                    print(c_password.text);
                                  },
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: Container(
                                    height: 50,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 50),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.blue[900]),
                                    child: Center(
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              FadeAnimation(
                                1.6,
                                FlatButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Daftar(),
                                        ));
                                  },
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: Container(
                                    height: 50,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 50),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.green[900]),
                                    child: Center(
                                      child: Text(
                                        "DAFTAR",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // FadeAnimation(1.7, Text("Continue with social media  & OTP", style: TextStyle(color: Colors.grey),)),
                              // SizedBox(height: 30,),
                              // Row(
                              //  mainAxisAlignment: MainAxisAlignment.center,
                              //   children: <Widget>[

                              //     Container(
                              //       child: FadeAnimation(1.8, Container(

                              //         child: MaterialButton(
                              //         onPressed: () {},
                              //         color: Color(0xFF3b5998),
                              //         textColor: Colors.white,
                              //         child: Icon(
                              //           FontAwesomeIcons.facebookF,
                              //           size: 22,
                              //         ),
                              //         padding: EdgeInsets.all(16),
                              //         shape: CircleBorder(),
                              //       )
                              //                                     )),
                              //     ),
                              //     // SizedBox(width: 10,),
                              //     Container(

                              //       child: FadeAnimation(1.9, Container(

                              //         child: MaterialButton(
                              //         onPressed: () {},
                              //         color: Color(0xFFEA4335),
                              //         textColor: Colors.white,
                              //         child: Icon(
                              //           FontAwesomeIcons.google,
                              //           size: 22,
                              //         ),
                              //         padding: EdgeInsets.all(16),
                              //         shape: CircleBorder(),
                              //           )
                              //       )),
                              //     ),
                              //     Container(

                              //       child: FadeAnimation(1.9, Container(

                              //         child: MaterialButton(
                              //         onPressed: () {},
                              //         color: Color(0xFF34A853),
                              //         textColor: Colors.white,
                              //         child: Icon(
                              //           FontAwesomeIcons.mobileAlt,
                              //           size: 22,
                              //         ),
                              //         padding: EdgeInsets.all(16),
                              //         shape: CircleBorder(),
                              //           )
                              //       )),
                              //     ),

                              //   ],

                              // ),
                              // SizedBox(height: 20),
                              // GestureDetector(
                              //   onTap: () {
                              //     print('sign up working');
                              //   },
                              //   child: Container(
                              //     child: FadeAnimation(
                              //         1.5,
                              //         Text(
                              //           "Tidak punya akun? Silahkan Daftar",
                              //           style: TextStyle(color: Colors.grey),
                              //         )),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
