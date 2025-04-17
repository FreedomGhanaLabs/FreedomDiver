import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freedom_driver/feature/authentication/login/view/login_form_screen.dart';
import 'package:freedom_driver/feature/authentication/register/cubit/registeration_cubit.dart';
import 'package:freedom_driver/feature/authentication/register/cubit/verify_otp_cubit.dart';
import 'package:freedom_driver/feature/main_activity/main_activity_screen.dart';
import 'package:freedom_driver/shared/api/api_controller.dart';
import 'package:freedom_driver/shared/app_config.dart';
import 'package:freedom_driver/shared/helpers/routes_params.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';
import 'package:freedom_driver/shared/widgets/primary_button.dart';
import 'package:freedom_driver/shared/widgets/toaster.dart';
import 'package:freedom_driver/utilities/hive/token.dart';
import 'package:freedom_driver/utilities/ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

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
    final formCubit = BlocProvider.of<RegistrationFormCubit>(context);
    final args = getRouteParams(context);
    final type = args['type'] as String?;
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
                children: <Widget>[
                  const DecoratedBackButton(),
                  const VSpace(35.45),
                  Text(
                    'Enter Code',
                    style: GoogleFonts.poppins(
                      fontSize: 29.02,
                      color: Colors.black,
                    ),
                  ),
                  const VSpace(5),
                  Text(
                    'An SMS code was sent to',
                    style: GoogleFonts.poppins(
                      fontSize: paragraphText,
                      color: Colors.black.withAlpha(127),
                    ),
                  ),
                  const VSpace(extraSmallWhiteSpace),
                  Text(
                    '${formCubit.state.email}',
                    style: GoogleFonts.poppins(
                      fontSize: normalText,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const VSpace(17),
                  Form(
                    key: _otpFormKey,
                    child: PinCodeTextField(
                      focusNode: _otpFocusNode,
                      appContext: context,
                      textStyle: GoogleFonts.poppins(
                        fontSize: 19.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      onCompleted: (val) {
                        if (mounted) {}
                      },
                      length: 6,
                      obscureText: true,
                      obscuringCharacter: '*',
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
                  const SizedBox(
                    height: 21,
                  ),
                  if (_start != 0)
                    Text(
                      'Resend code in 0:$_start',
                      style: GoogleFonts.poppins(
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
                            'identifier': formCubit.state.email,
                            'type': 'email',
                            'purpose': 'registration',
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
                      child: Text(
                        'Resend Code',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
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
                    onPressed: () => _onVerifyPressed(context, formCubit, type),
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
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  void _onVerifyPressed(
    BuildContext context,
    RegistrationFormCubit formCubit,
    String? type,
  ) {
    final isLoginType = type == 'login';
    if (_otpFormKey.currentState!.validate()) {
      // context.read<VerifyOtpCubit>().verifyOtp(_otpController.text);
      setState(() {
        isLoading = true;
      });
      apiController.post(
        context,
        isLoginType ? 'login/email/verify' : 'verify-registration',
        {
          'email': formCubit.state.email,
          'verificationCode': _otpController.text.trim(),
        },
        (success, data) {
          setState(() {
            isLoading = false;
          });
          if (success) {
            final token = data['data']['token'].toString();
            debugPrint(token);
            addTokenToHive(token).then(
              (onValue) => {
                Navigator.pushReplacementNamed(
                  context,
                  MainActivityScreen.routeName,
                ),
              },
            );
          }
        },
      );
    }
  }
}

class DecoratedBackButton extends StatelessWidget {
  const DecoratedBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        height: 38.09,
        width: 38.09,
        decoration:
            const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.86, 8.86, 9.74, 9.74),
          child: SvgPicture.asset('assets/app_icons/back_button.svg'),
        ),
      ),
    );
  }
}
