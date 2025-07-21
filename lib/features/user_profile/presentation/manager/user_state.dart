import 'package:equatable/equatable.dart';

import '../../../sign_in/data/models/user_model.dart';

abstract class UserState extends Equatable {
  const UserState();

  // we put @override to ensure that the equality check is based on the properties of the class
  // means that two instances of UserState are equal if they have the same properties
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;

  const UserLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class UserError extends UserState {
  final String errorMessage;

  const UserError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
