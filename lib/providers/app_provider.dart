import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:golf_cart_driver/services/map_requests.dart';
import 'package:golf_cart_driver/services/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:typed_data';

import '../helpers/constants.dart';
import '../helpers/style.dart';
import '../models/ride_Request.dart';
import '../models/rider.dart';
import '../models/route.dart';
import '../services/ride_request.dart';
import '../services/rider.dart';

enum Show { RIDER, TRIP }

class AppStateProvider with ChangeNotifier {
  static const ACCEPTED = 'accepted';
  static const CANCELLED = 'cancelled';
  static const PENDING = 'pending';
  static const EXPIRED = 'expired';
  // ANCHOR: VARIABLES DEFINITION
  Set<Marker> _markers = {};
  Set<Polyline> _poly = {};
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  GoogleMapController _mapController;
  Position position;
  static LatLng _center;
  LatLng _lastPosition = _center;
  TextEditingController _locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  LatLng get center => _center;
  LatLng get lastPosition => _lastPosition;
  TextEditingController get locationController => _locationController;
  Set<Marker> get markers => _markers;
  Set<Polyline> get poly => _poly;
  GoogleMapController get mapController => _mapController;
  RouteModel routeModel;
  SharedPreferences prefs;

  Location location = new Location();
  bool hasNewRideRequest = true;
  UserServices _userServices = UserServices();
  RideRequestModel rideRequestModel;
  RequestModelFirebase requestModelFirebase;

  RiderModel riderModel;
  RiderServices _riderServices = RiderServices();
  double distanceFromRider = 0;
  double totalRideDistance = 0;
  StreamSubscription<QuerySnapshot> requestStream;
  int timeCounter = 0;
  double percentage = 0;
  Timer periodicTimer;
  RideRequestServices _requestServices = RideRequestServices();
  Show show;

  AppStateProvider() {
//    _subscribeUser();
    String initialMessage;
    bool _resolved = false;
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      FirebaseMessaging.onMessage.listen(showFlutterNotification);
      print('new Message Here');
    });
    _getUserLocation();
    Geolocator.getPositionStream().listen(_userCurrentLocationUpdate);
  }

  void showFlutterNotification(RemoteMessage message) {
    AndroidNotificationChannel channel;
    RemoteNotification notification = message.notification;
    AndroidNotification android = message.notification?.android;
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: 'launch_background',
          ),
        ),
      );
    }
  }

  void receivedMessage(RemoteMessage remoteMessage) {
    _handleNotificationData(remoteMessage.data);
  }

  // ANCHOR LOCATION METHODS
  _userCurrentLocationUpdate(Position updatedPosition) async {
    double distance = await Geolocator.distanceBetween(
        prefs.getDouble('lat'),
        prefs.getDouble('lng'),
        updatedPosition.latitude,
        updatedPosition.longitude);
    Map<String, dynamic> values = {
      "id": prefs.getString("id"),
      "position": updatedPosition.toJson()
    };

    if (show == Show.RIDER) {
      sendRequest(coordinates: requestModelFirebase.getCoordinates());
    }
    _userServices.updateUserData(values);
    await prefs.setDouble('lat', updatedPosition.latitude);
    await prefs.setDouble('lng', updatedPosition.longitude);
  }

  _getUserLocation() async {
    prefs = await SharedPreferences.getInstance();
    position = await Geolocator.getCurrentPosition();
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    _center = LatLng(position.latitude, position.longitude);
    await prefs.setDouble('lat', position.latitude);
    await prefs.setDouble('lng', position.longitude);
    _locationController.text = placemark[0].name;
    notifyListeners();
  }

  // ANCHOR MAPS METHODS

  onCreate(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  setLastPosition(LatLng position) {
    _lastPosition = position;
    notifyListeners();
  }

  onCameraMove(CameraPosition position) {
    _lastPosition = position.target;
    notifyListeners();
  }

  void sendRequest({String intendedLocation, LatLng coordinates}) async {
    LatLng origin = LatLng(position.latitude, position.longitude);

    LatLng destination = coordinates;
    RouteModel route =
        await _googleMapsServices.getRouteByCoordinates(origin, destination);
    routeModel = route;
    addLocationMarker(
        destination, routeModel.endAddress, routeModel.distance.text);
    _center = destination;
    destinationController.text = routeModel.endAddress;

    _createRoute(route.points);
    notifyListeners();
  }

  void _createRoute(String decodeRoute) {
    _poly = {};
    var uuid = new Uuid();
    String polyId = uuid.v1();
    poly.add(Polyline(
        polylineId: PolylineId(polyId),
        width: 8,
        color: primary,
        onTap: () {},
        points: _convertToLatLong(_decodePoly(decodeRoute))));
    notifyListeners();
  }

  List<LatLng> _convertToLatLong(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  // ANCHOR MARKERS
  addLocationMarker(LatLng position, String destination, String distance) {
    _markers = {};
    var uuid = new Uuid();
    String markerId = uuid.v1();
    _markers.add(Marker(
        markerId: MarkerId(markerId),
        position: position,
        infoWindow: InfoWindow(title: destination, snippet: distance),
        icon: BitmapDescriptor.defaultMarker));
    notifyListeners();
  }

  Future<Uint8List> getMarker(BuildContext context) async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("images/car.png");
    return byteData.buffer.asUint8List();
  }

  clearMarkers() {
    _markers.clear();
    notifyListeners();
  }

  _saveDeviceToken() async {
    print('Save Token Here');
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') == null) {
      String deviceToken = await fcm.getToken();
      await prefs.setString('token', deviceToken);
    }
  }

  // Future<void> onNewRequest() async {
  //   HttpsCallable cal =
  //       FirebaseFunctions.instance.httpsCallable('rideRequestNotification');
  //   final response = await cal.call();
  //   await _handleNotificationData(response.data);
  //   print(response.data);
  // }

// ANCHOR PUSH NOTIFICATION METHODS
  Future handleOnMessage(Map<String, dynamic> data) async {
    await _handleNotificationData(data);
  }

  Future handleOnLaunch(Map<String, dynamic> data) async {
    await _handleNotificationData(data);
  }

  Future handleOnResume(Map<String, dynamic> data) async {
    await _handleNotificationData(data);
  }

  Future<void> _handleNotificationData(Map<String, dynamic> data) async {
    print('_handleNotificationData');
    hasNewRideRequest = true;
    rideRequestModel = RideRequestModel.fromMap(data['data']);
    riderModel =
        await _riderServices.getRiderById("m1jnTvGAgCXKtV9k8BTeW0m2GNi1");
    notifyListeners();
  }

// ANCHOR RIDE REQUEST METHODS
  changeRideRequestStatus() {
    print('changeRideRequestStatus');
    hasNewRideRequest = false;
    notifyListeners();
  }

  listenToRequest({String id, BuildContext context}) async {
    print("======= LISTENING =======");
    print('listenToRequest');
    requestStream = _requestServices.requestStream().listen((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc.get('id') == id) {
          requestModelFirebase = RequestModelFirebase.fromFirestore(doc.data());
          notifyListeners();
          switch (doc.get('status')) {
            case CANCELLED:
              print("====== CANCELELD");
              break;
            case ACCEPTED:
              print("====== ACCEPTED");
              break;
            case EXPIRED:
              print("====== EXPIRED");
              break;
            default:
              print("==== PEDING");
              break;
          }
        }
      });
    });
  }

  //  Timer counter for driver request
  percentageCounter({String requestId, BuildContext context}) {
    notifyListeners();
    periodicTimer = Timer.periodic(Duration(seconds: 1), (time) {
      timeCounter = timeCounter + 1;
      percentage = timeCounter / 100;
      print("====== GOOOO $timeCounter");
      if (timeCounter == 100) {
        timeCounter = 0;
        percentage = 0;
        time.cancel();
        hasNewRideRequest = false;
        requestStream.cancel();
      }
      notifyListeners();
    });
  }

  acceptRequest({String requestId, String driverId}) {
    hasNewRideRequest = false;
    _requestServices.updateRequest(
        {"id": requestId, "status": "pending", "driverId": driverId});
    notifyListeners();
  }

  cancelRequest({String requestId}) {
    hasNewRideRequest = false;
    _requestServices.updateRequest({"id": requestId, "status": "cancelled"});
    notifyListeners();
  }

  //  ANCHOR UI METHODS
  changeWidgetShowed({Show showWidget}) {
    show = showWidget;
    notifyListeners();
  }
}
