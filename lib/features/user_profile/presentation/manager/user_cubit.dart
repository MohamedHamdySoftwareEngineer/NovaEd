import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../sign_in/data/models/user_model.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  void setUser(User user) {
    emit(UserLoaded(user));
  }

  void clearUser() {
    emit(UserInitial());
  }

  User? get currentUser {
    if (state is UserLoaded) {
      return (state as UserLoaded).user;
    }
    return null;
  }
}
