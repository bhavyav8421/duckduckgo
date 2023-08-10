import 'package:dio/dio.dart';
import 'package:duckduckgo/data/api_clients/api_client.dart';

import '../models/character_list_model.dart';

class SimpsonsApiClient extends ApiClient {
  SimpsonsApiClient({Dio? dio}) {
    if (dio != null) {
      this.dio = dio!;
    }
  }
  @override
  Future<CharacterListModel> getCharacters() async {
    Response response = await dio.get("/?q=simpsons+characters&format=json");
    CharacterListModel characterListModel = parseCharacterData(response);
    return characterListModel;
  }
}
