import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:com.example.order_management_application/bloc/dark_theme_mode/dark_theme_bloc_events_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkThemeBloc extends Bloc<DarkThemeEvents, DarkThemeState> {
  DarkThemeBloc() : super(DarkThemeState()) {
    on<DarkModeToggleAndPreference>(darkModeToggleAndPreference);
    on<GetDarkModePreference>(getDarkModePreference);
  }
  void darkModeToggleAndPreference(
    DarkModeToggleAndPreference event,
    Emitter<DarkThemeState> emit,
  ) async {
    final inst = await SharedPreferences.getInstance();
    inst.setBool("DarkModeOn", event.darkModeToggle!);
    emit(state.copyWith(darkTheme: event.darkModeToggle));
  }

  FutureOr<void> getDarkModePreference(
    GetDarkModePreference event,
    Emitter<DarkThemeState> emit,
  ) async {
    final inst = await SharedPreferences.getInstance();
    bool? perf = inst.getBool("DarkModeOn");
    emit(state.copyWith(darkTheme: perf ?? false));
  }
}
