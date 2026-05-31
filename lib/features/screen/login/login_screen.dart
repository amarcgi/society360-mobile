import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/theme/AppColors.dart';
import '../../../../../../injection.dart';


import '../../../../../../core/shared/index.dart';
import '../../../core/router/app_router.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';
import 'bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {

  final _mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedRole = 'RESIDENT';
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final _roles = [
    ('RESIDENT',       'Resident',       Icons.home_rounded),
    ('SOCIETY_ADMIN',  'Society Admin',  Icons.admin_panel_settings_rounded),
    ('SECURITY_GUARD', 'Security Guard', Icons.security_rounded),
  ];
  late final AuthBloc _authBloc;
  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _authBloc,
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpRequestSuccess) {
            context.push(
              AppRouter.otp_screen,
              extra: {
                'mobile': state.mobile,
                'role': _selectedRole,
              },
            );
           /* Navigator.push(
              context,
              _slideRoute(OtpScreen(
                mobile: state.mobile,
                role: _selectedRole,
              )),
            );*/
          } else if (state is OtpRequestFailure) {
            _showError(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is OtpRequestLoading;
          return Scaffold(
            body: Stack(
              children: [

                // ── Gradient Background ─────────
                Container(
                  height: MediaQuery.of(context)
                      .size.height * 0.45,
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                ),

                // ── Wave Decoration ─────────────
                Positioned(
                  top: MediaQuery.of(context)
                      .size.height * 0.38,
                  left: 0,
                  right: 0,
                  child: CustomPaint(
                    painter: _WavePainter(),
                    child: const SizedBox(height: 60),
                  ),
                ),

                // ── Main Content ────────────────
                SafeArea(
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: SlideTransition(
                      position: _slideAnim,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets
                            .all(24),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [

                            const SizedBox(height: 40),

                            // ── Logo ───────────
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white
                                    .withOpacity(0.15),
                                borderRadius:
                                BorderRadius
                                    .circular(16),
                              ),
                              child: const Icon(
                                Icons.apartment_rounded,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),

                            const SizedBox(height: 24),

                            // ── Title ──────────
                            const Text(
                              'Society360',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight:
                                FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Smart Living, Connected Community',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white
                                    .withOpacity(0.75),
                              ),
                            ),

                            const SizedBox(height: 60),

                            // ── Card ───────────
                            Container(
                              padding:
                              const EdgeInsets
                                  .all(28),
                              decoration:
                              BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius
                                    .circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors
                                        .primary
                                        .withOpacity(0.08),
                                    blurRadius: 40,
                                    offset:
                                    const Offset(
                                        0, 10),
                                  ),
                                ],
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [

                                    // Title
                                    const Text(
                                      'Welcome back',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight:
                                        FontWeight.w700,
                                        color: AppColors
                                            .textPrimary,
                                      ),
                                    ),
                                    const SizedBox(
                                        height: 4),
                                    const Text(
                                      'Enter your mobile to continue',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors
                                            .textSecondary,
                                      ),
                                    ),

                                    const SizedBox(
                                        height: 28),

                                    // Mobile Field
                                    /*TextFormField(
                                      controller:
                                      _mobileController,
                                      keyboardType:
                                      TextInputType
                                          .phone,
                                      maxLength: 10,
                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .digitsOnly,
                                      ],
                                      validator: (v) {
                                        if (v == null
                                            || v.length != 10)
                                          return 'Enter valid 10-digit mobile';
                                        if (!RegExp(
                                            r'^[6-9]\d{9}$')
                                            .hasMatch(v))
                                          return 'Must start with 6-9';
                                        return null;
                                      },
                                      decoration:
                                      InputDecoration(
                                        counterText: '',
                                        labelText:
                                        'Mobile Number',
                                        prefixIcon:
                                        const Padding(
                                          padding:
                                          EdgeInsets
                                              .only(
                                              left: 16,
                                              right: 8),
                                          child: Row(
                                            mainAxisSize:
                                            MainAxisSize
                                                .min,
                                            children: [
                                              Text(
                                                '+91',
                                                style: TextStyle(
                                                  color: AppColors
                                                      .textPrimary,
                                                  fontWeight:
                                                  FontWeight
                                                      .w600,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              SizedBox(
                                                  width: 8),
                                              VerticalDivider(
                                                  width: 1),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),*/
                                    AppTextField(
                                      label: 'Mobile Number',
                                      controller:
                                      _mobileController,
                                      keyboardType:
                                      TextInputType
                                          .phone,
                                      maxLength: 10,
                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .digitsOnly,
                                      ],
                                      validator: (v) {
                                        if (v == null
                                            || v.length != 10)
                                          return 'Enter valid 10-digit mobile';
                                        if (!RegExp(
                                            r'^[6-9]\d{9}$')
                                            .hasMatch(v))
                                          return 'Must start with 6-9';
                                        return null;
                                      },
                                      prefixText: '+91 ',
                                    ),
                                    const SizedBox(
                                        height: 16),

                                    // Role Selector
                                    const Text(
                                      'Login as',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight:
                                        FontWeight.w600,
                                        color: AppColors
                                            .textSecondary,
                                      ),
                                    ),
                                    const SizedBox(
                                        height: 10),
                                    Row(
                                      children: _roles
                                          .map((r) =>
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets
                                                  .only(right: 8),
                                              child: _RoleChip(
                                                label: r.$2,
                                                icon: r.$3,
                                                selected:
                                                _selectedRole == r.$1,
                                                onTap: () => setState(
                                                        () => _selectedRole = r.$1),
                                              ),
                                            ),
                                          ),
                                      ).toList(),
                                    ),

                                    const SizedBox(height: 28),
                                    // Send OTP Button
                                    SizedBox(
                                      width: double.infinity,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          gradient: AppColors
                                              .primaryGradient,
                                          borderRadius:
                                          BorderRadius
                                              .circular(14),
                                        ),
                                        child: /*ElevatedButton(
                                          onPressed:
                                          isLoading
                                              ? null
                                              : () {
                                            if (_formKey
                                                .currentState!
                                                .validate()) {
                                              context
                                                  .read<AuthBloc>()
                                                  .add(RequestOtpEvent(
                                                  _mobileController
                                                      .text.trim()));
                                            }
                                          },
                                          style: ElevatedButton
                                              .styleFrom(
                                            backgroundColor:
                                            Colors.transparent,
                                            shadowColor:
                                            Colors.transparent,
                                          ),
                                          child: isLoading
                                              ? const SizedBox(
                                            height: 22,
                                            width: 22,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2.5,
                                                color: Colors.white),
                                          )
                                              : const Text('Send OTP'),
                                        )*/AppButton(label: 'Send OTP', onPressed: (){
                                          if (_formKey
                                              .currentState!
                                              .validate()) {
                                            _authBloc
                                                .add(RequestOtpEvent(
                                                _mobileController
                                                    .text.trim()));
                                          }
                                        }),
                                      ),
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showError(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Route _slideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: anim,
            curve: Curves.easeOutCubic,
          )),
          child: child,
        );
      },
    );
  }
}

// ── Role Chip Widget ─────────────────────────────
class _RoleChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _RoleChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
            vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.08)
              : AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon,
                size: 22,
                color: selected
                    ? AppColors.primary
                    : AppColors.textHint),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected
                    ? FontWeight.w600
                    : FontWeight.w400,
                color: selected
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Wave Painter ─────────────────────────────────
class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF5F7FA)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 40);
    path.quadraticBezierTo(
        size.width * 0.25, 0,
        size.width * 0.5, 20);
    path.quadraticBezierTo(
        size.width * 0.75, 40,
        size.width, 10);
    path.lineTo(size.width, 60);
    path.lineTo(0, 60);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
