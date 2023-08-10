import 'package:duckduckgo/data/exceptions/app_custom_exceptions.dart';
import 'package:duckduckgo/logic/cubit/viewer_data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/api_repository.dart';

class ViewerDataCubit extends Cubit<ViewerDataState> {
  ApiRepository apiRepository;
  ViewerDataCubit({required this.apiRepository}) : super(ViewerDataInitState());

  void getViewerData() async {
    emit(ViewerDataLoadingState());
    try {
      final data = await apiRepository.fetchCharacterData();
      emit(ViewerDataSuccesState(topicListData: data.relatedTopics));
    } on AppCustomException catch (e) {
      emit(ViewerDataFailureState(error: e.error));
    } catch (e) {
      emit(ViewerDataFailureState(error: e.toString()));
    }
  }
}
