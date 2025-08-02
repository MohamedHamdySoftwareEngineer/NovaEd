import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/api_service.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ApiService apiService;
  ProfileCubit(this.apiService) : super(ProfileInitial());

  Future<void> getUserInfo() async {
    emit(ProfileLoading());
    try {
      final response = await apiService.getUserProfile();
      emit(ProfileLoaded(response));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}