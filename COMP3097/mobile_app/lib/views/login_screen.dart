import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/database/models.dart';
import 'package:mobile_app/database/tables.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/services/todo_service.dart';
import 'package:mobile_app/services/user_services.dart';
import 'package:mobile_app/views/menu_screen.dart';
import 'package:provider/provider.dart';
import '../api_service.dart';
import '../models/user_model.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:mobile_app/database/user_database.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    database.getAllProducts();
    super.initState();
  }

  Future<String?> getUser(String data) async {
    String result = "ok";
    try {
      await UserDatabase.instance.getUser(data);
    } catch (e) {
      result = e.toString();
    }
    return result;
  }

  Future<String?> _authLoginUser(BuildContext context, LoginData data) async {
    String? result = null;
    await Provider.of<UserService>(context, listen: false)
        .userLogin(data.name, data.password)
        .then((value) => {
              if (value != "ok") // username or password incorrect
                {
                  result = "Username or password incorrect"
                  // showDialog<String>(
                  //     context: context,
                  //     builder: (BuildContext context) => DialogueField(
                  //           alert: "Oops",
                  //           content: "Username or password incorrect",
                  //           onPressed: () {
                  //             // Navigator.pop(context);
                  //           },
                  //           btnText: 'ok',
                  //         ))
                }
              else
                {
                  Provider.of<UserService>(context, listen: false)
                      .getUser(data.name)
                      .then((value) => {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (contex) =>
                                    SideMenu(username: data.name)))
                          })
                }
            });

    Item item = Item(item: "item", price: "price");

    // Provider.of<TodoService>(context, listen: false).test();

    return result;
  }

  Future<String?> _authSignupUser(BuildContext context, SignupData data) async {
    Provider.of<TodoService>(context, listen: false).test();
    String? result = null;
    UserModel newUser = UserModel(
        password: data.password.toString(), username: data.name.toString());
    try {
      await Provider.of<UserService>(context, listen: false)
          .userExists(newUser.username)
          .then((value) => {
                if (value != "ok") // if user does not exist, then create user
                  {
                    // print("_authSignupUser - does not exist (SUCCESS)"),
                    Provider.of<UserService>(context, listen: false)
                        .createUser(newUser)
                  }
                else
                  {
                    // print("_authSignupUser - exist (ERROR)"),
                    result = "Username already in use"
                  }
              });
    } catch (e) {
      // print("Error during user signup");
      return "Whoops, something went wrong";
    }
    // print("result: ${result}");
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    // var appState = context.watch<UserService>();

    return FlutterLogin(
      title: 'ShopU',
      key: formKey,
      onLogin: (LoginData data) => _authLoginUser(context, data),
      onSignup: (SignupData data) => _authSignupUser(context, data),
      // onSubmitAnimationCompleted: () {
      //   Navigator.of(context).pushReplacement(MaterialPageRoute(
      //     builder: (context) => SideMenu(
      //       username: appState.currentUser.username,
      //     ),
      //   ));
      // },
      onRecoverPassword: (_) => Future(() => getUser("username")),
      userType: LoginUserType.name,
      userValidator: (value) {
        if (value == null || value.isEmpty) {
          return "Username is empty";
        }
        return null;
      },
      messages: LoginMessages(
        signUpSuccess: "Your account is now registered!",
      ),
      // additionalSignupFields: [
      //   UserFormField(
      //       keyName: 'firstname',
      //       displayName: 'First Name',
      //       fieldValidator: (value) {
      //         print(value);
      //       }),
      //   UserFormField(
      //       keyName: 'lastname',
      //       displayName: 'Last Name',
      //       fieldValidator: (value) {
      //         print(value);
      //       }),
      //   UserFormField(
      //       keyName: 'email',
      //       userType: LoginUserType.email,
      //       fieldValidator: (value) {
      //         print(value);
      //       })
      // ],
      scrollable: true,
    );

    //return Form(
    //   key: formKey,
    //   child: Column(
    //     children: [
    //       Text('Sign In'),
    //       AppFormFields(
    //           controller: usernameController,
    //           validatorText: "Please enter username",
    //           hintText: "Enter username"),
    //       AppFormFields(
    //         controller: passwordController,
    //         validatorText: "Please enter password",
    //         hintText: "Enter password",
    //         obscureText: true,
    //       ),
    //       ElevatedClassButton(
    //           childText: "Submit",
    //           onPressed: () {
    //             if (formKey.currentState!.validate()) {
    // var isLogged = appState
    //     .userLogin(
    //         usernameController.text, passwordController.text)
    //     .then((value) => {
    //  if (value == 'ok')
    //     {
    //       appState
    //           .getUser(usernameController.text)
    //           .then((value) => {
    //                 Navigator.of(context).push(
    //                     MaterialPageRoute(
    //                         builder: (contex) => SideMenu(
    //                             username:
    //                                 usernameController
    //                                     .text)))
    //               })
    //     }
    //           else
    //             {
    //               showDialog<String>(
    //                   context: context,
    //                   builder: (BuildContext context) =>
    //                       DialogueField(
    //                         alert: "Oops",
    //                         content:
    //                             "Username or password incorrect",
    //                         onPressed: () {
    //                           Navigator.pop(context);
    //                         },
    //                         btnText: 'ok',
    //                       ))
    //             }
    //         });
    //             }
    //           }),
    //       ElevatedClassButton(
    //           childText: "Register",
    //           onPressed: () {
    //             Navigator.of(context).push(
    //                 MaterialPageRoute(builder: (context) => RegisterPage()));
    //           })
    //     ],
    //   ),
    // );
  }
}
