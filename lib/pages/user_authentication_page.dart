import 'package:com.example.order_management_application/AppColors/app_colors.dart';
import 'package:com.example.order_management_application/bloc/dark_theme_mode/dark_theme_bloc_events_state.dart';
import 'package:com.example.order_management_application/bloc/firebase_auth/firebase_auth_bloc_events_states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../custom_widgets/import_all_custom_widgets.dart';
import '../routes/all_routes.dart';

class UserAuthenticationPage extends StatefulWidget {
  const UserAuthenticationPage({super.key});
  @override
  State<UserAuthenticationPage> createState() => SignInPageState();
}

class SignInPageState extends State<UserAuthenticationPage> {
  GlobalKey<FormState> loginFormKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    const double maxFormWidth = 500;
    return Scaffold(
      body: BlocBuilder<DarkThemeBloc, DarkThemeState>(
        builder: (context, darkThemeState) {
          return BlocConsumer<FirebaseAuthBloc, FirebaseAuthState>(
            listener: (context, firebaseAuthState) {
              if (firebaseAuthState.isAuthenticated) {
                scaffoldMessenger
                    .showSnackBar(
                      SnackBar(
                        width: kIsWeb ? 450 : screenWidth,
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(milliseconds: 600),
                        content: CustomText(
                          text: firebaseAuthState.isSignInPage
                              ? "Logged In Successfully!!!"
                              : "Signed Up Successfully!!!",
                          textColor: AppColor.whiteColor,
                        ),
                        backgroundColor: AppColor.confirmColor,
                      ),
                    )
                    .closed
                    .then((value) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RouteNames.myHomePage,
                        (route) => false,
                      );
                    });
              } else if (firebaseAuthState.errorMessage.isNotEmpty) {
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    width: kIsWeb ? 450 : screenWidth,
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 1),
                    content: CustomText(
                      text: firebaseAuthState.errorMessage,
                      textColor: AppColor.whiteColor,
                    ),
                    backgroundColor: AppColor.cancelColor,
                  ),
                );
              }
            },
            builder: (context, firebaseAuthState) {
              return SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxFormWidth),
                    child: Card(
                      color: darkThemeState.darkTheme
                          ? (kIsWeb
                                ? AppColor.darkThemeColor
                                : AppColor.scaffoldDarkBackgroundColor)
                          : (kIsWeb
                                ? AppColor.lightThemeColor
                                : AppColor.scaffoldLightBackgroundColor),
                      margin: EdgeInsets.zero,
                      child: Column(
                        children: [
                          CustomContainer(
                            height: 200,
                            backgroundColor:
                                AppColor.signInAndSignUpPageThemeColor,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 100.0),
                                child: CustomText(
                                  textSize: 40,
                                  text: firebaseAuthState.isSignInPage == true
                                      ? "Log In"
                                      : "Sign Up",
                                  textBoldness: FontWeight.bold,
                                  textColor: AppColor.whiteColor,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: loginFormKey,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 100.0),
                                    child: CustomText(
                                      text:
                                          firebaseAuthState.isSignInPage == true
                                          ? "Welcome"
                                          : "Create Account",
                                      textBoldness: FontWeight.bold,
                                      textSize: 45,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: CustomText(
                                      text:
                                          firebaseAuthState.isSignInPage == true
                                          ? ""
                                          : "Make sure you enter a valid email address",
                                      textBoldness: FontWeight.bold,
                                      textSize: 15,
                                    ),
                                  ),
                                  CustomFormTextField(
                                    hintText: 'Email',
                                    inputType: TextInputType.emailAddress,
                                    icon: Icon(Icons.email_outlined),
                                    validate: (String? value) {
                                      final emailRegex = RegExp(
                                        r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                                      );
                                      if (value == null || value.isEmpty) {
                                        return "Please Enter Your Email";
                                      } else if (!emailRegex.hasMatch(value)) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                    changedValue: (String? value) {
                                      context.read<FirebaseAuthBloc>().add(
                                        CredentialGiven(email: value!),
                                      );
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  CustomFormTextField(
                                    isPassword: firebaseAuthState.showPassword
                                        ? false
                                        : true,
                                    hintText: 'Password',
                                    inputType: TextInputType.visiblePassword,
                                    icon: Icon(Icons.password_outlined),
                                    validate: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please Enter the Password";
                                      } else if (value.length <= 5) {
                                        return "Password must be more than 5 characters";
                                      }
                                      return null;
                                    },
                                    changedValue: (String? value) {
                                      context.read<FirebaseAuthBloc>().add(
                                        CredentialGiven(password: value!),
                                      );
                                      return null;
                                    },
                                    trailingWidget: InkWell(
                                      borderRadius: BorderRadius.circular(30),
                                      radius: 10,
                                      splashColor: AppColor.confirmColor,
                                      onTap: () {
                                        context.read<FirebaseAuthBloc>().add(
                                          HidePassword(),
                                        );
                                      },
                                      child: Icon(
                                        firebaseAuthState.showPassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                      ),
                                    ),
                                  ),
                                  firebaseAuthState.isSignInPage
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  RouteNames.forgotPasswordPage,
                                                );
                                              },
                                              child: CustomText(
                                                text: "Forgot Password",
                                                textColor: AppColor
                                                    .signInAndSignUpPageThemeColor,
                                              ),
                                            ),
                                          ],
                                        )
                                      : SizedBox.shrink(),
                                  SizedBox(height: 20),
                                  firebaseAuthState.isLoading == true
                                      ? CircularProgressIndicator(
                                          color: darkThemeState.darkTheme
                                              ? AppColor
                                                    .circularProgressDarkColor
                                              : AppColor
                                                    .circularProgressLightColor,
                                        )
                                      : CustomButton(
                                          buttonText:
                                              firebaseAuthState.isSignInPage ==
                                                  true
                                              ? "Log In"
                                              : "Sign Up",
                                          width: MediaQuery.of(
                                            context,
                                          ).size.width,
                                          callback: () async {
                                            bool isValidate = loginFormKey
                                                .currentState!
                                                .validate();
                                            if (isValidate) {
                                              context
                                                  .read<FirebaseAuthBloc>()
                                                  .add(AuthenticateUser());
                                            }
                                          },
                                          backgroundColor: AppColor
                                              .signInAndSignUpPageThemeColor,
                                        ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomText(
                                        text:
                                            firebaseAuthState.isSignInPage ==
                                                true
                                            ? "Don't have an account?"
                                            : "Already have an account?",
                                        textColor: darkThemeState.darkTheme
                                            ? AppColor.textDarkThemeColor
                                            : AppColor.textLightThemeColor,
                                        textSize: 20,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          firebaseAuthState.isSignInPage
                                              ? context
                                                    .read<FirebaseAuthBloc>()
                                                    .add(
                                                      IsSignInPage(
                                                        isSignInPage: false,
                                                      ),
                                                    )
                                              : context
                                                    .read<FirebaseAuthBloc>()
                                                    .add(
                                                      IsSignInPage(
                                                        isSignInPage: true,
                                                      ),
                                                    );
                                        },
                                        child: CustomText(
                                          textColor: Colors.blue,
                                          text:
                                              firebaseAuthState.isSignInPage ==
                                                  true
                                              ? "Sign Up"
                                              : "Log In",
                                          textSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
