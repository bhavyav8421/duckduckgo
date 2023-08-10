import 'package:duckduckgo/logic/cubit/viewer_data_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/character_list_model.dart';
import '../../logic/cubit/viewer_data_state.dart';

class HomeScreen extends StatefulWidget {
  String title;
  HomeScreen({required this.title, Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late bool isMobile;
  final TextEditingController _searchController = TextEditingController();
  List<RelatedTopics> _filteredData = [];
  bool _isLoading = false;
  late List<RelatedTopics> topicListData;

  @override
  void initState() {
    super.initState();
    ViewerDataCubit cubit = BlocProvider.of<ViewerDataCubit>(context);
    cubit.getViewerData();
    _searchController.addListener(_performSearch);
  }

  Future<void> _performSearch() async {
    setState(() {
      _isLoading = true;
    });

    setState(() {
      if (_searchController.text.isEmpty) {
        _filteredData = topicListData;
      } else {
        _filteredData = topicListData
            .where((o) => o.text
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
        print("_filteredData$_filteredData");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    isMobile = isMobileLayout();
    return Scaffold(
        appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            //title: Text(widget.title),
            title: !_isLoading ? Text(widget.title) : _searchTextField(),
            actions: !_isLoading
                ? [
                    IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                          });
                        })
                  ]
                : [
                    IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _isLoading = false;
                            _filteredData = [];
                            _searchController.text = '';
                          });
                        })
                  ]),
        body: BlocBuilder<ViewerDataCubit, ViewerDataState>(
          builder: (context, state) {
            if (state is ViewerDataSuccesState) {
              return handleDataFetchedState(state);
            } else if (state is ViewerDataLoadingState) {
              return showProgress();
            } else if (state is ViewerDataFailureState) {
              return showErrorWidget(state);
            } else {
              return Container(
                child: Text("Data is not fetched. Please contact support team"),
              );
            }
          },
        ));
  }

  Widget showProgress() {
    return Center(
        child: Container(
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Color(0XFF0175C2),
          ),
          SizedBox(height: 10),
          Text("Fetching data"),
        ],
      ),
    ));
  }

  Widget showErrorWidget(ViewerDataFailureState state) {
    return Center(
      child: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(image: AssetImage('assets/icons_error.png')),
          SizedBox(height: 10),
          Text(state.error)
        ],
      )),
    );
  }

  Widget handleDataFetchedState(ViewerDataSuccesState state) {
    this.topicListData = state.topicListData;

    if (!isMobile) {
      return WideLayout(
          listData: this._isLoading ? this._filteredData : this.topicListData);
    } else {
      return NarrowLayout(
          listData: this._isLoading ? this._filteredData : this.topicListData);
    }
  }

  Widget _searchTextField() {
    return TextField(
      controller: _searchController,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: const InputDecoration(
        hintText: 'Search...',
        hintStyle: TextStyle(color: Colors.white54),
        border: InputBorder.none,
      ),
      onChanged: (value) {
        // Perform search functionality here
      },
    );
  }

  bool isMobileLayout() {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    bool useMobileLayout = shortestSide < 600;
    return useMobileLayout;
  }
}

class WideLayout extends StatefulWidget {
  late List<RelatedTopics> listData;
  WideLayout({required this.listData, Key? key}) : super(key: key);

  @override
  State<WideLayout> createState() => _WideLayoutState();
}

class _WideLayoutState extends State<WideLayout> {
  late RelatedTopics currentCharacter;

  @override
  void initState() {
    currentCharacter = widget.listData[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: CharacterListWidget(
              listData: widget.listData,
              onListTileTapped: (topic) => setState(() {
                currentCharacter = topic;
              }),
            ),
          ),
          width: 250,
        ),
        Expanded(
            child: currentCharacter == null
                ? Placeholder()
                : CharacterDetailWidget(
                    data: currentCharacter,
                  ))
      ],
    );
  }

  onCharacterListTileTapped(RelatedTopics relatedTopic) {}
}

class NarrowLayout extends StatefulWidget {
  List<RelatedTopics> listData;
  NarrowLayout({Key? key, required this.listData}) : super(key: key);

  @override
  State<NarrowLayout> createState() => _NarrowLayoutState();
}

class _NarrowLayoutState extends State<NarrowLayout> {
  @override
  Widget build(BuildContext context) {
    return CharacterListWidget(
      listData: widget.listData,
      onListTileTapped: (topic) => NavigateToDetailPage(context, topic),
    );
  }

  Future<dynamic> NavigateToDetailPage(
      BuildContext context, RelatedTopics topic) {
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Scaffold(
              appBar: AppBar(),
              body: CharacterDetailWidget(data: topic),
            )));
  }
}

class CharacterListWidget extends StatelessWidget {
  List<RelatedTopics> listData;
  void Function(RelatedTopics) onListTileTapped;
  CharacterListWidget(
      {required this.listData, required this.onListTileTapped, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(
              color: Colors.black45,
            ),
        padding: const EdgeInsets.all(8),
        itemCount: listData.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () => onListTileTapped(listData[index]),
            focusColor: Colors.blueGrey,
            title: Text(
              getTextValue(listData[index]),
            ),
            selectedColor: Colors.blue,
          );
        });
  }

  String getTextValue(RelatedTopics relatedTopic) {
    return relatedTopic.text.substring(0, relatedTopic.text.indexOf("-"));
  }
}

class CharacterDetailWidget extends StatelessWidget {
  String urlPrefix = "https://duckduckgo.com";
  RelatedTopics data;
  CharacterDetailWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isImageExists = false;
    String? imageUrl;
    if (data!.icon!.uRL!.isNotEmpty) {
      isImageExists = true;
      imageUrl = "$urlPrefix${data.icon.uRL}";
    } else {
      imageUrl = null;
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            isImageExists
                ? Image.network(imageUrl!)
                : Image(image: AssetImage('assets/icons_flutter.png')),
            SizedBox(height: 10),
            Text(data.text)
          ],
        ),
      ),
    );
  }
}
