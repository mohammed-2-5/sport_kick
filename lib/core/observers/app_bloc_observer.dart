import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/utils/app_logger.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    AppLogger.debug(
      'state: ${bloc.state.runtimeType}',
      tag: 'BLOC/${bloc.runtimeType}',
    );
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    AppLogger.debug(
      'event: ${event.runtimeType}',
      tag: 'BLOC/${bloc.runtimeType}',
    );
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    AppLogger.debug(
      'change: ${change.currentState.runtimeType} -> ${change.nextState.runtimeType}',
      tag: 'BLOC/${bloc.runtimeType}',
    );
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    AppLogger.debug(
      'event: ${transition.event.runtimeType} | '
      'state: ${transition.currentState.runtimeType} -> ${transition.nextState.runtimeType}',
      tag: 'BLOC/${bloc.runtimeType}',
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    AppLogger.error(
      'error: $error',
      tag: 'BLOC/${bloc.runtimeType}',
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    AppLogger.debug('closed', tag: 'BLOC/${bloc.runtimeType}');
    super.onClose(bloc);
  }
}
