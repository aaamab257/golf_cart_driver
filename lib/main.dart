import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:golf_cart_driver/providers/app_provider.dart';
import 'package:golf_cart_driver/providers/user.dart';
import 'package:golf_cart_driver/screens/login.dart';
import 'package:golf_cart_driver/screens/splash.dart';
import 'helpers/constants.dart';
import 'locators/service_locator.dart';
import 'screens/home.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  setupLocator();
  LocationPermission permission;
  permission = await Geolocator.requestPermission();
  return runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AppStateProvider>.value(
        value: AppStateProvider(),
      ),
      ChangeNotifierProvider.value(value: UserProvider.initialize()),
    ],
    child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.blue),
        title: "Golf Cart Driver",
        home: MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserProvider auth = Provider.of<UserProvider>(context);

    return ScreenUtilInit(
      designSize: const Size(411, 823),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Golf Cart',
        home: Splash(),
      ),
    );
  }

  // Once complete, show your application
  // if (snapshot.connectionState == ConnectionState.done) {
  //   switch (auth.status) {
  //     case Status.Uninitialized:
  //       return Splash();
  //     case Status.Unauthenticated:
  //     case Status.Authenticating:
  //       return LoginScreen();
  //     case Status.Authenticated:
  //       return MyHomePage();
  //     default:
  //       return LoginScreen();
  //   }
  // }

  // Otherwise, show something whilst waiting for initialization to complete
  // return Scaffold(
  //   body: Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [CircularProgressIndicator()],
  //   ),
  // );

}
