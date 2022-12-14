import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica1/favorites/song_page.dart';

import 'bloc/favorite_bloc.dart';

class FavoritePage extends StatelessWidget {
  FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos!'),
      ),
      body: FavoriteBuilder(),
    );
    ;
  }
}

class FavoriteBuilder extends StatelessWidget {
  const FavoriteBuilder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var listaDatos = context.watch<FavoriteBloc>().favoriteSongsList;
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('favorites').where('user', isEqualTo: FirebaseAuth.instance.currentUser?.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!.docs;
            return ListView.builder(
                itemCount: snap.length,
                itemBuilder: (BuildContext context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SongPage(
                                    songName: snap[index]['songName'],
                                    albumName: snap[index]['albumName'],
                                    artistName: snap[index]['artistName'],
                                    songYear: snap[index]['songYear'],
                                    urlApple: snap[index]['urlApple'],
                                    urlSpotify: snap[index]['urlSpotify'],
                                    urlDeezer: snap[index]['urlDeezer'],
                                    urlImage: snap[index]['urlImage'],
                                  )));
                    },
                    child: Column(
                      children: [
                        FavoriteSong(
                          songName: snap[index]['songName'],
                          artistName: snap[index]['artistName'],
                          albumName: snap[index]['albumName'],
                          urlImage: snap[index]['urlImage'],
                          songYear: snap[index]['songYear'],
                          urlApple: snap[index]['urlApple'],
                          urlDeezer: snap[index]['urlDeezer'],
                          urlSpotify: snap[index]['urlSpotify'],
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return SizedBox();
          }
        });
  }
}

class FavoriteSong extends StatelessWidget {
  final String artistName;
  final String songName;
  final String albumName;
  final String songYear;
  final String urlSpotify;
  final String urlDeezer;
  final String urlApple;
  final String urlImage;
  const FavoriteSong({
    Key? key,
    required this.songName,
    required this.artistName,
    required this.albumName,
    required this.songYear,
    required this.urlSpotify,
    required this.urlDeezer,
    required this.urlApple,
    required this.urlImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.all(20),
          width: 350,
          height: 350,
          padding: EdgeInsets.all(15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    urlImage,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    color: Color.fromARGB(226, 6, 51, 88),
                    child: Column(
                      children: [
                        Text(
                          songName,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          albumName,
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: 0,
                    left: 10,
                    child: IconButton(
                        onPressed: () {
                          showDeleteDialog(context, infoSong);
                        },
                        icon: Icon(
                          Icons.favorite,
                          color: Colors.purple,
                        ))),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> showDeleteDialog(
      BuildContext context, Map<dynamic, dynamic> infoSong) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
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
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Se ha eliminado la canci??n.')));

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
