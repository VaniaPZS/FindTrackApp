import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica1/favorites/bloc/music_bloc.dart';

class PrincipalButton extends StatelessWidget {

  final bool animateBool;
  PrincipalButton({Key? key, required this.animateBool}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
      glowColor: Theme.of(context).colorScheme.secondary,
      endRadius: 100,
      duration: Duration(milliseconds: 2000),
      repeat: true,
      animate: animateBool,
      showTwoGlows: true,
      repeatPauseDuration: Duration(milliseconds: 50),
      child: ElevatedButton(
        onPressed: () {
          BlocProvider.of<MusicBloc>(context).add(GetMusicEvent());
        },
        child: Icon(
          Icons.music_note,
          size: 90,
        ),
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).colorScheme.secondary,
          shape: CircleBorder(),
          fixedSize: Size(120, 120),
        ),
      ),
    );
  }
}
