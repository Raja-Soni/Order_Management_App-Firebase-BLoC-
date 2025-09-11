import 'package:equatable/equatable.dart';

class FirebaseAuthState extends Equatable {
  final bool isLoading;
  final bool isAuthenticated;
  final bool isSignInPage;
  final String errorMessage;
  final String email;
  final String password;

  const FirebaseAuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.isSignInPage = true,
    this.errorMessage = "",
    this.email = "",
    this.password = "",
  });

  FirebaseAuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    bool? isSignInPage,
    String? errorMessage,
    String? email,
    String? password,
  }) {
    return FirebaseAuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isSignInPage: isSignInPage ?? this.isSignInPage,
      errorMessage: errorMessage ?? this.errorMessage,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isAuthenticated,
    isSignInPage,
    errorMessage,
    email,
    password,
  ];
}
