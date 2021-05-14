import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String message;
  String senderId;
  String receiverId;
  Timestamp timestamp;
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

  Map toImageMap() {
    var mp = Map<String, dynamic>();
    mp['message'] = this.message;
    mp['photoUrl'] = this.photoUrl;
    mp['senderId'] = this.senderId;
    mp['receiverId'] = this.receiverId;
    mp['timestamp'] = this.timestamp;
    mp['messageType'] = this.messageType;
    return mp;
  }

  Message.fromMap(Map<String, dynamic> mp) {
    this.message = mp['message'];
    this.senderId = mp['senderId'];
    this.receiverId = mp['receiverId'];
    this.timestamp = mp['timestamp'];
    this.messageType = mp['messageType'];
    this.photoUrl = mp['photoUrl'];
  }
}
