import 'package:flutter/material.dart';
import 'package:golf_cart_driver/screens/home.dart';
import 'package:golf_cart_driver/screens/login.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/user.dart';

enum Type {
  student,
  driver,
}

class RegisterPageScreen extends StatefulWidget {
  RegisterPageScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RegisterPageScreenScreen createState() => _RegisterPageScreenScreen();
}

class _RegisterPageScreenScreen extends State<RegisterPageScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _password2Controller = TextEditingController();

  bool _showPassword = false;
  String type = 'Select account type';
  Type _type;
  void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  Widget build(BuildContext context) {
    UserProvider authsProvider = Provider.of<UserProvider>(context);
    AppStateProvider app = Provider.of<AppStateProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.blueAccent, //change your color here
        ),
        backgroundColor: Colors.white,
        leading: Icon(Icons.keyboard_arrow_left),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Center(
                  child: Text(
                'SignUp Now',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              )),
              Center(
                child: Text(
                  'Kindly Fill all the details to get started',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 30, left: 30, right: 30),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new TextFormField(
                        controller: authsProvider.name,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Name Field must not be empty';
                          }
                          return null;
                        },
                        decoration: new InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 10.0),
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .nextFocus(), // move focus to next
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new TextFormField(
                        controller: authsProvider.phone,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Phone Field must not be empty';
                          }
                          return null;
                        },
                        decoration: new InputDecoration(
                          labelText: 'Phone Number ex 5*******',
                          border: OutlineInputBorder(),
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 10.0),
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .nextFocus(), // move focus to next
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: authsProvider.email,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Email Field must not be empty';
                          }
                          return null;
                        },
                        decoration: new InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 10.0),
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .nextFocus(), // move focus to next
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: authsProvider.password,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .nextFocus(), // move focus to next
                        obscureText: !_showPassword,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Password Field must not be empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Password",
                          border: OutlineInputBorder(),
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 10.0),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              _togglevisibility();
                            },
                            child: Container(
                              height: 50,
                              width: 70,
                              padding: EdgeInsets.symmetric(vertical: 13),
                              child: Center(
                                child: Text(
                                  _showPassword ? "Hide" : "Show",
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30)),
                        child: TextButton(
                          onPressed: () async {
                            if (!await authsProvider.signUp(app.position)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Registration failed!")));

                              return;
                            }
                            authsProvider.clearController();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHomePage()),
                                (route) => false);
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize:
                                Size(MediaQuery.of(context).size.width, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text('Register',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPageScreen()));
                      },
                      child: Container(
                        padding: EdgeInsets.all(30),
                        child: Text('Have an Account? Log In'),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../helpers/screen_navigation.dart';
// import '../helpers/style.dart';
// import '../providers/app_provider.dart';
// import '../providers/user.dart';
// import '../widgets/custom_text.dart';
// import '../widgets/loading.dart';
// import 'home.dart';
// import 'login.dart';

// class RegistrationScreen extends StatefulWidget {
//   @override
//   _RegistrationScreenState createState() => _RegistrationScreenState();
// }

// class _RegistrationScreenState extends State<RegistrationScreen> {
//   final _key = GlobalKey<ScaffoldState>();

//   @override
//   Widget build(BuildContext context) {
//     UserProvider authProvider = Provider.of<UserProvider>(context);
//     AppStateProvider app = Provider.of<AppStateProvider>(context);

//     return Scaffold(
//       key: _key,
//       backgroundColor: Colors.deepOrange,
//       body: authProvider.status == Status.Authenticating
//           ? Loading()
//           : SingleChildScrollView(
//               child: Column(
//                 children: <Widget>[
//                   Container(
//                     color: white,
//                     height: 100,
//                   ),
//                   Container(
//                     color: white,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Image.asset(
//                           "images/lg.png",
//                           width: 230,
//                           height: 120,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     height: 40,
//                     color: white,
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Container(
//                       decoration: BoxDecoration(
//                           border: Border.all(color: white),
//                           borderRadius: BorderRadius.circular(5)),
//                       child: Padding(
//                         padding: EdgeInsets.only(left: 10),
//                         child: TextFormField(
//                           controller: authProvider.name,
//                           decoration: InputDecoration(
//                               hintStyle: TextStyle(color: white),
//                               border: InputBorder.none,
//                               labelStyle: TextStyle(color: white),
//                               labelText: "Name",
//                               hintText: "eg: Santos Enoque",
//                               icon: Icon(
//                                 Icons.person,
//                                 color: white,
//                               )),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Container(
//                       decoration: BoxDecoration(
//                           border: Border.all(color: white),
//                           borderRadius: BorderRadius.circular(5)),
//                       child: Padding(
//                         padding: EdgeInsets.only(left: 10),
//                         child: TextFormField(
//                           controller: authProvider.email,
//                           decoration: InputDecoration(
//                               hintStyle: TextStyle(color: white),
//                               border: InputBorder.none,
//                               labelStyle: TextStyle(color: white),
//                               labelText: "Email",
//                               hintText: "santos@enoque.com",
//                               icon: Icon(
//                                 Icons.email,
//                                 color: white,
//                               )),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Container(
//                       decoration: BoxDecoration(
//                           border: Border.all(color: white),
//                           borderRadius: BorderRadius.circular(5)),
//                       child: Padding(
//                         padding: EdgeInsets.only(left: 10),
//                         child: TextFormField(
//                           controller: authProvider.phone,
//                           decoration: InputDecoration(
//                               hintStyle: TextStyle(color: white),
//                               border: InputBorder.none,
//                               labelStyle: TextStyle(color: white),
//                               labelText: "Phone",
//                               hintText: "+91 3213452",
//                               icon: Icon(
//                                 Icons.phone,
//                                 color: white,
//                               )),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Container(
//                       decoration: BoxDecoration(
//                           border: Border.all(color: white),
//                           borderRadius: BorderRadius.circular(5)),
//                       child: Padding(
//                         padding: EdgeInsets.only(left: 10),
//                         child: TextFormField(
//                           controller: authProvider.password,
//                           decoration: InputDecoration(
//                               hintStyle: TextStyle(color: white),
//                               border: InputBorder.none,
//                               labelStyle: TextStyle(color: white),
//                               labelText: "Password",
//                               hintText: "at least 6 digits",
//                               icon: Icon(
//                                 Icons.lock,
//                                 color: white,
//                               )),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(10),
//                     child: GestureDetector(
//                       onTap: () async {
//                         if (!await authProvider.signUp(app.position)) {
//                           // _key.currentState.showSnackBar(
//                           //     SnackBar(content: Text("Registration failed!"))
//                           // );
//                           return;
//                         }
//                         authProvider.clearController();
//                         changeScreenReplacement(context, MyHomePage());
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                             color: black,
//                             borderRadius: BorderRadius.circular(5)),
//                         child: Padding(
//                           padding: EdgeInsets.only(top: 10, bottom: 10),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               CustomText(
//                                 text: "Register",
//                                 color: white,
//                                 size: 22,
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       changeScreen(context, LoginScreen());
//                     },
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         CustomText(
//                           text: "Login here",
//                           size: 20,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }
