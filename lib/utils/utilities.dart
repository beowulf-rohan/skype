import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skype/enum/user_state.dart';
// import 'package:image/image.dart' as Im;

class Utils {
  static String getUsername(String email) {
    return "live:${email.split('@')[0]}";
  }

  static String getInitials(String name) {
    List<String> nameSplit = name.split(" ");
    String firstName = nameSplit[0][0];
    String lastName = nameSplit[1][0];
    return (firstName + lastName);
  }

  static Future<File> pickImage({@required ImageSource source}) async {
    PickedFile file = await ImagePicker().getImage(
      source: source,
      maxWidth: 500,
      maxHeight: 500,
      imageQuality: 85,
    );
    File selectedImage = File(file.path);
    return selectedImage;
    //Use this if error pops up again.....
    /*final ImagePicker _picker = ImagePicker();
    PickedFile pickedImage = await _picker.getImage(
      source: source,
      maxWidth: 500,
      maxHeight: 500,
      imageQuality: 85,
    );
    File selectedImage = File(pickedImage.path);
    return selectedImage;*/
  }
  static int stateToNum(UserState userstate) {
    switch(userstate) {
      case UserState.Offline:
        return 0;
      case UserState.Online:
        return 1;
      default:
        return 2;
    }
  }

  static UserState numToState(int num) {
    switch(num) {
      case 0:
        return UserState.Offline;
      case 1:
        return UserState.Online;
      default:
        return UserState.Waiting;
    }
  }

}
