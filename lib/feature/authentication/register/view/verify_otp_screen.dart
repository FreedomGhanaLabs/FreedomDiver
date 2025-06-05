import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freedomdriver/core/constants/auth.dart';
import 'package:freedomdriver/feature/authentication/login/cubit/login_cubit.dart';
import 'package:freedomdriver/feature/authentication/login/view/login_form_screen.dart';
import 'package:freedomdriver/feature/authentication/register/cubit/verify_otp_cubit.dart';
import 'package:freedomdriver/feature/driver/cubit/driver_cubit.dart';
import 'package:freedomdriver/feature/driver/extension.dart';
import 'package:freedomdriver/feature/main_activity/main_activity_screen.dart';
import 'package:freedomdriver/shared/api/api_controller.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/shared/widgets/primary_button.dart';
import 'package:freedomdriver/shared/widgets/toaster.dart';
import 'package:freedomdriver/utilities/hive/token.dart';
import 'package:freedomdriver/utilities/routes_params.dart';
import 'package:freedomdriver/utilities/ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../shared/api/fcm.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});
  static const routeName = '/verify_otp';

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _otpFormKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _otpFocusNode = FocusNode();
  final apiController = ApiController('auth');

  Timer? _timer;
  int _start = 10;
  @override
  void initState() {
    super.initState();
    _otpController.addListener(() {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _otpFocusNode.requestFocus();
    });
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_start > 0) {
          _start--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final loginFormCubit = BlocProvider.of<LoginFormCubit>(context);
    final args = getRouteParams(context);
    final type = args['type'] as String?;

    final isPhoneUpdate = type == 'phoneUpdate';
    final isLogin = type == 'login';
    final isEmailUpdate = type == 'emailUpdate';

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<VerifyOtpCubit, VerifyOtpState>(
        listener: (context, state) {
          if (state.isVerified) {
            Navigator.pushNamed(context, LoginFormScreen.routeName);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: whiteSpace,
                vertical: smallWhiteSpace,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DecoratedBackButton(),
                  const VSpace(normalWhiteSpace),
                  const Text(
                    'Enter Code',
                    style: TextStyle(
                      fontSize: emphasisText,
                      color: Colors.black,
                    ),
                  ),
                  const VSpace(extraSmallWhiteSpace),
                  Text(
                    'A verification code was sent to',
                    style: TextStyle(
                      fontSize: paragraphText,
                      color: Colors.black.withAlpha(127),
                    ),
                  ),
                  Text(
                    '${isPhoneUpdate
                        ? context.driver?.phone
                        : isEmailUpdate
                        ? context.driver?.email
                        : loginFormCubit.state.email}',
                    style: TextStyle(
                      fontSize: normalText.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const VSpace(whiteSpace),
                  Form(
                    key: _otpFormKey,
                    child: PinCodeTextField(
                      focusNode: _otpFocusNode,
                      appContext: context,
                      textStyle: const TextStyle(
                        fontSize: normalText,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      onCompleted: (val) {
                        if (mounted) {
                          _onVerifyPressed(context, loginFormCubit, type);
                        }
                      },
                      length: 6,
                      obscureText: true,
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5).w,
                        fieldHeight: 45.h,
                        fieldWidth: 40.w,
                        activeFillColor: Colors.white,
                        inactiveFillColor: fillColor,
                        activeColor: thickFillColor,
                        inactiveColor: const Color(0x21F59E0B),
                        selectedColor: thickFillColor,
                        selectedFillColor: fillColor,
                        borderWidth: 1,
                        activeBorderWidth: 1,
                      ),
                      cursorColor: Colors.black,
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      boxShadows: const [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        ),
                      ],
                      onChanged: (value) {},
                      beforeTextPaste: (text) {
                        return true;
                      },
                    ),
                  ),
                  const SizedBox(height: smallWhiteSpace),
                  if (_start != 0)
                    Text(
                      'Resend code in 0:$_start',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  else if (_start == 0)
                    InkWell(
                      onTap: () {
                        _start = 10;
                        _startTimer();

                        apiController.post(
                          context,
                          'resend-verification',
                          {
                            'identifier': loginFormCubit.state.email,
                            'type': 'email',
                            'purpose': isLogin ? 'login' : 'registration',
                          },
                          (success, data) {
                            if (success) {
                              showToast(
                                context,
                                'Code Resent',
                                data['message'].toString(),
                                toastType: ToastType.success,
                              );
                            }
                          },
                        );
                      },
                      child: const Text(
                        'Resend Code',
                        style: TextStyle(
                          fontSize: paragraphText,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  const VSpace(whiteSpace),
                  FreedomButton(
                    backGroundColor: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                    width: double.infinity,
                    title: isLoading ? 'Verifying' : 'Verify',
                    onPressed:
                        () => _onVerifyPressed(context, loginFormCubit, type),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    // _otpController.dispose();
    // _otpFocusNode.dispose();
    super.dispose();
  }

  void _onVerifyPressed(
    BuildContext context,
    LoginFormCubit loginFormCubit,
    String? type,
  ) {
    final verificationCode = _otpController.text.trim();
    final isLoginType = type == login;
    // final isRegisterType = type == register;
    final isEmailUpdateType = type == emailUpdate;
    final isPhoneUpdateType = type == phoneUpdate;
    if (_otpFormKey.currentState!.validate()) {
      if (verificationCode.isEmpty) {
        return;
      }

      if (isEmailUpdateType) {
        context.read<DriverCubit>().verifyEmailUpdate(
          context,
          verificationCode,
        );
        return;
      }

      if (isPhoneUpdateType) {
        context.read<DriverCubit>().verifyPhoneUpdate(
          context,
          verificationCode,
        );
        return;
      }

      apiController.post(
        context,
        isLoginType ? 'login/email/verify' : 'verify-registration',
        {
          'email': loginFormCubit.state.email,
          'verificationCode': verificationCode,
        },
        (success, data) async {
          setState(() {
            isLoading = false;
          });
          if (success) {
            final token = data['data']['token'].toString();
            addTokenToHive(token).then((onValue) async {
              await FCMService().registerFCM(context);
              context.read<LoginFormCubit>().setEmail('');
              Navigator.pushNamedAndRemoveUntil(
                context,
                MainActivityScreen.routeName,
                (route) => false,
              );
            });
          }
        },
        showOverlay: true,
      );
    }
  }
}

class DecoratedBackButton extends StatelessWidget {
  const DecoratedBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        height: 38.09,
        width: 38.09,
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.86, 8.86, 9.74, 9.74),
          child: SvgPicture.asset('assets/app_icons/back_button.svg'),
        ),
      ),
    );
  }
}
