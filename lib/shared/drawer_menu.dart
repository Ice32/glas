import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: buildMenuItems(context),
      ),
    );
  }

  List<Widget> buildMenuItems(BuildContext context) {
    final List<String> items = [
      "Dictionary",
      "Imports",
    ];

    final List<Widget> widgets = [];
    widgets.add(const DrawerHeader(
      decoration: BoxDecoration(color: Colors.blue),
      child: Text(
        "Glas",
        style: TextStyle(color: Colors.white, fontSize: 28),
      ),
    ));

    for (var element in items) {
      String screen = "/dictionary";
      widgets.add(ListTile(
        title: Text(
          element,
          style: const TextStyle(fontSize: 18),
        ),
        onTap: () {
          switch (element) {
            case "Dictionary":
              screen = "/dictionary";
              break;
            case "Imports":
              screen = "/imports";
              break;
          }
          var navigator = Navigator.of(context);

          bool isNewRouteSameAsCurrent = false;

          Navigator.popUntil(context, (route) {
            if (route.settings.name == screen) {
              isNewRouteSameAsCurrent = true;
            }
            return true;
          });
          navigator.pop();
          if (!isNewRouteSameAsCurrent) {
            navigator.pushNamed(screen);
          }
        },
      ));
    }
    return widgets;
  }
}
