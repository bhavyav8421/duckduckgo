import 'dart:convert';

import 'package:dio/dio.dart';
import '../exceptions/app_custom_exceptions.dart';
import '../models/character_list_model.dart';

abstract class ApiClient {
  Dio dio = new Dio(BaseOptions(baseUrl: "http://api.duckduckgo.com"));

  getCharacters();

  CharacterListModel parseCharacterData(response) {
    if (response.statusCode == 200) {
      if (response.data == null) {
        throw AppCustomException("Received null response from server");
      }
      final bodyJson = jsonDecode(response.data) as Map<String, dynamic>;
      if (!bodyJson.containsKey('RelatedTopics')) {
        throw AppCustomException("No data found");
      }
      return CharacterListModel.fromJson(bodyJson);
    } else {
      throw AppCustomException(
          "Request failed with status: ${response.statusCode}");
    }
  }
}
