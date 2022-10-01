import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica1/favorites/favorites_page.dart';

import 'bloc/favorite_bloc.dart';

class OptionsButton extends StatelessWidget {
  const OptionsButton(
      {super.key, required this.selectedIcon, required this.text});
  final Icon selectedIcon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: IconButton(
            onPressed: () {
              
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FavoritePage()));
            },
            color: Theme.of(context).colorScheme.primary,
            icon: selectedIcon,
            tooltip: text,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Text(text),
        )
      ],
    );
  }
}
