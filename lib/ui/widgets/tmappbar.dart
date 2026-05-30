import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmanager/data/models/userModel.dart';
import 'package:taskmanager/data/services/apicaller.dart';
import 'package:taskmanager/data/utils/urls.dart';
import 'package:taskmanager/ui/controller/auth_controller.dart';
import 'package:taskmanager/ui/screens/update_profile.dart';
import 'package:taskmanager/ui/widgets/snackbar.dart';

class TMAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TMAppBar({super.key});

  @override
  State<TMAppBar> createState() => _TMAppBarState();

  @override
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TMAppBarState extends State<TMAppBar> {
  UserModel? _user;
  String? profilePhotoPath;

  //update the user
  Future<void> _whoisUsingHuh() async {
    final ApiResponse response = await Apicaller.getRequest(
      url: Urls.profileDetailsUrl,
    );

    if (response.isSuccess) {
      final data = response.responseData["data"];

if (data != null && data.isNotEmpty) {
  _user = UserModel.fromJson(data[0]);
  setState(() {});
}
      
      setState(() {});
    } else {
      showSnackBarMessage(context, response.errorMessage.toString());
    }
  }

  //read path from sharedpreferences and show in appbar hehe
  Future<void> _readLoadFoto() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    profilePhotoPath = sharedPreferences.getString("profile_photo");
    //print(profilePhotoPath);
    setState(() {});
  }

  @override
  void initState() {
    _whoisUsingHuh();
    _readLoadFoto();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      title: InkWell(
        onTap: () {
          Navigator.push(
            (context),
            MaterialPageRoute(builder: (context) => UpdateProfile()),
          ).then((_) => {_readLoadFoto()});
        },
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: profilePhotoPath != null
                  ? FileImage(File(profilePhotoPath!))
                  : null,
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_user?.fisrtName ?? ''} ${_user?.lastName ?? ''}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(color: Colors.white),
                ),

                Text(
                  "${_user?.email}",
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),

      actions: [
        IconButton(
          onPressed: () {
            AuthController.clearUserData();
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (predicate) => false,
            );
          },
          style: IconButton.styleFrom(foregroundColor: Colors.white),
          icon: Icon(Icons.logout),
        ),
      ],
    );
  }
}
