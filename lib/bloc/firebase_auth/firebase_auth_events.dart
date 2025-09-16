import 'package:equatable/equatable.dart';

class FirebaseAuthEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class IsSignInPage extends FirebaseAuthEvents {
  final bool isSignInPage;
  IsSignInPage({required this.isSignInPage});

  @override
  List<Object?> get props => [isSignInPage];
}

class CredentialGiven extends FirebaseAuthEvents {
  final String? email;
  final String? password;
  CredentialGiven({this.email, this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthenticateUser extends FirebaseAuthEvents {}

class LogoutUser extends FirebaseAuthEvents {}

class IsForgotPassMailSent extends FirebaseAuthEvents {
  final bool? isMailSent;
  IsForgotPassMailSent({this.isMailSent});
}

class ForgotPasswordMailSentEvent extends FirebaseAuthEvents {}
