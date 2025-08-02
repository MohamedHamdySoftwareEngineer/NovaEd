import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novaed_app/features/LogIn/presentation/manager/auth_state.dart';

import '../../data/models/user_model.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void setUser(User user) {
    emit(Authenticated(user));
  }

  void signOut() {
    emit(Unauthenticated());
  }
}
