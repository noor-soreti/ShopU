import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/src/auth_service.dart';
import 'package:mobile_app/src/user_service.dart';

import '../src/models.dart';
import 'edit_form.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _authService = AuthService();
  final UserService _service = UserService();

  late String email = _authService.currentUser()!.email!;
  late User user;

  @override
  void initState() {
    initUser();
    super.initState();
  }

  Future initUser() async {
    user = await _service.readUserData(email);
    setState(() {
      user.firstname =
          "${user.firstname[0].toUpperCase()}${user.firstname.substring(1)}";
      user.lastname =
          "${user.lastname[0].toUpperCase()}${user.lastname.substring(1)}";
      user.id = _authService.currentUser()!.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(
        height: 55,
      ),
      CircleAvatar(
        backgroundColor: Color.fromARGB(255, 244, 244, 244),
        radius: 70,
        child: Icon(
          Icons.person,
          color: Color(0xffCCCCCC),
          size: 50,
        ),
      ),
      Expanded(
        child: ListView(
          padding: const EdgeInsets.only(top: 80, left: 20, right: 20),
          children: [
            Row(
              children: [
                Text(
                  "Email: ",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  "Full name: ",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                Text(
                  "${user.firstname} ${user.lastname}",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                )
              ],
            ),
            ElevatedButton(
                onPressed: () async => {
                      await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditForm(user: user)))
                          .then((value) => initUser()),
                    },
                child: Text('Edit'))
          ],
        ),
      ),
    ]);
  }
}
