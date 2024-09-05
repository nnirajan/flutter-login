import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_login/login/bloc/login_event.dart';
import 'package:flutter_login/login/bloc/login_state.dart';
import 'package:flutter_login/login/model/password.dart';
import 'package:flutter_login/login/model/username.dart';
import 'package:formz/formz.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationRepository _authenticationRepository;

  LoginBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const LoginState()) {
    on<LoginUsernameChanged>(_onUsernameChanged);

    on<LoginPasswrodChanged>(_onPasswordChanged);

    on<LoginSubmitted>(_onSubmitted);
  }

  Future<void> _onUsernameChanged(
    LoginUsernameChanged event,
    Emitter emit,
  ) async {
    final username = Username.dirty(event.username);

    emit(
      state.copyWith(
        username: username,
        isValid: Formz.validate([
          username,
          state.password,
        ]),
      ),
    );
  }

  Future<void> _onPasswordChanged(
    LoginPasswrodChanged event,
    Emitter emit,
  ) async {
    final password = Password.dirty(event.password);

    emit(state.copyWith(
      password: password,
      isValid: Formz.validate([
        state.username,
        password,
      ]),
    ));
  }

  Future<void> _onSubmitted(LoginSubmitted event, Emitter emit) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    }

    try {
      await _authenticationRepository.logIn(
        username: state.username.value,
        password: state.password.value,
      );

      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
