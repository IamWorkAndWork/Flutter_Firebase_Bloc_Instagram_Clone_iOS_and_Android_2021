import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocObserver extends BlocObserver {

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print("SimpleBlocObserver error = $error");
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onEvent(Bloc bloc, Object event) {
    print("SimpleBlocObserver event = $event");
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print("SimpleBlocObserver transition = $transition");
    super.onTransition(bloc, transition);
  }

}
