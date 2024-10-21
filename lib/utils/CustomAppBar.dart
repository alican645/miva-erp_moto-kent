import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
        IconButton(onPressed: () {}, icon: Icon(Icons.star)),
        IconButton(onPressed: () {}, icon: Icon(Icons.message)),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.0);
}
