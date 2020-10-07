import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flexible_toast/flutter_flexible_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iter_tour_guide/tour_guide_pac/Services/auth_Service.dart';
import 'package:iter_tour_guide/tour_guide_pac/Widgets/lable_text_field.dart';

class EditProfile extends StatefulWidget {
  final String name;
  final String email;
  final String isactive;
  final String documentId;

  const EditProfile({
    Key key,
    this.name,
    this.email,
    this.isactive,
    this.documentId,
  }) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _newname = new TextEditingController();
  TextEditingController _newemail = new TextEditingController();

  String isActive;
  bool va = true;
  File _image;
  String url;
  final picker = ImagePicker();
  AuthMethods authMethods = AuthMethods();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    FlutterFlexibleToast.showToast(message: "Please wait untill the picture uploads");
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('profile_images/${DateTime.now().toString()}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete.whenComplete(
      () => storageReference.getDownloadURL().then((fileURL) {
        setState(() {
          url = fileURL;
        });
      }),
    );
    print('File Uploaded');

    print(url);
    updateUserDetails();
  }

  void updateUserDetails() {
    print("started");
    print(url);
    Map<String, String> data = {
      "email": _newemail.text,
      "name": _newname.text,
      "picture": url,
      'availability_status': isActive
    };
    authMethods.updateUser(widget.documentId, data);
    Navigator.pop(context);
    //  authMethods.updateUser(widget.documentId, data1);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _newname.text = widget.name;
      _newemail.text = widget.email;
      isActive = widget.isactive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 40),
        _profilepicture(),
        Spacer(),
        SizedBox(height: 20),
        _detailsSection(),
        SizedBox(height: 20),
        _isActive(),
        Spacer(),
        _submitButton(),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _profilepicture() {
    return GestureDetector(
      onTap: () {
        getImage();
      },
      child: CircleAvatar(
        backgroundImage: _image != null
            ? FileImage(_image)
            : NetworkImage(
                "https://www.kindpng.com/picc/m/252-2524695_dummy-profile-image-jpg-hd-png-download.png"),
        radius: 60,
      ),
    );
  }

  Widget _detailsSection() {
    return Padding(
      padding: EdgeInsets.only(left: 32, right: 32),
      child: Column(
        children: <Widget>[
          LabelTextField(
            controller: _newname,
            borderColor: Colors.blue,
            hintText: "New Name",
          ),
          SizedBox(height: 20),
          LabelTextField(
            controller: _newemail,
            borderColor: Colors.blue,
            hintText: "New Email",
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _isActive() {
    return Padding(
      padding: EdgeInsets.only(left: 32, right: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("Availability :"),
          Switch(
            value: va,
            onChanged: (bool v) {
              setState(() {
                va = v;
                print(va);
                va == false ? isActive = "inactive" : isActive = "active";
                print(isActive);
              });
            },
          )
        ],
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      width: MediaQuery.of(context).size.width - 64,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: RaisedButton(
          child: Text(
            "Submit",
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.teal,
          onPressed: () {
            uploadFile();
          },
        ),
      ),
    );
  }
}
