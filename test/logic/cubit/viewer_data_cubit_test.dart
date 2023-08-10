import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:duckduckgo/data/api_clients/api_client.dart';
import 'package:duckduckgo/data/api_clients/wire_api_client.dart';
import 'package:duckduckgo/data/api_repository.dart' as api_repository;
import 'package:duckduckgo/data/api_repository.dart';
import 'package:duckduckgo/data/models/character_list_model.dart'
    as dataListModel;
import 'package:duckduckgo/data/exceptions/app_custom_exceptions.dart';
import 'package:duckduckgo/data/models/character_list_model.dart';
import 'package:duckduckgo/logic/cubit/viewer_data_cubit.dart';
import 'package:duckduckgo/logic/cubit/viewer_data_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group('fetchWeather', () {
    late Dio dio;
    late DioAdapter dioAdapter;
    const Url = 'http://api.duckduckgo.com/?q=the+wire+characters&format=json';
    Map<String, dynamic> data = {
      "Abstract": "",
      "AbstractSource": "Wikipedia",
      "AbstractText": "",
      "AbstractURL": "https://en.wikipedia.org/wiki/The_Simpsons_characters",
      "Answer": "",
      "AnswerType": "",
      "Definition": "",
      "DefinitionSource": "",
      "DefinitionURL": "",
      "Entity": "",
      "Heading": "The Simpsons characters",
      "Image": "",
      "ImageHeight": 0,
      "ImageIsLogo": 0,
      "ImageWidth": 0,
      "Infobox": "",
      "Redirect": "",
      "RelatedTopics": [
        {
          "FirstURL": "https://duckduckgo.com/Apu_Nahasapeemapetilan",
          "Icon": {"Height": "", "URL": "", "Width": ""},
          "Result":
              "<a href=\"https://duckduckgo.com/Apu_Nahasapeemapetilan\">Apu Nahasapeemapetilan</a><br>Apu Nahasapeemapetilan is a recurring character in the American animated television series The Simpsons. He is an Indian immigrant proprietor who runs the Kwik-E-Mart, a popular convenience store in Springfield, and is known for his catchphrase, \"Thank you, come again\".",
          "Text":
              "Apu Nahasapeemapetilan - Apu Nahasapeemapetilan is a recurring character in the American animated television series The Simpsons. He is an Indian immigrant proprietor who runs the Kwik-E-Mart, a popular convenience store in Springfield, and is known for his catchphrase, \"Thank you, come again\"."
        },
        {
          "FirstURL": "https://duckduckgo.com/Apu_Nahasapeemapetilon",
          "Icon": {"Height": "", "URL": "/i/99b04638.png", "Width": ""},
          "Result":
              "<a href=\"https://duckduckgo.com/Apu_Nahasapeemapetilon\">Apu Nahasapeemapetilon</a><br>Apu Nahasapeemapetilon is a recurring character in the American animated television series The Simpsons. He is an Indian immigrant proprietor who runs the Kwik-E-Mart, a popular convenience store in Springfield, and is known for his catchphrase, \"Thank you, come again\".",
          "Text":
              "Apu Nahasapeemapetilon - Apu Nahasapeemapetilon is a recurring character in the American animated television series The Simpsons. He is an Indian immigrant proprietor who runs the Kwik-E-Mart, a popular convenience store in Springfield, and is known for his catchphrase, \"Thank you, come again\"."
        },
      ],
    };

    setUp(() {
      dio = Dio();
      dioAdapter = DioAdapter(dio: dio);
      dio.httpClientAdapter = dioAdapter;
    });

    blocTest<ViewerDataCubit, ViewerDataState>(
      'When data is empty',
      setUp: (() {
        return dioAdapter.onGet(
          Url,
          (request) => request.reply(200, '{}'),
        );
      }),
      build: () => ViewerDataCubit(
          apiRepository: ApiRepository(client: WireApiClient(dio: dio))),
      wait: const Duration(milliseconds: 500),
      act: (cubit) => cubit.getViewerData(),
      expect: () => [
        ViewerDataLoadingState(),
        ViewerDataFailureState(error: "No data found")
      ],
    );

    blocTest<ViewerDataCubit, ViewerDataState>(
      'When data is not empty',
      setUp: (() {
        return dioAdapter.onGet(
          Url,
          (request) => request.reply(200, jsonEncode(data)),
        );
      }),
      build: () => ViewerDataCubit(
          apiRepository: ApiRepository(client: WireApiClient(dio: dio))),
      wait: const Duration(milliseconds: 500),
      act: (cubit) => cubit.getViewerData(),
      expect: () => [
        ViewerDataLoadingState(),
        ViewerDataSuccesState(
            topicListData: CharacterListModel.fromJson(data).relatedTopics)
      ],
    );
  });
  group('Error scenarios: ', () {
    late Dio dio;
    late DioAdapter dioAdapter;
    const url = 'http://api.duckduckgo.com/?q=the+wire+characters&format=json';
    setUp(() {
      dio = Dio();
      dioAdapter = DioAdapter(dio: dio);
      dio.httpClientAdapter = dioAdapter;
    });

    blocTest<ViewerDataCubit, ViewerDataState>(
      'emits failure at initial response is null',
      setUp: (() {
        return dioAdapter.onGet(
          url,
          (request) => request.reply(200, null),
        );
      }),
      build: () => ViewerDataCubit(
          apiRepository:
              api_repository.ApiRepository(client: WireApiClient(dio: dio))),
      wait: const Duration(milliseconds: 500),
      act: (cubit) => cubit.getViewerData(),
      expect: () => [
        ViewerDataLoadingState(),
        ViewerDataFailureState(error: 'Received null response from server')
      ],
    );
  });
}

CharacterListModel getCharacterListData(Map<String, dynamic> data) {
  //final bodyJson = jsonDecode(data.toString()) as Map<String, dynamic>;
  return CharacterListModel.fromJson(data);
}
