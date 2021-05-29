import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype/provider/user_provider.dart';
import 'package:skype/utils/universal_variable.dart';
import 'package:skype/utils/utilities.dart';
import 'package:skype/widgets/user_details_container.dart';

class UserCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (context) => UserDetailContainer(),
        backgroundColor: UniversalVariables.blackColor,
        isScrollControlled: true,
      ),
      child: Container(
        height: 40.0,
        width: 40.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0), color: UniversalVariables.separatorColor),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                Utils.getInitials(userProvider.getUser.name) ?? "NA",
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
      ),
    );
  }
}
