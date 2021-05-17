import 'package:flutter/widgets.dart';
import 'package:skype/models/user.dart';
import 'package:skype/resources/firebase_repository.dart';

class UserProvider with ChangeNotifier{
  User _user;
  FirebaseRepository _firebaseRepository = FirebaseRepository();
  User get getUser => _user;
  void refreshUser() async{
    User user = await _firebaseRepository.getUserDetails();
    _user = user;
    notifyListeners();
  }
}