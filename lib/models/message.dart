import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String message;
  String senderId;
  String receiverId;
  FieldValue timestamp;
  String messageType;
  String photoUrl;

  // To send a text message
  Message({
    this.message,
    this.senderId,
    this.receiverId,
    this.timestamp,
    this.messageType,
  });
  // To send an image
  Message.imageMessage({
    this.message,
    this.photoUrl,
    this.senderId,
    this.receiverId,
    this.timestamp,
    this.messageType,
  });

  Map toMap() {
    var mp = Map<String, dynamic>();
    mp['message'] = this.message;
    mp['senderId'] = this.senderId;
    mp['receiverId'] = this.receiverId;
    mp['timestamp'] = this.timestamp;
    mp['messageType'] = this.messageType;
    return mp;
  }

  Message fromMap(Map<String, dynamic> mp) {
    Message _message = Message();
    _message.message = mp['message'];
    _message.senderId = mp['senderId'];
    _message.receiverId = mp['receiverId'];
    _message.timestamp = mp['timestamp'];
    _message.messageType = mp['messageType'];
    return _message;
  }
}
