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
      "Import",
      "Dictionary",
    ];

    final List<Widget> widgets = [];
    widgets.add(const DrawerHeader(
      child: Text(
        "Glas",
        style: TextStyle(color: Colors.white, fontSize: 28),
      ),
      decoration: BoxDecoration(color: Colors.blue),
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
            case "Import":
              screen = "/import";
              break;
            case "Dictionary":
              screen = "/dictionary";
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
