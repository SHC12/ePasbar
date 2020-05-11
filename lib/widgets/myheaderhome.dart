import 'package:epasbar/animasi/FadeAnimation.dart';
import 'package:epasbar/constant.dart';
import 'package:epasbar/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHeaderHome extends StatefulWidget {
  final String image;
  final String textTop;
  final String textBottom;
  final double offset;
  const MyHeaderHome(
      {Key key, this.image, this.textTop, this.textBottom, this.offset})
      : super(key: key);

  @override
  _MyHeaderHomeState createState() => _MyHeaderHomeState();
}

class _MyHeaderHomeState extends State<MyHeaderHome> {
  SharedPreferences pref;
  String id_user;
   dataAkun() async {
    pref = await SharedPreferences.getInstance();

    setState(() {
      id_user = pref.getString('id_user') ?? '0';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    dataAkun();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyClipper(),
      child: FadeAnimation(
        1,
              Container(
          padding: EdgeInsets.only(left: 40, top: 50, right: 20),
          height: MediaQuery.of(context).size.height / 2.3,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFF3383CD),
                Color(0xFF11249F),
              ],
            ),
            image: DecorationImage(
              image: AssetImage("assets/images/virus.png"),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  // Navigator.push(  
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) {
                  //       return InfoScreen();
                  //     },
                  //   ),
                  // );

                  pref.clear();
                pref.commit();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen()),
                    (Route<dynamic> route) => false);
                },
               // child: SvgPicture.asset("assets/icons/menu.svg"),
                child: Icon(Icons.exit_to_app, color: Colors.white,),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: (widget.offset < 0) ? 0 : widget.offset,
                      child: SvgPicture.asset(
                        widget.image,
                        width: 230,
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    Positioned(
                      top: 20 - widget.offset / 2,
                      left: 150,
                      child: FadeAnimation(
                        1,
                        Text(
                          "${widget.textTop} \n${widget.textBottom}",
                          style: kHeadingTextStyle.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(), // I dont know why it can't work without container
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
