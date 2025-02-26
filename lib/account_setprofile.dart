import 'package:diory_project/homepage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

XFile? image;
final FirebaseAuth userInfo = FirebaseAuth.instance;

class AccountSetProfile extends StatelessWidget {
  const AccountSetProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('profile setting'),
          leading: Builder(
              builder: (context) => IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(width: 10)
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [ProfileSetting()]),
        ));
  }
}

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({super.key});

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  final TextEditingController _nicknameCtrl = TextEditingController();
  String alias = '';
  //XFile? image;
  final ImagePicker picker = ImagePicker();
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    setState(() {
      image = img;
    });
    saveProfile();
  }

  Future saveProfile() async {
    if(image != null) {
      final userImageRef = FirebaseStorage.instance.ref("/images/userProfiles/${userInfo.currentUser!.uid}");

      await userImageRef.putFile(File(image!.path));

      final url = await userImageRef.getDownloadURL();

      FirebaseFirestore.instance.collection('Users').doc(userInfo.currentUser!.uid).update({
        "profileImg" : url,
        "username" : _nicknameCtrl.text
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          Material(
            child: GestureDetector(
              child: image != null
                  ? Container(
                      width: MediaQuery.of(context).size.width * 0.33,
                      height: MediaQuery.of(context).size.width * 0.33,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: image != null
                            ? DecorationImage(
                                image: FileImage(File(image!.path)),
                                fit: BoxFit.cover)
                            : null,
                      ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width * 0.33,
                      height: MediaQuery.of(context).size.width * 0.33,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.2, color: Colors.black),
                        shape: BoxShape.circle,
                        color: const Color(0xffdfdada),
                      ),
                      child: const Icon(
                        Icons.account_circle,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
              onTap: () {
                getImage(ImageSource.gallery);
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(children: [
            const Expanded(flex: 1, child: SizedBox()),
            const Text('name:\t'),
            Expanded(
                flex: 1,
                child: TextField(
                  controller: _nicknameCtrl,
                  maxLength: 18,
                  maxLines: 1,
                  style: TextStyle(fontSize: 18),
                  onChanged: (value) {
                    alias = value;
                  },
                )),
            const Expanded(flex: 1, child: SizedBox()),
          ]),
          const SizedBox(height: 20),
          Container(
            //alignment: MainAxisAlignment.center,
              height: 70,
              width: 120,
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  primary: Colors.yellow[600],
                ),
                child: const Text('Save'),
                onPressed: () {
                  saveProfile();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MyHomePage()),
                  );
                },
              ))
        ]);
  }
}
