import 'package:event_bus_exception/src/data/model/album_model.dart';
import 'package:event_bus_exception/src/data/model/album_model_error.dart';

abstract interface class ApiCall {
  Future<List<AlbumModel>?> getAlbuns();
  Future<List<AlbumModelError>?> getAlbunsError();
}
