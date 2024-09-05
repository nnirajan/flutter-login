import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/login/bloc/login_bloc.dart';
import 'package:flutter_login/login/bloc/login_event.dart';
import 'package:flutter_login/login/bloc/login_state.dart';
import 'package:formz/formz.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text("Authentication Failure")),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _UsernameInput(),
            const Padding(padding: EdgeInsets.all(12)),
            _PasswordInput(),
            const Padding(padding: EdgeInsets.all(12)),
            _LoginButton(),
          ],
        ),
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextField(
          key: const Key("loginForm_usernameInput_textfield"),
          onChanged: (value) {
            return context
                .read<LoginBloc>()
                .add(LoginUsernameChanged(username: value));
          },
          decoration: InputDecoration(
            labelText: "Username",
            errorText:
                state.username.displayError != null ? "Invalid username" : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key("loginForm_passwordInput_textfeild"),
          onChanged: (value) {
            return context
                .read<LoginBloc>()
                .add(LoginPasswrodChanged(password: value));
          },
          decoration: InputDecoration(
              labelText: "Password",
              errorText: state.password.displayError != null
                  ? "Invalid Password"
                  : null),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key("loginForm_loginButton"),
                onPressed: () {
                  if (state.isValid) {
                    context.read<LoginBloc>().add(const LoginSubmitted());
                  } else {
                    null;
                  }
                },
                child: const Text("Login"),
              );
      },
    );
  }
}
