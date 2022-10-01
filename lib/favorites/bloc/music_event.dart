part of 'music_bloc.dart';

@immutable
abstract class MusicEvent extends Equatable {
  const MusicEvent();

  @override
  List<Object> get props => [];
}

class GetMusicEvent extends MusicEvent {
  @override
  List<Object> get props => [];
}
