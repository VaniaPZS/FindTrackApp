import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica1/auth/bloc/auth_bloc.dart';
import 'package:practica1/favorites/favorites_page.dart';

import 'bloc/favorite_bloc.dart';

class OptionsButton extends StatelessWidget {
  const OptionsButton(
      {super.key, required this.selectedIcon, required this.text, required this.option});
  final Icon selectedIcon;
  final String text;
  final String option;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: IconButton(
            onPressed: () {
              
              if(option == 'Favoritos'){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FavoritePage()));
              }else if(option == 'SignOut'){
                signOutAlertDialog(context);
              }
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


signOutAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text(
      "No, cancelar",
      style: TextStyle(
          fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: Text(
      "Si, salir",
      style: TextStyle(
          fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    onPressed: () {
      BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Cerrar Sesión"),
    content: Text("¿Está seguro de que quiere cerrar sesión?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
