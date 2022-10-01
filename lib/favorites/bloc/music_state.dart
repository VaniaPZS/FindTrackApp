part of 'music_bloc.dart';

@immutable
abstract class MusicState extends Equatable{
  const MusicState();

    @override
  List<Object> get props => [];
}

class MusicInitial extends MusicState {
}

class GetMusicSuccessState extends MusicState {
  final Map cancion;

  GetMusicSuccessState({ required this.cancion});

  @override
  List<Object> get props => [cancion];
}

class GetMusicErrorState extends MusicState {
  final String error;

  GetMusicErrorState({required this.error});
}

class GetMusicLoadState extends MusicState{
  final bool animateBool = true;
}