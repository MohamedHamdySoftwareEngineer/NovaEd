
// This file defines the states for the submission process in the choice screen feature.
// It is used by the SubmissionCubit to manage the state of submission creation. 
abstract class SubmissionState {
  List<Object?> get props => [];
}

class SubmissionInitial extends SubmissionState {}

class SubmissionLoading extends SubmissionState {}

class SubmissionSuccess extends SubmissionState {
  final int submissionId;
  SubmissionSuccess(this.submissionId);

  @override
  List<Object?> get props => [submissionId];
}

class SubmissionFailure extends SubmissionState {
  final String errorMessage;

  SubmissionFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
