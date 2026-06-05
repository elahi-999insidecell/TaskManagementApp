// ignore_for_file: unused_field, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskmanager/data/services/apicaller.dart';
import 'package:taskmanager/data/utils/urls.dart';
import 'package:taskmanager/ui/controller/auth_controller.dart';
import 'package:taskmanager/ui/utils/screen_background.dart';
import 'package:taskmanager/ui/widgets/photo_picker.dart';
import 'package:taskmanager/ui/widgets/snackbar.dart';
import 'package:taskmanager/ui/widgets/tmappbar.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  bool _isUpdating = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  XFile? _selectedImage;

  Future<void> pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      _selectedImage = image;

      setState(() {});
    }
  }

  //update function to call inside the button
  Future<void> _updatePhoto() async {
    if (_selectedImage != null) {
      await AuthController.saveProfilePhoto(_selectedImage!.path);
    }

    // print(await AuthController.getProfilePhoto());

    
  }

  // get the infos from api
  Future<void> _updateProfilefromApi() async {
    _isUpdating = true;
    setState(() {});

    final ApiResponse response = await Apicaller.postRequest(
      url: Urls.profileUpdateUrl,
      body: {
        "email": _emailController.text.trim(),
        "firstName": _fnameController.text.trim(),
        "lastName": _lnameController.text.trim(),
        "mobile": _phoneController.text.trim(),
        "password": _passController.text.trim(),
      },
    );

    _isUpdating = false;
    setState(() {});

    if (response.isSuccess) {
      Navigator.pop(context, true);
    } else {
      showSnackBarMessage(context, response.errorMessage.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                Text(
                  "Update Profile",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 15),

                //image picker
                Photo_picker(onTap: pickImage, selectedPhoto: _selectedImage),

                SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(hintText: "Email"),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _fnameController,
                  decoration: InputDecoration(hintText: "First Name"),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _lnameController,
                  decoration: InputDecoration(hintText: "Last Name"),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(hintText: "Mobile"),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _passController,
                  decoration: InputDecoration(hintText: "Password"),
                ),
                SizedBox(height: 10),
                FilledButton(
                  onPressed: () async {
                   await  _updatePhoto();
                   await  _updateProfilefromApi();
                  },
                  child: Icon(Icons.arrow_forward_ios_rounded),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
