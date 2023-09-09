import 'package:event_bus_exception/src/data/model/album_model.dart';
import 'package:event_bus_exception/src/data/model/album_model_error.dart';
import 'package:event_bus_exception/src/data/repository/api_call_impl.dart';

class MainController {
  final ApiCallImpl _repository;

  MainController({required ApiCallImpl repository}) : _repository = repository;

  Future<List<AlbumModel>?> getAlbuns({bool simulate = false}) async {
    return await _repository.getAlbuns(simulate: simulate);
  }

  Future<List<AlbumModelError>?> getAlbunsError() async {
    return await _repository.getAlbunsError();
  }
}
