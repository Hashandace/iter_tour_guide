import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iter_tour_guide/tour_guide_pac/Services/auth_Service.dart';

class Requests extends StatefulWidget {
  final String uid;

  const Requests({Key key, this.uid}) : super(key: key);
  @override
  _RequestsState createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  AuthMethods authMethods = AuthMethods();

  String uid;
  Stream requests;

  getuid() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      uid = user.uid;
    });
  }

  timestamp_to_date(timestamp) {
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return date.toString();
  }

  updateStatus(id, data) {
    authMethods.confirmRequest(id, data);
  }

  @override
  void initState() {
    super.initState();
    this.getuid();

    authMethods
        .getPendingTripRequests(widget.uid)
        .then((value) {
      setState(() {
        requests = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    return StreamBuilder(
        stream: requests,
        builder: (context, snapshots) {
          return snapshots.data != null
              ? ListView.builder(
                  itemCount: snapshots.data.documents.length,
                  itemBuilder: (context, int index) {
                    return Padding(
                        padding: EdgeInsets.only(left: 16, right: 16, top: 32),
                        child: Container(
                          child: Card(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 60,
                                  color: Colors.red,
                                ),
                                SizedBox(height: 20),
                                Padding(
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("Tourist"),
                                        Text(snapshots.data.documents[index]
                                            .data['tourist_name']),
                                      ],
                                    )),
                                SizedBox(height: 20),
                                Padding(
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("Date"),
                                        // Text(timestamp_to_date(snapshots.data.documents[index].data['date'])),
                                      ],
                                    )),
                                SizedBox(height: 20),
                                Padding(
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("Days"),
                                        Text(snapshots.data.documents[index]
                                            .data['days']),
                                      ],
                                    )),
                                SizedBox(height: 20),
                                Padding(
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("Package"),
                                        Text(snapshots.data.documents[index]
                                            .data['package']),
                                      ],
                                    )),
                                SizedBox(height: 20),
                                Padding(
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("Price"),
                                        Text(snapshots.data.documents[index]
                                            .data['price']),
                                      ],
                                    )),
                                SizedBox(height: 20),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Status :"),
                                    SizedBox(width: 20),
                                    Text(snapshots
                                        .data.documents[index].data['status']),
                                  ],
                                ),
                                SizedBox(height: 20),
                                _acquirebutton(
                                    snapshots.data.documents[index].documentID),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ));
                  })
              : Center(
                  child: Text("No requests"),
                );
        });
  }

  Widget _acquirebutton(id) {
    Map<String, String> data = {
      "status": "confirmed",
      "guide_id": uid,
    };

    return Container(
      width: MediaQuery.of(context).size.width - 64,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: RaisedButton(
          child: Text(
            "Acquire",
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.teal,
          onPressed: () {
            updateStatus(id, data);
          },
        ),
      ),
    );
  }
}
