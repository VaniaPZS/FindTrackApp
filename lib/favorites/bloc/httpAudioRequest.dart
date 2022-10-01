import 'dart:convert';

import 'package:http/http.dart';

import 'package:http/http.dart' as http;

import '../utils/secret.dart';

class HttpAudioRequest {
  static final HttpAudioRequest _httpAudioReq = HttpAudioRequest._internal();

  factory HttpAudioRequest() {
    return _httpAudioReq;
  }

  HttpAudioRequest._internal();

  Future<Response> auddRequest(url, encodedSong) async {
    return await http.post(Uri.parse(url), body: {
      "audio": encodedSong,
      "api_token": "${APITOKEN}",
      "return": "spotify,apple_music,deezer",
    });
  }
}
