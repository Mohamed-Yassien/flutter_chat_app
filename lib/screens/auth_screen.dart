import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoading = false;
  final auth = FirebaseAuth.instance;

  void _submitAuth(
    String userEmail,
    String password,
    String userName,
    File image,
    bool isLogin,
    BuildContext context,
  ) async {
    AuthResult authResult;
    try {
      setState(() {
        isLoading = true;
      });
      if (isLogin) {
        authResult = await auth.signInWithEmailAndPassword(
            email: userEmail, password: password);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: userEmail, password: password);

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(authResult.user.uid + '.jpg');
        await ref.putFile(image).onComplete;

        final url = await ref.getDownloadURL();

        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData(
          {
            'username': userName,
            'email': userEmail,
            'image_url': url,
          },
        );
      }
    } on PlatformException catch (error) {
      var message = 'an error here , please check your info';
      if (error.message != null) {
        message = error.message;
      }
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          message,
        ),
        backgroundColor: Theme.of(context).errorColor,
      ));
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuth, isLoading),
    );
  }
}
