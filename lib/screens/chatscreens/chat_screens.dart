import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:skype/Constants/strings.dart';
import 'package:skype/enum/view_state.dart';
import 'package:skype/models/message.dart';
import 'package:skype/models/user.dart';
import 'package:skype/provider/image_upload_provider.dart';
import 'package:skype/utils/call_utilities.dart';
import 'package:skype/utils/universal_variable.dart';
import 'package:skype/utils/utilities.dart';
import 'package:skype/widgets/appbar.dart';
import 'package:skype/widgets/cached_image.dart';
import 'package:skype/widgets/customTile.dart';
import 'package:skype/resources/firebase_repository.dart';

class ChatScreen extends StatefulWidget {
  final User receiver;
  ChatScreen({this.receiver});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textFieldController = TextEditingController();
  ScrollController _listScrollController = ScrollController();
  FirebaseRepository _repository = FirebaseRepository();
  FocusNode textFieldFocus = FocusNode();
  ImageUploadProvider _imageUploadProvider;
  User sender;
  bool isWriting = false;
  bool showEmojiPicker = false;
  String _currentUserId;

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((user) {
      _currentUserId = user.uid;
      setState(() {
        sender = User(
          uid: user.uid,
          name: user.displayName,
          profilePhoto: user.photoUrl,
        );
      });
    });
  }

  showKeyboard() => textFieldFocus.requestFocus();

  hideKeyboard() => textFieldFocus.unfocus();

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      body: Column(
        children: <Widget>[
          Flexible(
            child: messageList(),
          ),
          _imageUploadProvider.getViewState == ViewState.LOADING
              ? Container(
                  margin: EdgeInsets.only(right: 15.0),
                  alignment: Alignment.centerRight,
                  child: CircularProgressIndicator(),
                )
              : Container(),
          chatControls(),
          showEmojiPicker ? Container(child: emojiContainer()) : Container(),
        ],
      ),
    );
  }

  emojiContainer() {
    return EmojiPicker(
      bgColor: UniversalVariables.separatorColor,
      indicatorColor: UniversalVariables.blueColor,
      rows: 3,
      columns: 7,
      onEmojiSelected: (emoji, category) {
        setState(() {
          isWriting = true;
        });
        textFieldController.text = textFieldController.text + emoji.emoji;
      },
      numRecommended: 56,
      recommendKeywords: [
        "beaming face with smiling eyes",
        "face with tears of joy",
        "rolling on the floor laughing",
        "grinning face",
        "grinning face with big eyes",
        "grinning face with smiling eyes",
        "Grinning Squinting Face",
        "Grinning Face with Sweat",
        "Slightly Smiling Face",
        "Winking Face",
        "Face with Tongue",
        "Zipper-Mouth Face",
        "Unamused Face",
        "Smirking Face",
        "Face Without Mouth",
        "Expressionless Face",
        "Face with Raised Eyebrow",
        "Thinking Face",
        "Shushing Face",
        "Sleepy Face",
        "Drooling Face",
        "Face Vomiting",
        "Nauseated Face",
        "Cold Face",
        "Hot Face",
        "Woozy Face",
        "Dizzy Face",
        "Exploding Head",
        "Partying Head",
        "Confused Face",
        "Face with Open Mouth",
        "thumbs up",
        "thumbs down",
        "Waving Hand",
        "Raised Back of Hand",
        "Hand with Fingers Splayed",
        "Raised Hand",
        "OK hand",
        "Victory Hand",
        "Crossed Fingers",
        "Love-You Gesture",
        "Call Me Hand",
        "Backhand Index Pointing Left",
        "Backhand Index Pointing Right",
        "Backhand Index Pointing Up",
        "Backhand Index Pointing Down",
        "Middle Finger",
        "Raised Fist",
        "Clapping Hands",
        "Raising Hands",
        "Open Hands",
        "Handshake",
        "Palms Up Together",
        "Folded Hands",
        "Man Raising Hand",
        "Man Tipping Hand",
        "Woman Tipping Hand",
        "Woman Raising Hand",
        "Person Bowing",
        "Man Shrugging",
        "Woman Shrugging",
        "Trophy",
        "Direct Hit",
      ],
    );
  }

  Widget messageList() {
    return StreamBuilder(
        stream: Firestore.instance
            .collection(MESSAGES_COLLECTION)
            .document(_currentUserId)
            .collection(widget.receiver.uid)
            .orderBy(TIMESTAMP_FIELD, descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }

          // whenever there is a change in the  UI we
          // scroll to bottom of the screen....
          // SchedulerBinding.instance.addPostFrameCallback((_) {
          //   _listScrollController.animateTo(
          //     _listScrollController.position.minScrollExtent,
          //     duration: Duration(milliseconds: 250),
          //     curve: Curves.easeOut,
          //   );
          // });

          return ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return chatMessageItem(snapshot.data.documents[index]);
            },
            controller: _listScrollController,
            reverse: true,
          );
        });
  }

  Widget senderLayout(Message message) {
    Radius messageRadius = Radius.circular(10);

    return Container(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(top: 4),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
        decoration: BoxDecoration(
          color: UniversalVariables.senderColor,
          //gradient: UniversalVariables.fabGradient,
          borderRadius: BorderRadius.only(
            topLeft: messageRadius,
            topRight: messageRadius,
            bottomLeft: messageRadius,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: getMessage(message),
        ),
      ),
    );
  }

  Widget receiverLayout(Message message) {
    Radius messageRadius = Radius.circular(10.0);
    return Container(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(top: 12.0),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
        decoration: BoxDecoration(
          color: UniversalVariables.receiverColor,
          borderRadius: BorderRadius.only(
            topRight: messageRadius,
            bottomRight: messageRadius,
            bottomLeft: messageRadius,
          ),
        ),
        child: Padding(padding: EdgeInsets.all(10.0), child: getMessage(message)),
      ),
    );
  }

  getMessage(Message message) {
    return message.messageType != MESSAGE_TYPE_IMAGE
        ? Text(
            message.message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          )
        : message.photoUrl != null
            ? CachedImage(
                message.photoUrl,
                height: 250.0,
                width: 250.0,
                radius: 10.0,
              )
            : Text("Invalid URL");
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    Message _message = Message.fromMap(snapshot.data);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      child: Container(
        child: Container(
          alignment: _message.senderId == _currentUserId ? Alignment.centerRight : Alignment.centerLeft,
          child: _message.senderId == _currentUserId ? senderLayout(_message) : receiverLayout(_message),
        ),
      ),
    );
  }

  Widget chatControls() {
    setWritingTo(bool value) {
      setState(() {
        isWriting = value;
      });
    }

    pickImage({@required ImageSource source}) async {
      File selectedImage = await Utils.pickImage(source: source);
      _repository.uploadImage(
        image: selectedImage,
        senderId: _currentUserId,
        receiverId: widget.receiver.uid,
        imageUploadProvider: _imageUploadProvider,
      );
    }

    addMediaModal(context) {
      showModalBottomSheet(
          context: context,
          elevation: 0,
          backgroundColor: UniversalVariables.blackColor,
          builder: (context) {
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                    children: <Widget>[
                      FlatButton(
                        child: Icon(Icons.close),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Content and Tools",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    children: <Widget>[
                      ModalTile(
                          title: "Media",
                          subTitle: "Share Photos and Videos",
                          icon: Icons.image_rounded,
                          onTap: () => pickImage(source: ImageSource.gallery)),
                      ModalTile(
                        title: "File",
                        subTitle: "Share Files",
                        icon: Icons.tab_rounded,
                      ),
                      ModalTile(
                        title: "Contact",
                        subTitle: "Share Contacts",
                        icon: Icons.contacts_rounded,
                      ),
                      ModalTile(
                        title: "Location",
                        subTitle: "Share your Location",
                        icon: Icons.add_location_rounded,
                      ),
                      ModalTile(
                        title: "Schedule Call",
                        subTitle: "Arrange a skype call and get reminders",
                        icon: Icons.schedule_rounded,
                      ),
                      ModalTile(
                        title: "Create Poll",
                        subTitle: "Share Polls",
                        icon: Icons.poll_rounded,
                      ),
                    ],
                  ),
                ),
              ],
            );
          });
    }

    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => addMediaModal(context),
            child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                gradient: UniversalVariables.fabGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add),
            ),
          ),
          SizedBox(width: 5.0),
          Expanded(
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                TextField(
                  controller: textFieldController,
                  focusNode: textFieldFocus,
                  style: TextStyle(color: Colors.white),
                  onTap: () {
                    return hideEmojiContainer();
                  },
                  onChanged: (value) {
                    (value.length > 0 && value.trim() != "") ? setWritingTo(true) : setWritingTo(false);
                  },
                  decoration: InputDecoration(
                    hintText: "Type a message",
                    hintStyle: TextStyle(color: UniversalVariables.greyColor),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(const Radius.circular(50.0)),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                    filled: true,
                    fillColor: UniversalVariables.separatorColor,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.face, color: Colors.white),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    if (!showEmojiPicker) {
                      hideKeyboard();
                      showEmojiContainer();
                    } else {
                      showKeyboard();
                      hideEmojiContainer();
                    }
                  },
                ),
              ],
            ),
          ),
          isWriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Icon(Icons.mic),
                ),
          isWriting
              ? Container()
              : GestureDetector(
                  child: Icon(Icons.camera_alt),
                  onTap: () => pickImage(source: ImageSource.camera),
                ),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(left: 10.0),
                  decoration: BoxDecoration(
                    gradient: UniversalVariables.fabGradient,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 15.0,
                    ),
                    onPressed: () => sendMessage(),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  sendMessage() {
    var text = textFieldController.text; //gets the latest message in TextField.
    Message _message = Message(
      message: text,
      senderId: sender.uid,
      receiverId: widget.receiver.uid,
      timestamp: Timestamp.now(),
      messageType: 'text',
    );

    setState(() {
      isWriting = false;
    });
    textFieldController.text = "";
    _repository.addMessageToDb(_message, sender, widget.receiver);
  }

  CustomAppBar customAppBar(context) {
    return CustomAppBar(
      title: Text(widget.receiver.name),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.video_call),
          onPressed: () {
            CallUtils.dial(from: sender, to: widget.receiver, context: context);
          },
        ),
        IconButton(
          icon: Icon(Icons.phone),
          onPressed: () {},
        ),
      ],
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
    );
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final Function onTap;

  ModalTile({
    @required this.title,
    @required this.subTitle,
    @required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: CustomTile(
        onTap: onTap,
        mini: false,
        leading: Container(
          margin: EdgeInsets.only(right: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: UniversalVariables.receiverColor,
          ),
          padding: EdgeInsets.all(10.0),
          child: Icon(
            icon,
            color: UniversalVariables.greyColor,
            size: 38.0,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        subtitle: Text(
          subTitle,
          style: TextStyle(
            color: UniversalVariables.greyColor,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }
}
