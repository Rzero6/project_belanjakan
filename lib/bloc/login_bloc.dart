import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_belanjakan/bloc/form_submission_state.dart';
import 'package:project_belanjakan/bloc/login_event.dart';
import 'package:project_belanjakan/bloc/login_state.dart';
import 'package:project_belanjakan/model/user_api.dart';
import 'package:project_belanjakan/repository/login_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository = LoginRepository();
  LoginBloc() : super(LoginState()) {
    on<IsPasswordVisibleChanged>(
        (event, emit) => _onIsPasswordVisibleChanged(event, emit));
    on<FormSubmitted>((event, emit) => _onFormSubmitted(event, emit));
  }

  void _onIsPasswordVisibleChanged(
      IsPasswordVisibleChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(
      isPasswordVisible: !state.isPasswordVisible,
      formSubmissionState: const InitialFormState(),
    ));
  }

  void _onFormSubmitted(FormSubmitted event, Emitter<LoginState> emit) async {
    emit(state.copyWith(formSubmissionState: FormSubmitting()));
    try {
      User userData= await loginRepository.login(event.email, event.password);
      emit(state.copyWith(formSubmissionState: SubmissionSuccess(user: userData)));
    } on FailedLogin catch (e) {
      emit(state.copyWith(
          formSubmissionState: SubmissionFailed(e.errorMessage())));
    } on String catch (e) {
      emit(state.copyWith(formSubmissionState: SubmissionFailed(e)));
    } catch (e) {
      emit(state.copyWith(formSubmissionState: SubmissionFailed(e.toString())));
    }
  }
}
