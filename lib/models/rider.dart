import 'package:cloud_firestore/cloud_firestore.dart';

class RiderModel {
  static const ID = "id";
  static const NAME = "name";
  static const EMAIL = "email";
  static const PHONE = "phone";
  static const VOTES = "votes";
  static const TRIPS = "trips";
  static const RATING = "rating";
  static const TOKEN = "token";
  static const PHOTO = "photo";

  String _id;
  String _name;
  String _email;
  String _phone;
  String _token;
  String _photo;

  int _votes;
  int _trips;
  double _rating;

//  getters
  String get name => _name;
  String get email => _email;
  String get id => _id;
  String get phone => _phone;
  int get votes => _votes;
  int get trips => _trips;
  double get rating => _rating;
  String get token => _token;
  String get photo => _photo;

  RiderModel.fromFirestore(Map<String, dynamic> snapshot) {
    _name = snapshot[NAME];
    _email = snapshot[EMAIL];
    _id = snapshot[ID];
    _phone = snapshot[PHONE];
    _token = snapshot[TOKEN];
    _votes = snapshot[VOTES];
    _trips = snapshot[TRIPS];
    _rating = snapshot[RATING];
    _photo = snapshot[PHOTO];
  }
}
