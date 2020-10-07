import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flexible_toast/flutter_flexible_toast.dart';
import 'package:iter_tour_guide/tour_guide_pac/Screens/edit_profile.dart';
import 'package:iter_tour_guide/tour_guide_pac/Services/auth_Service.dart';
import 'package:iter_tour_guide/tour_guide_pac/Widgets/titles.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({Key key, this.uid}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String uid;
  String name;
  String language;
  AuthMethods authMethods = AuthMethods();
  bool k;

  QuerySnapshot uinfo;
  Stream comments;

  void getuinfo() async {
    authMethods.getuserInfo(widget.uid).then((value) {
      setState(() {
        uinfo = value;
        print(uinfo.documents[0].data);
      });
    });
  }

  void getcomments() async {
    authMethods.getratings(widget.uid).then((value) {
      setState(() {
        comments = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getuinfo();
    this.getcomments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 100,
        child: Icon(Icons.edit),
        onPressed: () {
          setState(() {
            uinfo != null
                ? name = uinfo.documents[0].data['name']
                : name = "loading";
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditProfile(
                        email: uinfo.documents[0].data['email'],
                        name: name,
                        isactive:
                            uinfo.documents[0].data['availability_status'],
                        documentId: uinfo.documents[0].documentID,
                      )));
        },
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return ListView(
      // crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 32),
        Row(
          children: <Widget>[Spacer(), _circleAvatar(), Spacer()],
        ),
        SizedBox(height: 20),
        _profileDetails(),
        SizedBox(height: 70),
        _packageSection(),
        SizedBox(height: 20),
        _languageSection(),
        SizedBox(height: 20),
        _availabilitySection(),
        _divider(),
        _ratingsList(),
      ],
    );
  }

  Widget _circleAvatar() {
    return uinfo != null && uinfo.documents[0].data['picture'] != null
        ? CircleAvatar(
            backgroundImage: uinfo.documents[0].data['picture'] != null &&
                    uinfo.documents[0].data['picture'] != null
                ? NetworkImage(uinfo.documents[0].data['picture'])
                : NetworkImage(
                    "https://www.kindpng.com/picc/m/252-2524695_dummy-profile-image-jppng-download.png"),
            radius: 70,
          )
        : CircleAvatar(
            radius: 70,
          );
  }

  Widget _profileDetails() {
    return Row(
      children: <Widget>[
        Spacer(),
        Column(
          children: <Widget>[
            uinfo != null
                ? Text(
                    uinfo != null ? uinfo.documents[0].data['name'] : "loading",
                    style: TextStyle(color: Colors.deepPurple, fontSize: 18))
                : Text("loading",
                    style: TextStyle(color: Colors.deepPurple, fontSize: 18)),
            SizedBox(height: 12),
            uinfo != null
                ? Text(uinfo.documents[0].data['email'],
                    style: TextStyle(color: Colors.deepPurple, fontSize: 14))
                : Text("Loading",
                    style: TextStyle(color: Colors.deepPurple, fontSize: 14))
          ],
        ),
        Spacer()
      ],
    );
  }

  Widget _packageSection() {
    return Padding(
      padding: EdgeInsets.only(left: 32, right: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Titles(
            color: Colors.blueAccent,
            fontSize: 16,
            title: "Current package",
          ),
          Container(
            child: Center(
              child: Text("Platinum"),
            ),
            width: 120,
            height: 40,
            color: Color(0xffc0c0c0),
          ),
        ],
      ),
    );
  }

  Widget _languageSection() {
    return Padding(
      padding: EdgeInsets.only(left: 32, right: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Titles(
            color: Colors.blueAccent,
            fontSize: 16,
            title: "Prefered lanuage",
          ),
          uinfo != null
              ? Titles(
                  color: Colors.blueAccent,
                  fontSize: 16,
                  title: uinfo.documents[0].data['language'],
                )
              : Titles(
                  color: Colors.blueAccent, fontSize: 16, title: "Loading"),
        ],
      ),
    );
  }

  Widget _availabilitySection() {
    return Padding(
      padding: EdgeInsets.only(left: 32, right: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Titles(
            color: Colors.blueAccent,
            fontSize: 16,
            title: "Availability",
          ),
          uinfo == null ||
                  uinfo.documents[0].data['availability_status'] == "active"
              ? Switch(
                  value: true,
                  onChanged: (v) {
                    FlutterFlexibleToast.showToast(
                        message: "You can change availability in edit profile",
                        toastLength: Toast.LENGTH_SHORT,
                        fontSize: 14);
                  },
                  activeColor: Colors.green,
                  activeTrackColor: Colors.green,
                )
              : Switch(
                  value: false,
                  onChanged: (v) {
                    FlutterFlexibleToast.showToast(
                        message: "You can change availability in edit profile",
                        toastLength: Toast.LENGTH_SHORT,
                        fontSize: 14);
                  },
                  inactiveThumbColor: Colors.red,
                ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Divider(color: Colors.grey, thickness: 1),
    );
  }

  Widget _ratingsList() {
    return StreamBuilder(
      stream: comments,
      builder: (context, snapshots) {
        return snapshots.data != null
            ? ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: snapshots.data.documents.length,
                itemBuilder: (context, int index) {
                  return Padding(
                    padding: EdgeInsets.only(left: 32, right: 32),
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20),
                          Row(
                            children: <Widget>[
                              Text("Comment :"),
                              Spacer(),
                              Text(snapshots
                                  .data.documents[index].data['comment'])
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: <Widget>[
                              Text("rating"),
                              Spacer(),
                              Text(snapshots
                                  .data.documents[index].data['rating']
                                  .toString())
                            ],
                          ),
                          Divider()
                        ],
                      ),
                    ),
                  );
                },
              )
            : Text("Loading");
      },
    );
  }
}
