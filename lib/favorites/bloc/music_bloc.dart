import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:practica1/favorites/bloc/httpAudioRequest.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;

part 'music_event.dart';
part 'music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  bool animateBool = false;
  String listeningText = 'Toque para escuchar';
  MusicBloc() : super(MusicInitial()) {
    on<GetMusicEvent>(_getMusic);
  }

  Future<dynamic> getRecording() async {
    animateBool = true;
    listeningText = 'Escuchando';
    Duration time = Duration(seconds: 6);
    final String url = "https://api.audd.io/";

    final audioRecorder = Record();

    try {
      bool permision = await audioRecorder.hasPermission();

      if (permision) {
        await audioRecorder.start(encoder: AudioEncoder.AAC);

        await Future.delayed(time);

        final path = await audioRecorder.stop();

        if (path == null) {
          return;
        }

        File songPath = File(path);

        final finalSongSFile = songPath.readAsBytesSync();
        String encodedSong = base64Encode(finalSongSFile);

        var response = await HttpAudioRequest().auddRequest(url, encodedSong);

        // await http.post(Uri.parse(url), body: {
        //   "audio": encodedSong,
        //   "api_token": "89364fbeac8169a2d87a9da86211584b",
        //   "return": "spotify,apple_music,deezer",
        // });

        if (response.statusCode == HttpStatus.ok) {
          print(jsonDecode(response.body));
          return jsonDecode(response.body);
        } else {
          throw Exception('Not Found');
        }
      }
    } catch (e) {
      throw Exception('Error');
    }
  }

  FutureOr<void> _getMusic(event, emit) async {
    emit(GetMusicLoadState());
    var infoSong = await getRecording();

    if (infoSong['result'] != null) {
      emit(GetMusicSuccessState(cancion: infoSong));
      animateBool = false;
      listeningText = 'Toque para escuchar';
    } else {
      emit(GetMusicErrorState(error: 'Error'));
      animateBool = false;
      listeningText = 'Toque para escuchar';
    }
  }
}
