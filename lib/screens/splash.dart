import 'package:flutter/material.dart';
import 'package:golf_cart_driver/screens/login.dart';
import 'package:golf_cart_driver/screens/registration.dart';

import '../helpers/style.dart';
import '../widgets/loading.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Image.asset('Assets/Main.jpg'),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Text(
                    'Welcome',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Create an account and select nearest car',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 60),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(20),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(30)),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPageScreen()));
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize:
                            Size(MediaQuery.of(context).size.width, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text('Getting Started',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPageScreen()));
                      },
                      child: Text("Dont have an account ? Register"))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
