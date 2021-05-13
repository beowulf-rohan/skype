import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
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
  }
}
