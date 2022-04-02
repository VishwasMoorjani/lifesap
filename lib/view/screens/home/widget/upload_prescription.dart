import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_grocery/view/base/custom_snackbar.dart';
import 'package:flutter_grocery/view/screens/auth/widget/loading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class UploadPhoto {
  FirebaseAuth auth = FirebaseAuth.instance;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  checkUser() {
    User user = auth.currentUser;
    return user;
  }

  Future pickImage(BuildContext context) async {
    ImagePicker picker = ImagePicker();
    File file;
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(title: Text("Camera/Gallery"), children: <Widget>[
            SimpleDialogOption(
              onPressed: () async {
                file = File(
                    (await picker.getImage(source: ImageSource.gallery)).path);
                Navigator.pop(context);
              },
              child: const Text('Pick From Gallery'),
            ),
            SimpleDialogOption(
              onPressed: () async {
                file = File(
                    (await picker.getImage(source: ImageSource.camera)).path);
                Navigator.pop(context);
              },
              child: const Text('Take A New Picture'),
            ),
          ]);
        });
    await sendEmail(file, context);
  }

  Future uploadPhoto(File file, String id, BuildContext context) async {
    firebase_storage.Reference ref = storage.ref('Prescription/$id');
    try {
      await ref.putFile(file).then((p0) {
        showCustomSnackBar('Uploaded Successfully', context);
        return true;
      });
    } on FirebaseException catch (e) {
      showCustomSnackBar(e.message, context);
      log(e.message);
      return false;
    }
  }

  Future sendEmail(File _image, BuildContext context) async {
    GoogleSignIn _googleSignIn =
        GoogleSignIn(scopes: ['http://mail.google.com/']);
    // log('sending');
    GoogleSignInAccount user;
    await _googleSignIn.signOut();
    // log('sending');
    LoadingIndicatorDialog().show(context, 'Please Wait');
    if (await _googleSignIn.isSignedIn()) {
      // log('sending');
      LoadingIndicatorDialog().dismiss();
      user = _googleSignIn.currentUser;
    } else {
      LoadingIndicatorDialog().dismiss();
      // log('sending1');
      user = await _googleSignIn.signIn();
      // log(user.toString());
    }
    // final user = await GoogleAuthApi().signIn();
    if (user == null) {
      // log('return');
      return;
    }
    final email = user.email;
    final id = user.id;
    log(id);
    LoadingIndicatorDialog().show(context, 'Uploading Image');
    bool isUploaded = await uploadPhoto(_image, id, context);
    LoadingIndicatorDialog().dismiss();
    if (isUploaded == false) {
      return;
    }
    log(email);
    GoogleSignInAuthentication auth = await user.authentication;
    final accessToken = auth.accessToken;
    // (await _googleSignIn.currentUser.authentication).accessToken;
    // log(accessToken);
    SmtpServer smtpServer =
        gmailSaslXoauth2(email.toString(), accessToken.toString());

    // log(smtpServer.username.toString());
    Message message = Message()
      ..from = Address(email.toString(), user.displayName)
      ..recipients = ['tillugurjar0@gmail.com']
      ..subject = 'Testing'
      ..text = 'This is test email'
      ..attachments.add(FileAttachment(_image));

    // ..attachments = [];

    try {
      LoadingIndicatorDialog().show(context, 'Sending Mail');
      await send(message, smtpServer);
      LoadingIndicatorDialog().dismiss();
    } on MailerException catch (e) {
      log(e.toString());
      showCustomSnackBar(e.message, context);
    }
  }
}
