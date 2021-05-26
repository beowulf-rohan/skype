import 'package:flutter/material.dart';
import 'package:skype/resources/auth_methods.dart';
import 'package:skype/screens/callscreens/pickup/pickup_layout.dart';
import 'package:skype/utils/universal_variable.dart';
import 'package:skype/utils/utilities.dart';
import 'package:skype/widgets/appbar.dart';
import 'package:skype/widgets/customTile.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}


class _ChatListScreenState extends State<ChatListScreen> {
  String currentUserId;
  String initials;
  final AuthMethods _authMethods = AuthMethods();

  @override
  void initState() {
    super.initState();
    _authMethods.getCurrentUser().then((user) {
      setState(() {
        currentUserId = user.uid;
        initials = Utils.getInitials(user.displayName);
      });
    });
  }

  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      title: UserCircle(initials ?? "NA"),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/search_screen');
          },
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ],
      leading: IconButton(
        icon: Icon(
          Icons.notifications,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
      centerTitle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        appBar: customAppBar(context),
        floatingActionButton: NewChatButton(),
        body: ChatListContainer(currentUserId),
      ),
    );
  }
}

class UserCircle extends StatelessWidget {
  final String text;
  UserCircle(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      width: 40.0,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(50.0), color: UniversalVariables.separatorColor),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: UniversalVariables.lightBlueColor,
                fontSize: 13.0,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 12.0,
              width: 12.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: UniversalVariables.blackColor,
                  width: 2.0,
                ),
                color: UniversalVariables.onlineDotColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NewChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: UniversalVariables.fabGradient,
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Icon(
        Icons.edit,
        color: Colors.white,
        size: 25.0,
      ),
      padding: EdgeInsets.all(15.0),
    );
  }
}

class ChatListContainer extends StatefulWidget {
  final String currentUserId;
  ChatListContainer(this.currentUserId);

  @override
  _ChatListContainerState createState() => _ChatListContainerState();
}

class _ChatListContainerState extends State<ChatListContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: 2,
        itemBuilder: (context, index) {
          return CustomTile(
            mini: false,
            onTap: () {},
            title: Text(
              "Anonymous",
              style: TextStyle(color: Colors.white, fontFamily: "Arial", fontSize: 19.0),
            ),
            subtitle: Text(
              "Hello",
              style: TextStyle(color: UniversalVariables.greyColor, fontSize: 14.0),
            ),
            leading: Container(
              constraints: BoxConstraints(maxHeight: 60.0, maxWidth: 60.0),
              child: Stack(
                children: <Widget>[
                  CircleAvatar(
                    maxRadius: 30.0,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(
                        "https://yt3.ggpht.com/a/AGF-l7_zT8BuWwHTymaQaBptCy7WrsOD72gYGp-puw=s900-c-k-c0xffffffff-no-rj-mo"),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 15.0,
                      width: 15.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: UniversalVariables.onlineDotColor,
                        border: Border.all(color: UniversalVariables.blackColor, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
