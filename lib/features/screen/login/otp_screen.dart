// lib/features/auth/presentation/screens/otp_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import '../../../../../../core/theme/AppColors.dart';
import '../../../../../../injection.dart';
import '../../../core/router/app_router.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';
import 'bloc/auth_state.dart';
import 'package:go_router/go_router.dart';

class OtpScreen extends StatefulWidget {
  final String mobile;
  final String role;

  const OtpScreen({
    super.key,
    required this.mobile,
    required this.role,
  });

  @override
  State<OtpScreen> createState() =>
      _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>
    with SingleTickerProviderStateMixin {

  final _otpController = TextEditingController();
  final _pinputFocus   = FocusNode();
  int _resendSeconds   = 30;
  Timer? _timer;
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
    _animController.forward();
    _startTimer();
  }

  void _startTimer() {
    _resendSeconds = 30;
    _timer = Timer.periodic(
        const Duration(seconds: 1), (_) {
      if (_resendSeconds > 0) {
        setState(() => _resendSeconds--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    _otpController.dispose();
    _pinputFocus.dispose();
    super.dispose();
  }

  String get _maskedMobile {
    final m = widget.mobile;
    return '${m.substring(0,2)}******${m.substring(8)}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _authBloc,
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpVerifySuccess) {

            context.push(AppRouter.dashboard);

            /*context.go(
              AppRouter.Profile,
              extra: {
                'mobile':       '8147574889',
                'societyId':    'societyId',
                'buildingId':   'buildingId',
                'flatId':       'flatId',
                'flatNumber':   'flatNumber',
                'buildingName': 'buildingName',
                'societyName':  'societyName',
              },
            );*/


            // ✅ Navigate to home based on role
            /*context.go('/Profile_screen');*/
            /*Navigator.pushNamedAndRemoveUntil(
                context, '/home', (_) => false);*/
          } else if (state is OtpVerifyFailure) {
            _showError(context, state.message);
            _otpController.clear();
          } else if (state is OtpResendSuccess) {
            _showSuccess(context, 'OTP resent!');
            _startTimer();
          }
        },
        builder: (context, state) {
          final isLoading = state is OtpVerifyLoading;
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: const Text('OTP_Verification'),
              // Force back button even if framework thinks there is no stack history
              leading: context.canPop()
                  ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              )
                  : null,
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 16),

                    // ── Icon ───────────────────
                    ScaleTransition(
                      scale: _scaleAnim,
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          gradient:
                          AppColors.accentGradient,
                          borderRadius:
                          BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent
                                  .withOpacity(0.35),
                              blurRadius: 20,
                              offset: const Offset(
                                  0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.lock_outline_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Title ──────────────────
                    const Text(
                      'Verify OTP',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                        children: [
                          const TextSpan(
                              text: 'Code sent to  '),
                          TextSpan(
                            text: '+91 $_maskedMobile',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 48),

                    // ── OTP Input ──────────────
                    Center(
                      child: Pinput(
                        controller: _otpController,
                        focusNode: _pinputFocus,
                        length: 6,
                        autofocus: true,
                        onCompleted: (_) =>
                            _verify(context),
                        defaultPinTheme: PinTheme(
                          width: 52,
                          height: 58,
                          textStyle: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            fontFamily: 'Sora',
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceAlt,
                            borderRadius:
                            BorderRadius.circular(14),
                            border: Border.all(
                                color: AppColors.border),
                          ),
                        ),
                        focusedPinTheme: PinTheme(
                          width: 52,
                          height: 58,
                          textStyle: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            fontFamily: 'Sora',
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.accent,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accent
                                    .withOpacity(0.2),
                                blurRadius: 12,
                                offset:
                                const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // ── Verify Button ──────────
                    SizedBox(
                      width: double.infinity,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: isLoading
                              ? const LinearGradient(
                              colors: [
                                Colors.grey,
                                Colors.grey
                              ])
                              : AppColors.primaryGradient,
                          borderRadius:
                          BorderRadius.circular(14),
                        ),
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () => _verify(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: isLoading
                              ? const SizedBox(
                            height: 22, width: 22,
                            child:
                            CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                              : const Text('Verify & Continue'),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Resend ─────────────────
                    Center(
                      child: _resendSeconds > 0
                          ? RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              fontSize: 14),
                          children: [
                            const TextSpan(
                              text: 'Resend OTP in ',
                              style: TextStyle(
                                  color: AppColors
                                      .textSecondary),
                            ),
                            TextSpan(
                              text:
                              '$_resendSeconds s',
                              style: const TextStyle(
                                fontWeight:
                                FontWeight.w600,
                                color: AppColors
                                    .primary,
                              ),
                            ),
                          ],
                        ),
                      )
                          : TextButton(
                        onPressed: () =>
                            context
                                .read<AuthBloc>()
                                .add(ResendOtpEvent(
                                widget.mobile)),
                        child: const Text(
                          'Resend OTP',
                          style: TextStyle(
                            fontWeight:
                            FontWeight.w600,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _verify(BuildContext context) {
    final otp = _otpController.text.trim();
    if (otp.length != 6) return;
    _authBloc.add(VerifyOtpEvent(
      mobile: widget.mobile,
      otp: otp,
      role: widget.role,
    ));
  }

  void _showError(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: AppColors.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ));
  }

  void _showSuccess(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: AppColors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ));
  }
}
