import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:com.example.order_management_application/bloc/firebase_auth/firebase_auth_events.dart';
import 'package:com.example.order_management_application/bloc/firebase_auth/firebase_auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthBloc extends Bloc<FirebaseAuthEvents, FirebaseAuthState> {
  FirebaseAuthBloc() : super(FirebaseAuthState()) {
    on<IsSignInPage>(isSignInPage);
    on<AuthenticateUser>(authenticateUser);
    on<CredentialGiven>(credentialGiven);
    on<LogoutUser>(logoutUser);
    on<IsForgotPassMailSent>(isForgotPassMailSent);
    on<ForgotPasswordMailSentEvent>(forgotPasswordMailSentEvent);
  }

  FutureOr<void> isSignInPage(
    IsSignInPage event,
    Emitter<FirebaseAuthState> emit,
  ) {
    emit(state.copyWith(isSignInPage: event.isSignInPage));
  }

  FutureOr<void> credentialGiven(
    CredentialGiven event,
    Emitter<FirebaseAuthState> emit,
  ) {
    emit(state.copyWith(email: event.email, password: event.password));
  }

  FutureOr<void> authenticateUser(
    AuthenticateUser event,
    Emitter<FirebaseAuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      if (state.isSignInPage) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: state.email,
          password: state.password,
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: state.email,
          password: state.password,
        );
      }
      emit(state.copyWith(isAuthenticated: true, isLoading: false));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(
          state.copyWith(errorMessage: 'The password provided is too weak.'),
        );
      } else if (e.code == 'email-already-in-use') {
        emit(
          state.copyWith(
            errorMessage: 'The account already exists for that email.',
          ),
        );
      } else if (e.code == 'user-not-found') {
        emit(state.copyWith(errorMessage: 'No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        emit(state.copyWith(errorMessage: 'Wrong password provided.'));
      } else if (e.code == 'invalid-credential') {
        emit(state.copyWith(errorMessage: 'Invalid email or password.'));
      } else {
        emit(
          state.copyWith(errorMessage: "Something went wrong: ${e.message}"),
        );
      }
      emit(state.copyWith(isLoading: false, errorMessage: ""));
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          isAuthenticated: false,
          isLoading: false,
        ),
      );
    }
    emit(state.copyWith(errorMessage: ""));
  }

  FutureOr<void> logoutUser(
    LogoutUser event,
    Emitter<FirebaseAuthState> emit,
  ) async {
    try {
      await FirebaseAuth.instance.signOut();
      emit(state.copyWith(isAuthenticated: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  FutureOr<void> isForgotPassMailSent(
    IsForgotPassMailSent event,
    Emitter<FirebaseAuthState> emit,
  ) {
    emit(state.copyWith(isForgotPassMailSent: event.isMailSent));
  }

  FutureOr<void> forgotPasswordMailSentEvent(
    ForgotPasswordMailSentEvent event,
    Emitter<FirebaseAuthState> emit,
  ) async {
    print("Email ID:::::::::::::::::::::::::::::::: ${state.email}");
    await FirebaseAuth.instance.sendPasswordResetEmail(email: state.email).onError((
      error,
      stackTrace,
    ) {
      emit(
        state.copyWith(
          errorMessage:
              "Error: ${error.toString()} \n Stack Trace: ${stackTrace.toString()}",
        ),
      );
    });
  }
}
