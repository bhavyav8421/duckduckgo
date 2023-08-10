import 'package:duckduckgo/data/models/character_list_model.dart';
import 'package:equatable/equatable.dart';

class ViewerDataState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ViewerDataInitState extends ViewerDataState {}

class ViewerDataLoadingState extends ViewerDataState {}

class ViewerDataSuccesState extends ViewerDataState {
  late List<RelatedTopics> topicListData;

  ViewerDataSuccesState({required this.topicListData});
  @override
  List<Object?> get props => [topicListData];
}

class ViewerDataFailureState extends ViewerDataState {
  late String error;

  ViewerDataFailureState({required this.error});
  @override
  List<Object?> get props => [error];
}
