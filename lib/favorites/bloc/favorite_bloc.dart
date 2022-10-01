import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:io';

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

    try {
      // if(favoriteSongsList!.isNotEmpty){
      favoriteSongsList.add(infoSong);
      print(favoriteSongsList);
      return true;
      // }

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
    if (favoriteSongResponse != null) {
      emit(FavoriteSuccessState());
    } else {
      emit(FavoriteErrorState(error: 'Error'));
    }
  }

  Future<dynamic> deleteFavoriteSong(Map songToDelete) async {
    try {
      // if(favoriteSongsList!.isNotEmpty){

      for (int i = 0; i < favoriteSongsList.length; i++) {
        Map songElement = favoriteSongsList[i];
        if (songElement['title'] == favoriteSongsList[i]['title']) {
          favoriteSongsList.removeAt(i);
        }
      }
      // favoriteSongsList
      //     .removeWhere((item) => item['title'] = songToDelete['title']);
      print(favoriteSongsList);
      return true;
      // }

    } catch (e) {
      print('Error: $e');
    }
  }

  FutureOr<void> _setDeleteFavoriteSong(event, emit) async {
    bool deletedSong = await deleteFavoriteSong(event.songToDelete);
    print(deletedSong);

    if (deletedSong != null) {
      emit(DeleteFavoriteSuccessState());
    } else {
      emit(DeleteFavoriteErrorState(error: 'Error'));
    }
  }
}
