import 'package:duckduckgo/data/api_clients/api_client.dart';
import 'package:duckduckgo/data/api_clients/simpsons_api_client.dart';
import 'package:duckduckgo/data/api_clients/wire_api_client.dart';
import 'package:duckduckgo/data/api_repository.dart';
import 'package:duckduckgo/logic/cubit/viewer_data_cubit.dart';
import 'package:duckduckgo/presentation/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'flavor/flavor_config.dart';

void mainCommon(FlavorConfig config) {
  runApp(MyApp(config));
}

class MyApp extends StatefulWidget {
  late FlavorConfig config;
  MyApp(this.config, {Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ApiClient apiClient;
  @override
  void initState() {
    super.initState();
    apiClient = widget.config == FlavorType.WireViewer
        ? WireApiClient()
        : SimpsonsApiClient();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ViewerDataCubit>(
      create: (context) =>
          ViewerDataCubit(apiRepository: ApiRepository(client: apiClient)),
      child: MaterialApp(
        title: widget.config.appTitle,
        theme: widget.config.theme,
        home: HomeScreen(
          title: widget.config.appTitle,
        ),
      ),
    );
  }
}
