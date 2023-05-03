import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/auth_api.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';

import '../../../common/common.dart';
import '../../../common/loading_page.dart';
import '../../../constants/constants.dart';
import '../../../theme/theme.dart';
import '../widgets/auth_field.dart';
import 'login_view.dart';

class SignupView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignupView(),
      );
  const SignupView({Key? key}) : super(key: key);

  @override
  ConsumerState<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends ConsumerState<SignupView> {
  final appBar = UIConstants.appBar();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void onSignUp() {
    ref.read(authControllerProvider.notifier).signUp(
          email: emailController.text,
          password: passwordController.text,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: appBar,
      body: isLoading
          ? const Loader()
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      AuthField(controller: emailController, hintText: 'Email'),
                      const SizedBox(height: 25),
                      AuthField(
                          controller: passwordController, hintText: 'Password'),
                      const SizedBox(height: 40),
                      Align(
                        alignment: Alignment.topRight,
                        child: RoundedSmallButton(
                          onPressed: onSignUp,
                          label: 'Done',
                        ),
                      ),
                      const SizedBox(height: 40),
                      RichText(
                        text: TextSpan(
                            text: "Already have an account? ",
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                            children: [
                              TextSpan(
                                text: 'Login',
                                style: const TextStyle(
                                  color: Pallette.blueColor,
                                  fontSize: 16.0,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      LoginView.route(),
                                    );
                                  },
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
