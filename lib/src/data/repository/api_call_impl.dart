import 'package:dio/dio.dart';
import 'package:event_bus_exception/src/core/exceptions/critical_exception.dart';
import 'package:event_bus_exception/src/data/model/album_model.dart';
import 'package:event_bus_exception/src/data/model/album_model_error.dart';

import './api_call.dart';

class ApiCallImpl implements ApiCall {
  final Dio _rest;

  ApiCallImpl({required Dio rest}) : _rest = rest;

  @override
  Future<List<AlbumModel>?> getAlbuns({bool simulate = false}) async {
    String url = 'https://jsonplaceholder.typicode.com/albums/1/photos';

    try {
      final Response response;
      if (simulate) {
        url = 'https://httpstat.us/500';
        response = await _rest.post(url, data: {'nome': 'teste', 'email': 'teste@teste.com.br'});
      } else {
        response = await _rest.get(url);
        if (response.statusCode == 200) {
          return (response.data as List).map<AlbumModel>((album) => AlbumModel.fromMap(album)).toList();
        }
      }
    } catch (e, s) {
      throw CriticalException(e.toString(), stack: s);
    }
    return null;
  }

  @override
  Future<List<AlbumModelError>?> getAlbunsError() async {
    try {
      String url = 'https://jsonplaceholder.typicode.com/albums/1/photos';

      final response = await _rest.get(url);
      if (response.statusCode == 200) {
        return (response.data as List).map<AlbumModelError>((album) => AlbumModelError.fromMap(album)).toList();
      }
    } catch (e, s) {
      throw CriticalException(e.toString(), stack: s);
    }
    return null;
  }
}
