import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skype/Constants/strings.dart';
import 'package:skype/models/message.dart';
import 'package:skype/models/user.dart';
import 'package:skype/provider/image_upload_provider.dart';
import 'package:skype/utils/utilities.dart';

class FirebaseMethods {
  User user = User();
  GoogleSignIn _googleSignIn = GoogleSignIn();
  StorageReference _storageReference;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final Firestore firestore = Firestore.instance;

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

  Future<FirebaseUser> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication = await _signInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: _signInAuthentication.accessToken, idToken: _signInAuthentication.idToken);
    FirebaseUser user = await _auth.signInWithCredential(credential);
    return user;
  }

  Future<bool> authenticateUser(FirebaseUser user) async {
    QuerySnapshot result =
        await firestore.collection(USERS_COLLECTION).where(EMAIL_FIELD, isEqualTo: user.email).getDocuments();
    final List<DocumentSnapshot> docs = result.documents;
    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(FirebaseUser currentUser) async {
    String username = Utils.getUsername(currentUser.email);
    user = User(
        uid: currentUser.uid,
        email: currentUser.email,
        name: currentUser.displayName,
        profilePhoto: currentUser.photoUrl,
        username: username);
    firestore.collection(USERS_COLLECTION).document(currentUser.uid).setData(user.toMap(user));
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    return await _auth.signOut();
  }

  Future<List<User>> fetchAllUsers(FirebaseUser user) async {
    List<User> userList = [];
    QuerySnapshot querySnapshot = await firestore.collection(USERS_COLLECTION).getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != user.uid)
        userList.add(User.fromMap(querySnapshot.documents[i].data));
    }
    return userList;
  }

  Future<void> addMessageToDb(Message message, User sender, User receiver) async {
    var mp = message.toMap();
    await firestore
        .collection(MESSAGES_COLLECTION)
        .document(message.senderId)
        .collection(message.receiverId)
        .add(mp);
    return await firestore
        .collection(MESSAGES_COLLECTION)
        .document(message.receiverId)
        .collection(message.senderId)
        .add(mp);
  }

  Future<String> uploadImageToStorage(File image) async {
    try {
      _storageReference = FirebaseStorage.instance.ref().child(
            '${DateTime.now().millisecondsSinceEpoch}',
          );
      StorageUploadTask _storageUploadTask = _storageReference.putFile(image);
      var url = await (await _storageUploadTask.onComplete).ref.getDownloadURL();
      return url;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void setImage(String url, String senderId, String receiverId) async {
    Message _message = Message.imageMessage(
      message: "IMAGE",
      photoUrl: url,
      senderId: senderId,
      receiverId: receiverId,
      timestamp: Timestamp.now(),
      messageType: 'image',
    );

    var mp = _message.toImageMap();
    await firestore
        .collection(MESSAGES_COLLECTION)
        .document(_message.senderId)
        .collection(_message.receiverId)
        .add(mp);
    await firestore
        .collection(MESSAGES_COLLECTION)
        .document(_message.receiverId)
        .collection(_message.senderId)
        .add(mp);
  }

  void uploadImage(File image, String senderId, String receiverId, ImageUploadProvider imageUploadProvider) async {
    imageUploadProvider.setToLoading();
    String url = await uploadImageToStorage(image);
    imageUploadProvider.setToIdle();
    setImage(url, senderId, receiverId);
  }
}
