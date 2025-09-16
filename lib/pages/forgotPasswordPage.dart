import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../AppColors/app_colors.dart';
import '../bloc/dark_theme_mode/dark_theme_bloc_events_state.dart';
import '../bloc/firebase_auth/firebase_auth_bloc_events_states.dart';
import '../custom_widgets/import_all_custom_widgets.dart';
import '../routes/all_routes.dart';

class ForgotPassWordPage extends StatefulWidget {
  const ForgotPassWordPage({super.key});
  @override
  State<ForgotPassWordPage> createState() => ForgotPassWordPageState();
}

class ForgotPassWordPageState extends State<ForgotPassWordPage> {
  GlobalKey<FormState> resetPasswordKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final message = ScaffoldMessenger.of(context);
    const double maxFormWidth = 500;
    return Scaffold(
      body: BlocBuilder<DarkThemeBloc, DarkThemeState>(
        builder: (context, darkThemeState) {
          return BlocBuilder<FirebaseAuthBloc, FirebaseAuthState>(
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
                                  text: "Reset Password",
                                  textBoldness: FontWeight.bold,
                                  textColor: AppColor.whiteColor,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: resetPasswordKey,
                              child: Column(
                                children: [
                                  CustomText(
                                    text: "Make sure your Email-ID is correct",
                                  ),
                                  SizedBox(height: 20),
                                  CustomFormTextField(
                                    isfieldEnabeled:
                                        firebaseAuthState.isForgotPassMailSent
                                        ? false
                                        : true,
                                    hintText: 'Email-ID',
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
                                  SizedBox(height: 30),
                                  !firebaseAuthState.isForgotPassMailSent
                                      ? CustomButton(
                                          buttonText: "Reset",
                                          width: MediaQuery.of(
                                            context,
                                          ).size.width,
                                          callback: () async {
                                            bool isValidate = resetPasswordKey
                                                .currentState!
                                                .validate();
                                            if (isValidate) {
                                              context
                                                  .read<FirebaseAuthBloc>()
                                                  .add(
                                                    ForgotPasswordMailSentEvent(),
                                                  );
                                              context
                                                  .read<FirebaseAuthBloc>()
                                                  .add(
                                                    IsForgotPassMailSent(
                                                      isMailSent: true,
                                                    ),
                                                  );
                                              message.showSnackBar(
                                                SnackBar(
                                                  width: kIsWeb
                                                      ? 450
                                                      : screenWidth,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  backgroundColor: AppColor
                                                      .signInAndSignUpPageThemeColor,
                                                  showCloseIcon: true,
                                                  duration: Duration(
                                                    seconds: 10,
                                                  ),
                                                  content: CustomText(
                                                    text:
                                                        "Password reset email sent to ${firebaseAuthState.email} \nPlease check your Inbox/Spam folder",
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          backgroundColor: Colors.blue.shade800,
                                        )
                                      : SizedBox.shrink(),
                                  firebaseAuthState.isForgotPassMailSent
                                      ? TextButton(
                                          onPressed: () {
                                            context
                                                .read<FirebaseAuthBloc>()
                                                .add(
                                                  IsForgotPassMailSent(
                                                    isMailSent: false,
                                                  ),
                                                );
                                            Navigator.pushNamed(
                                              context,
                                              RouteNames.userAuthenticationPage,
                                            );
                                          },
                                          child: CustomText(
                                            textColor: Colors.blue,
                                            text: "Go back to Log In page",
                                            textSize: 20,
                                          ),
                                        )
                                      : SizedBox.shrink(),
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
