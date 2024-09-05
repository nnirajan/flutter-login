import 'package:equatable/equatable.dart';
import 'package:flutter_login/login/model/password.dart';
import 'package:flutter_login/login/model/username.dart';
import 'package:formz/formz.dart';

final class LoginState extends Equatable {
  final Username username;
  final Password password;
  final bool isValid;
  final FormzSubmissionStatus status;

  const LoginState({
    this.username = const Username.pure(),
    this.password = const Password.pure(),
    this.isValid = false,
    this.status = FormzSubmissionStatus.initial,
  });

  LoginState copyWith({
    Username? username,
    Password? password,
    bool? isValid,
    FormzSubmissionStatus? status,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [username, password, status];
}
