import 'package:flutter/material.dart';
import 'package:skype/models/contact.dart';
import 'package:skype/utils/universal_variable.dart';
import 'package:skype/widgets/customTile.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  ContactView(this.contact);

  @override
  Widget build(BuildContext context) {
    return CustomTile(
      mini: false,
      onTap: () {},
      title: Text(
        "Anonymous",
        style:
            TextStyle(color: Colors.white, fontFamily: "Arial", fontSize: 19.0),
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
                  border: Border.all(
                      color: UniversalVariables.blackColor, width: 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
