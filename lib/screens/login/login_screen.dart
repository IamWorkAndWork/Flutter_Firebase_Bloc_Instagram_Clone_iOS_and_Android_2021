import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram/repositories/auth/auth_repository.dart';
import 'package:flutter_instagram/screens/login/cubit/login_cubit.dart';
import 'package:flutter_instagram/screens/screens.dart';
import 'package:flutter_instagram/screens/signup/signup_screen.dart';
import 'package:flutter_instagram/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = "/login";

  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (context, animation, secondaryAnimation) =>
          BlocProvider<LoginCubit>(
        create: (context) => LoginCubit(
          authRepository: context.read<AuthRepository>(),
        ),
        child: LoginScreen(),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.error) {
              showDialog(
                context: context,
                builder: (context) =>
                    ErrorDialog(content: state.failure.message),
              );
            } else if (state.status == LoginStatus.success) {
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
                            decoration: InputDecoration(hintText: "Email"),
                            onChanged: (value) =>
                                context.read<LoginCubit>().emailChanged(value),
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
                                .read<LoginCubit>()
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
                                state.status == LoginStatus.submitting),
                            child: const Text(
                              "Login",
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
                            onPressed: () => Navigator.of(context)
                                .pushNamed(SignupScreen.routeName),
                            child: Text(
                              "No Account? Sign up",
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
      context.read<LoginCubit>().loginWithCredentials();
    }
  }
}
