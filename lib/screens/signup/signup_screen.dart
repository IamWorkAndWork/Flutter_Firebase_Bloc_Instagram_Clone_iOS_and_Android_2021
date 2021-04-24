import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram/repositories/auth/auth_repository.dart';
import 'package:flutter_instagram/screens/nav/nav_screen.dart';
import 'package:flutter_instagram/widgets/widgets.dart';

import 'cubit/signup_cubit.dart';

class SignupScreen extends StatelessWidget {
  static const String routeName = "/signup";

  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (context, animation, secondaryAnimation) =>
          BlocProvider<SignupCubit>(
        create: (context) => SignupCubit(
          authRepository: context.read<AuthRepository>(),
        ),
        child: SignupScreen(),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state.status == SignupStatus.error) {
              showDialog(
                context: context,
                builder: (context) => ErrorDialog(
                  content: state.failure.message,
                ),
              );
            } else if (state.status == SignupStatus.success) {
              Navigator.pushReplacementNamed(context, NavScreen.routeName);
            }
          },
          builder: (context, state) => Scaffold(
            resizeToAvoidBottomInset: false,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text(
                            "Instagram",
                            style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 12.0,
                          ),
                          TextFormField(
                            decoration: InputDecoration(hintText: "Username"),
                            onChanged: (value) => context
                                .read<SignupCubit>()
                                .usernameChanged(value),
                            validator: (value) => value.trim().isEmpty
                                ? "Please enter a valid username."
                                : null,
                          ),
                          const SizedBox(
                            height: 12.0,
                          ),
                          TextFormField(
                            decoration: InputDecoration(hintText: "Email"),
                            onChanged: (value) =>
                                context.read<SignupCubit>().emailChanged(value),
                            validator: (value) => !value.contains("@")
                                ? "Please enter a valid email."
                                : null,
                          ),
                          const SizedBox(
                            height: 12.0,
                          ),
                          TextFormField(
                            decoration: InputDecoration(hintText: "Password"),
                            obscureText: true,
                            onChanged: (value) => context
                                .read<SignupCubit>()
                                .passwordChanged(value),
                            validator: (value) => value.length < 6
                                ? "Must be at least 6 characters."
                                : null,
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                              elevation: 1.0,
                            ),
                            onPressed: () => _submitForm(context,
                                state.status == SignupStatus.submitting),
                            child: const Text(
                              "Signup",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12.0,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 1.0,
                              primary: Colors.grey[200],
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              "Back to Login",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      onWillPop: () async => false,
    );
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState.validate() && !isSubmitting) {
      context.read<SignupCubit>().signupWithCredentials();
    }
  }
}
