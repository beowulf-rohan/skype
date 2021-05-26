import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  String uid;
  Timestamp addedOn;

  Contact({
    this.uid,
    this.addedOn,
  });

  Map toMap(Contact contact) {
    var mp = Map<String, dynamic>();
    mp['contact_id'] = contact.uid;
    mp['added_on'] = contact.addedOn;
    return mp;
  }

  Contact.fromMap(Map<String, dynamic> mp) {
    this.uid = mp['contact_id'];
    this.addedOn = mp['added_on'];
  }
}
