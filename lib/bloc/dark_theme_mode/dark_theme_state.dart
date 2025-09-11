import 'package:equatable/equatable.dart';

class DarkThemeState extends Equatable {
  final bool darkTheme;

  const DarkThemeState({this.darkTheme = false});

  DarkThemeState copyWith({bool? darkTheme}) {
    return DarkThemeState(darkTheme: darkTheme ?? this.darkTheme);
  }

  @override
  List<Object?> get props => [darkTheme];
}
