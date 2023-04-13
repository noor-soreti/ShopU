import 'package:flutter/material.dart';
import 'package:mobile_app/views/home_screen.dart';
import 'package:mobile_app/views/list_screen.dart';
import 'package:mobile_app/views/login_screen.dart';
import 'package:mobile_app/views/search_screen.dart';
import 'package:mobile_app/widget/dialogue_field.dart';

class SideMenu extends StatefulWidget {
  SideMenu({super.key, required this.username});
  final String username;
  // final UsersService uServ = UsersService.ensureInitialized();

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // var appState = context.watch<MyAppState>();
    bool showTrailing = true;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = Home();
        break;
      case 1:
        page = MyList();
        break;
      case 2:
        page = Search();
        break;
      case 3:
        page = Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.shopping_basket),
                    label: Text('My List'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.search),
                    label: Text('Search'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Likes'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
                trailing: IconButton(
                    onPressed: () => {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Text("Logout"),
                                    content: Text(
                                        "Are your sure you want to log out?"),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () {
                                            Navigator.popUntil(
                                                context,
                                                (Route<dynamic> route) =>
                                                    route.isFirst);
                                          },
                                          child: Text("Continue")),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Cancel")),
                                    ],
                                  ))
                        },
                    icon: Icon(
                      Icons.exit_to_app,
                    )),
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}
