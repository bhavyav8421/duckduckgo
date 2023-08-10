import 'dart:convert';

import 'package:duckduckgo/data/api_clients/api_client.dart';

import 'api_clients/wire_api_client.dart';
import 'models/character_list_model.dart';

class ApiRepository {
  late ApiClient client;
  ApiRepository({required this.client});
  Future<CharacterListModel> fetchCharacterData() async {
    CharacterListModel characterListModel = await client.getCharacters();
    return characterListModel;
  }
}
