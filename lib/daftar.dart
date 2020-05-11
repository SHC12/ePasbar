import 'dart:convert';

import 'package:epasbar/animasi/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class Daftar extends StatefulWidget {
  @override
  _DaftarState createState() => _DaftarState();
}

class _DaftarState extends State<Daftar> {
  bool _isSelected = false;

  bool _isLoading = false;

  TextEditingController c_kata_sandi = TextEditingController();

  String s_nama_lengkap,
      s_no_hp,
      s_password,
      s_daerah;

  final _key = GlobalKey<FormState>();

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
       signup();
  
    }
  }

  signup() async {
    Map data = {
      'nama_lengkap': s_nama_lengkap,
      'no_hp': s_no_hp,
      'alamat': s_daerah,
      'password': s_password
    };
    
    var jsonResponse = null;
    var response = await http.post(
        "https://lapor.pasamanbaratkab.go.id/api_android/register.php",
        body: data);

    jsonResponse = json.decode(response.body);
     if (jsonResponse != null) {
        int code_status = jsonResponse['status'];
        String code_message = jsonResponse['message'];

        print("$code_status.$code_message");

        if (code_status == 1) {
            setState(() {
              Fluttertoast.showToast(
        msg: "Berhasil, silahkan login",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0
    );
              Navigator.pop(context);
            });
        }else if(code_status == 2){
          setState(() {
                Fluttertoast.showToast(
        msg: "Nomor telepon telah digunakan, silahkan ubah kembali",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0
    );
          });
          print(code_message);
        }else{
          print(code_message);
        }
   
   }
    

  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: Form(
        key: _key,
        child: Container(
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
                          "Daftar",
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    FadeAnimation(
                        1.3,
                        Text(
                          "Silahkan daftar",
                          style: TextStyle(color: Colors.white, fontSize: 18),
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
                                          color:
                                              Color.fromRGBO(32, 132, 232, .3),
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
                                                  color: Colors.grey[200]))),
                                      child: TextFormField(
                                        validator: (e) {
                                          if (e.isEmpty) {
                                            return "Silahkan isi nomor telepon";
                                          }
                                        },
                                        onSaved: (e) => s_no_hp = e,
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                            hintText: "Nomor telepon",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: TextFormField(
                                        validator: (e) {
                                          if (e.isEmpty) {
                                            return "Silahkan isi nama lengkap";
                                          }
                                        },
                                        onSaved: (e) => s_nama_lengkap = e,
                                        decoration: InputDecoration(
                                            hintText: "Nama Lengkap",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: TextFormField(
                                        validator: (e) {
                                          if (e.isEmpty) {
                                            return "Silahkan isi alamat lengkap";
                                          }
                                        },
                                        onSaved: (e) => s_daerah = e,
                                        decoration: InputDecoration(
                                            hintText: "Alamat lengkap",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: TextFormField(
                                        validator: (e) {
                                          if (e.isEmpty) {
                                            return "Silahkan isi kata sandi";
                                          }
                                        },
                                        controller: c_kata_sandi,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                            hintText: "Kata sandi",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: TextFormField(
                                        validator: (e) {
                                          if (e != c_kata_sandi.text) {
                                            return "Kata sandi tidak sama dengan kata sandi diatas";
                                          } else {
                                            return null;
                                          }
                                        },
                                        onSaved: (e) => s_password = e,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                            hintText: "Konfirmasi kata sandi",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
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
                               check();
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
                                    "OK",
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
      ),
    );
  }
}
