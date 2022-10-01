import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica1/favorites/bloc/music_bloc.dart';
import 'package:practica1/favorites/options_button.dart';
import 'package:practica1/favorites/song_page.dart';
import 'package:practica1/favorites/principal_button.dart';

class HomePage extends StatelessWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Ready when you are'),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: BlocConsumer<MusicBloc, MusicState>(
            listener: (context, state) {
              if (state is GetMusicSuccessState) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SongPage(
                              songName: state.cancion['result']['title'],
                              albumName: state.cancion['result']['album'],
                              artistName: state.cancion['result']['artist'],
                              songYear: state.cancion['result']['release_date'],
                              urlApple: state.cancion['result']['apple_music']
                                  ['url'],
                              urlSpotify: state.cancion['result']['spotify']
                                  ['external_urls']['spotify'],
                              urlDeezer: state.cancion['result']['song_link'],
                              urlImage: state.cancion['result']['spotify']
                                  ['album']['images'][0]['url'],
                            )));
              } else if (state is GetMusicErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No se encontro la cancion')));
              }
            },
            builder: (context, state) {
              if(state is GetMusicLoadState){
              return homePageMenu(true, context, 'Escuchando...');
              }
              // String textListening = context.watch<MusicBloc>().listeningText;
              return homePageMenu(false, context, 'Toque para reconocer!');
              
            },
          ),
        ));
  }

  Column homePageMenu(bool animateBool, BuildContext context, String listeningText) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(listeningText, style: TextStyle(fontSize: 20))
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [PrincipalButton(animateBool: animateBool)],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OptionsButton(
                selectedIcon: Icon(Icons.favorite),
                text: 'Ver Favoritos',
              )
            ],
          ),
        )
      ],
    );
  }
}
