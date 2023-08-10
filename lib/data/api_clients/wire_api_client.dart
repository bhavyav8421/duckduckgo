import 'package:dio/dio.dart';

import '../models/character_list_model.dart';
import 'api_client.dart';

class WireApiClient extends ApiClient {
  WireApiClient({Dio? dio}) {
    this.dio = dio!;
  }
  @override
  Future<CharacterListModel> getCharacters() async {
    Response response = await dio
        .get("http://api.duckduckgo.com/?q=the+wire+characters&format=json");
    CharacterListModel characterListModel = parseCharacterData(response);
    return characterListModel;
  }
}
