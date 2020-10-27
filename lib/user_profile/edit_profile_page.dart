import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  final _userProfileFormKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _userDescriptionController = TextEditingController();

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  @override
  void dispose() {
    widget._usernameController.dispose();
    widget._userDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          //TODO: Replace with user profile info
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //TODO: Get photo from ProfilePhoto class
              ProfilePhoto(),
              SizedBox(
                height: 15.0,
              ),
              ProfileInfoTextForm(
                widget._userProfileFormKey,
                widget._usernameController,
                widget._userDescriptionController,
              ),
              SizedBox(
                height: 15.0,
              ),
              profileEditButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileEditButton() {
    return RaisedButton(
      child: Text('EDIT'),
      //TODO: Send new values to the server
      onPressed: () {/* ... */},
    );
  }
}


class ProfilePhoto extends StatefulWidget {
  @override
  _ProfilePhotoState createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<ProfilePhoto> {
  File _image;
  final picker = ImagePicker();

  void getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: _image == null
          ? NetworkImage('https://w1.pngwing.com/pngs/743/500/png-transparent-circle-silhouette-logo-user-user-profile-green-facial-expression-nose-cartoon.png')
          : Image.file(_image).image,
      radius: 150.0,
      child: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          child: Icon(Icons.add_a_photo),
          onPressed: getImage,
        ),
      ),
    );
  }
}



class ProfileInfoTextForm extends StatefulWidget {
  final _userProfileFormKey;
  final _usernameController;
  final _userDescriptionController;

  ProfileInfoTextForm(
      this._userProfileFormKey,
      this._usernameController,
      this._userDescriptionController);

  @override
  _ProfileInfoTextFormState createState() => _ProfileInfoTextFormState();
}

class _ProfileInfoTextFormState extends State<ProfileInfoTextForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._userProfileFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: widget._usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              hintText: 'Enter your new username',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "Exeption";
              }
              return null;
            },
          ),
          TextFormField(
            controller: widget._userDescriptionController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'Profile Description',
              hintText: 'Write a short description about yourself',
              prefixIcon: Icon(Icons.description_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
