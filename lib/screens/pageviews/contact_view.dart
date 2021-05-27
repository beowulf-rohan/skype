import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype/models/contact.dart';
import 'package:skype/models/user.dart';
import 'package:skype/provider/user_provider.dart';
import 'package:skype/resources/auth_methods.dart';
import 'package:skype/resources/chat_methods.dart';
import 'package:skype/screens/chatscreens/chat_screens.dart';
import 'package:skype/utils/universal_variable.dart';
import 'package:skype/widgets/cached_image.dart';
import 'package:skype/widgets/customTile.dart';
import 'package:skype/widgets/last_message_container.dart';
import 'package:skype/widgets/online_dot_indicator.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final AuthMethods _authMethods = AuthMethods();

  ContactView(this.contact);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _authMethods.getUserById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data;
          return ViewLayout(contact: user);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final User contact;
  final ChatMethods _chatMethods = ChatMethods();

  ViewLayout({@required this.contact});

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return CustomTile(
      mini: false,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            receiver: contact,
          ),
        ),
      ),
      title: Text(
        contact?.name ?? "..",
        style: TextStyle(color: Colors.white, fontFamily: "Arial", fontSize: 19.0),
      ),
      subtitle: LastMessageContainer(
        stream: _chatMethods.fetchLastMessageBetween(
          senderId: userProvider.getUser.uid,
          receiverId: contact.uid,
        ),
      ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60.0, maxWidth: 60.0),
        child: Stack(
          children: <Widget>[
            CachedImage(
              contact.profilePhoto,
              isRound: true,
              radius: 80.0,
            ),
            OnlineDorIndicator(uid: contact.uid),
          ],
        ),
      ),
    );
  }
}
