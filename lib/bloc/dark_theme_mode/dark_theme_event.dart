import 'package:equatable/equatable.dart';

abstract class DarkThemeEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class DarkModeToggleAndPreference extends DarkThemeEvents {
  final bool? darkModeToggle;
  DarkModeToggleAndPreference({required this.darkModeToggle});

  @override
  List<Object?> get props => [darkModeToggle];
}

class GetDarkModePreference extends DarkThemeEvents {}
