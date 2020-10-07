import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iter_tour_guide/tour_guide_pac/models/user_model.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(id: user.uid) : null;
  }

  Future signIn(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser firebaseUser = result.user;

      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e);
    }
  }

  Future signUp(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e);
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
    }
  }

  Future signout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  Future uploadUserInfo(usermap) {
    Firestore.instance.collection("user").add(usermap);
  }

  Future getuserInfo(uid) async {
    return await Firestore.instance
        .collection("user")
        .where("uid", isEqualTo: uid)
        .getDocuments()
        .catchError((e) {
      print(e);
    });
  }

  Future getPendingTripRequests(String uid) async {
    return await Firestore.instance
        .collection("trip_request")
        .where("status",isEqualTo:"pending")
        .snapshots();
  }

  Future getConfirmedTripRequests(String uid) async {
    return await Firestore.instance
        .collection("trip_request")
        .where("guide_id", isEqualTo: uid)
        .where("status",isEqualTo:"confirmed")
        .snapshots();
  }

  Future updateUser(String id, data) async {
    return await Firestore.instance
        .collection("user")
        .document(id)
        .updateData(data);
  }

  Future confirmRequest(String id,data) async{
    return await Firestore.instance
    .collection('trip_request')
    .document(id)
    .updateData(data);
  }

  Future getratings(uid) async{
    return await Firestore.instance
    .collection('comments')
    .where('guide_id',isEqualTo:uid)
    .snapshots();
  }

  
}
