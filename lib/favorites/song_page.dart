import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:practica1/favorites/bloc/favorite_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class SongPage extends StatelessWidget {
  final String artistName;
  final String songName;
  final String albumName;
  final String songYear;
  final String urlSpotify;
  final String urlDeezer;
  final String urlApple;
  final String urlImage;

  SongPage(
      {Key? key,
      required this.songName,
      required this.albumName,
      required this.artistName,
      required this.songYear,
      required this.urlSpotify,
      required this.urlDeezer,
      required this.urlApple,
      required this.urlImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Here you go!'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                showDialogAddFavorite(context);
              },
              child: Icon(
                Icons.favorite,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.network(urlImage),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    child: Text(
                      songName,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    albumName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    artistName,
                    style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.background),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    songYear,
                    style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.background),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text('Abrir con:'),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: () {
                      final Uri urlSpotifyUri = Uri.parse(urlSpotify);
                      launchUrl(urlSpotifyUri);
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.spotify,
                      size: 30,
                    )),
                IconButton(
                    onPressed: () {
                      final Uri urlDeezerUri = Uri.parse(urlDeezer);
                      launchUrl(urlDeezerUri);
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.podcast,
                      size: 30,
                    )),
                IconButton(
                    onPressed: () {
                      final Uri urlAppleUri = Uri.parse(urlApple);
                      launchUrl(urlAppleUri);
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.apple,
                      size: 30,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> showDialogAddFavorite(context) async {
    Map infoSong = {
      'artistName': artistName,
      'songName': songName,
      'albumName': albumName,
      'urlImage': urlImage,
      'urlApple': urlApple,
      'urlSpotify': urlSpotify,
      'urlDeezer': urlDeezer,
      'songYear': songYear
    };
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('favorites')
                .where('user',
                    isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                .where('songName', isEqualTo: infoSong['songName'])
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              print('hola');
              print(snapshot);

              if (!snapshot.hasData) {
                return AlertDialog(
                  title: const Text('Quitar de favoritos'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: const <Widget>[
                        Text('??Eliminar canci??n de favoritos?'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancelar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Aceptar'),
                      onPressed: () {
                        BlocProvider.of<FavoriteBloc>(context)
                            .add(DeleteFavoriteEvent(infoSong));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Se ha eliminado la canci??n.')));

                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              } else {
                return AlertDialog(
                  title: const Text('Agregar a favoritos'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: const <Widget>[
                        Text('??Agregar canci??n a favoritos?'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancelar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Aceptar'),
                      onPressed: () {
                        BlocProvider.of<FavoriteBloc>(context).add(
                            AddFavoriteEvent(
                                songName,
                                artistName,
                                albumName,
                                urlImage,
                                urlApple,
                                urlSpotify,
                                urlDeezer,
                                songYear));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Se ha agregado la canci??n.')));
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              }
            });
      },
    );
  }
}
