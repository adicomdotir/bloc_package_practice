import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;

import 'package:testingbloc_practice/bloc/app_state.dart';
import 'package:testingbloc_practice/bloc/bloc_events.dart';

typedef AppBlocRandomUrlPicker = String Function(Iterable<String> allUrls);
typedef AppBlocUrlLoader = Future<Uint8List> Function(String url);

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(
        math.Random().nextInt(length),
      );
}

class AppBloc extends Bloc<AppEvent, AppState> {
  String _pickRandomUrl(Iterable<String> allUrls) => allUrls.getRandomElement();

  Future<Uint8List> _loadUrl(String url) => NetworkAssetBundle(Uri.parse(url))
      .load(url)
      .then((value) => value.buffer.asUint8List());

  AppBloc({
    required Iterable<String> urls,
    Duration? waitBeforeLoading,
    AppBlocRandomUrlPicker? urlPicker,
    AppBlocUrlLoader? urlLoader,
  }) : super(
          const AppState.empty(),
        ) {
    on<LoadNextUrlEvent>((event, emit) async {
      // start loading
      emit(
        const AppState(
          isLoading: true,
          data: null,
          error: null,
        ),
      );
      final url = (urlPicker ?? _pickRandomUrl)(urls);
      try {
        if (waitBeforeLoading != null) {
          await Future.delayed(waitBeforeLoading);
        }
        final data = await (urlLoader ?? _loadUrl)(url);
        emit(
          AppState(
            isLoading: false,
            data: data,
            error: null,
          ),
        );
      } catch (e) {
        emit(
          AppState(
            isLoading: false,
            data: null,
            error: e,
          ),
        );
      }
    });
  }
}
