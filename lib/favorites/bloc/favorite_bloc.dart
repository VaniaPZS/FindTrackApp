import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  List<dynamic> favoriteSongsList = [];
  Map infoSong = {};
  FavoriteBloc() : super(FavoriteInitial()) {
    on<AddFavoriteEvent>(_setFavoriteSong);
    on<DeleteFavoriteEvent>(_setDeleteFavoriteSong);
  }

  Future<dynamic> saveFavoriteSong(
      String songName,
      String artistName,
      String albumName,
      String urlImage,
      String urlApple,
      String urlSpotify,
      String urlDeezer,
      String songYear) async {

    try {

      await FirebaseFirestore.instance.collection('favorites').add({
        'songName': songName,
        'artistName': artistName,
        'albumName': albumName,
        'urlImage': urlImage,
        'urlApple': urlApple,
        'urlSpotify': urlSpotify,
        'urlDeezer': urlDeezer,
        'songYear': songYear,
        'user': FirebaseAuth.instance.currentUser?.uid
      });

      return true;

    } catch (e) {
      print('Error: $e');
    }
  }

  FutureOr<void> _setFavoriteSong(event, emit) async {
    bool favoriteSongResponse = await saveFavoriteSong(
        event.songName,
        event.artistName,
        event.albumName,
        event.urlImage,
        event.urlApple,
        event.urlSpotify,
        event.urlDeezer,
        event.songYear);
    print(favoriteSongResponse);
    if (favoriteSongResponse == true) {
      emit(FavoriteSuccessState());
    } else {
      emit(FavoriteErrorState(error: 'Error'));
    }
  }

  Future<dynamic> deleteFavoriteSong(Map songToDelete) async {
    try {
      // if(favoriteSongsList!.isNotEmpty){

      // for (int i = 0; i < favoriteSongsList.length; i++) {
      //   Map songElement = favoriteSongsList[i];
      //   if (songElement['title'] == favoriteSongsList[i]['title']) {
      //     favoriteSongsList.removeAt(i);
      //   }
      // }
      // // favoriteSongsList
      // //     .removeWhere((item) => item['title'] = songToDelete['title']);
      // print(favoriteSongsList);

      // }
      var deletedSong = await FirebaseFirestore.instance
          .collection('favorites')
          .where('user', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .where('songName', isEqualTo: songToDelete['songName'])
          .get()
          .then((QuerySnapshot) => QuerySnapshot);

      for(var song in deletedSong.docs){
        await song.reference.delete();
      }

      return true;
    } catch (e) {
      print('Error: $e');
    }
  }

  FutureOr<void> _setDeleteFavoriteSong(event, emit) async {
    bool deletedSong = await deleteFavoriteSong(event.songToDelete);
    print(deletedSong);

    if (deletedSong == true) {
      emit(DeleteFavoriteSuccessState());
    } else {
      emit(DeleteFavoriteErrorState(error: 'Error'));
    }
  }
}
