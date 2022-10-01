part of 'favorite_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class AddFavoriteEvent extends FavoriteEvent {

  final String songName;
  final String artistName;
  final String albumName;
  final String urlImage;
  final String urlApple;
  final String urlSpotify;
  final String urlDeezer;
  final String songYear;

  AddFavoriteEvent(this.songName, this.artistName, this.albumName,  this.urlImage, this.urlApple, this.urlSpotify, this.urlDeezer, this.songYear);

  @override
  List<Object> get props => [songName, artistName, albumName,  urlImage, urlApple, urlSpotify, urlDeezer, songYear];
}

class DeleteFavoriteEvent extends FavoriteEvent {

  // final String songName;
  // final String artistName;
  // final String albumName;
  // final String urlImage;
  // final String urlApple;
  // final String urlSpotify;
  // final String urlDeezer;
  // final String songYear;

  final Map songToDelete;

  // DeleteFavoriteEvent(this.songName, this.artistName, this.albumName,  this.urlImage, this.urlApple, this.urlSpotify, this.urlDeezer, this.songYear);
  DeleteFavoriteEvent(this.songToDelete);

  @override
  List<Object> get props => [songToDelete];
}
