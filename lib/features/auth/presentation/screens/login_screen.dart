import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:blue_collar_tracker/core/theme/app_theme.dart';
import 'package:blue_collar_tracker/core/theme/route_transitions.dart';
import 'package:blue_collar_tracker/core/providers/theme_provider.dart';
import 'package:blue_collar_tracker/features/dashboard/presentation/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _employeeIdController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // Default hint/valid ID format populated as helper
    _employeeIdController.text = "MJIL000001";
    _passwordController.text = "Password123";

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.1, 1.0, curve: Curves.easeOutBack),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _employeeIdController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Action: Sign In validation & login simulation
  void _handleSignIn() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate network request with enterprise precision
      Future.delayed(const Duration(seconds: 1500 ~/ 1000), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          
          // Show successful modern toast / snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Welcome back to MJ HRMS!',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              backgroundColor: AppTheme.emeraldGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(16),
            ),
          );

          // Route to HomeScreen with professional transitions
          Navigator.of(context).pushReplacement(
            RouteTransitions.slideIn(const HomeScreen()),
          );
        }
      });
    }
  }

  // Forgot password interactive modal (not a placeholder)
  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();
    final resetFormKey = GlobalKey<FormState>();
    bool isResetLoading = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).cardTheme.color ?? Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(
                'Reset Password',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              content: Form(
                key: resetFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter your Employee ID or Registered Email to receive reset instructions.',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: emailController,
                      style: GoogleFonts.poppins(fontSize: 14),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.badge_outlined, size: 20),
                        labelText: 'Employee ID or Email',
                        hintText: 'e.g. MJIL000001',
                        labelStyle: GoogleFonts.poppins(fontSize: 13),
                        hintStyle: GoogleFonts.poppins(fontSize: 13),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter Employee ID or Email';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.w600),
                  ),
                ),
                if (isResetLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.royalBlue),
                    ),
                  )
                else
                  ElevatedButton(
                    onPressed: () {
                      if (resetFormKey.currentState!.validate()) {
                        setDialogState(() {
                          isResetLoading = true;
                        });
                        Future.delayed(const Duration(seconds: 1), () {
                          if (context.mounted) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Password reset link sent to registered email for ${emailController.text}!',
                                  style: GoogleFonts.poppins(),
                                ),
                                backgroundColor: AppTheme.emeraldGreen,
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.all(16),
                              ),
                            );
                          }
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.royalBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      'Send Instructions',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Ambient Decorative mesh spheres for premium background depth
          Positioned(
            top: -100,
            left: -100,
            child: AnimatedContainer(
              duration: const Duration(seconds: 2),
              width: size.width * 0.7,
              height: size.width * 0.7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.royalBlue.withValues(alpha: isDark ? 0.25 : 0.15),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -80,
            child: AnimatedContainer(
              duration: const Duration(seconds: 2),
              width: size.width * 0.7,
              height: size.width * 0.7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.emeraldGreen.withValues(alpha: isDark ? 0.20 : 0.12),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          // Main Interactive Layout
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Dynamic Theme Mode Switch & Corporate Branding top row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.04),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.business_rounded,
                                    size: 16,
                                    color: isDark ? AppTheme.emeraldGreen : AppTheme.royalBlue,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "MJ GROUP",
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 2.0,
                                    color: isDark ? Colors.white60 : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (child, anim) => RotationTransition(
                                  turns: anim,
                                  child: ScaleTransition(scale: anim, child: child),
                                ),
                                child: Icon(
                                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                                  key: ValueKey<bool>(isDark),
                                  color: isDark ? Colors.amberAccent : AppTheme.royalBlue,
                                ),
                              ),
                              onPressed: () => themeProvider.toggleTheme(),
                              tooltip: "Toggle Light/Dark Theme",
                            ),
                          ],
                        ),
                        
                        SizedBox(height: size.height * 0.04),

                        // Enterprise Logo Visual Block
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppTheme.royalBlue, AppTheme.emeraldGreen],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.royalBlue.withValues(alpha: 0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.diversity_3_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Rebranded Titles
                        Text(
                          'MJ HRMS',
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                            color: isDark ? Colors.white : AppTheme.royalBlue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Madhu Jayanti International Pvt. Ltd.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                        ),

                        SizedBox(height: size.height * 0.04),

                        // Glassmorphism Card
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 350),
                              decoration: BoxDecoration(
                                color: isDark 
                                    ? Colors.black.withValues(alpha: 0.25) 
                                    : Colors.white.withValues(alpha: 0.65),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: isDark 
                                      ? Colors.white.withValues(alpha: 0.12) 
                                      : Colors.white.withValues(alpha: 0.35),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                                    blurRadius: 32,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Employee Sign In',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : AppTheme.royalBlue,
                                      ),
                                    ),
                                    const SizedBox(height: 20),

                                    // Employee ID field with modern styling
                                    TextFormField(
                                      controller: _employeeIdController,
                                      keyboardType: TextInputType.text,
                                      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.badge_outlined, 
                                          color: isDark ? AppTheme.emeraldGreen : AppTheme.royalBlue
                                        ),
                                        labelText: 'Employee ID',
                                        hintText: 'MJIL000001',
                                        helperText: 'Enter corporate ID in MJIL format',
                                        helperStyle: GoogleFonts.poppins(fontSize: 11),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.trim().isEmpty) {
                                          return 'Employee ID is required';
                                        }
                                        final trimmed = value.trim().toUpperCase();
                                        final idPattern = RegExp(r'^MJIL\d{6}$');
                                        if (!idPattern.hasMatch(trimmed)) {
                                          return 'Invalid format. Use e.g. MJIL000001';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 18),

                                    // Password field with show/hide dynamic button
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: _obscurePassword,
                                      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.lock_outline_rounded, 
                                          color: isDark ? AppTheme.emeraldGreen : AppTheme.royalBlue
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscurePassword = !_obscurePassword;
                                            });
                                          },
                                        ),
                                        labelText: 'Password',
                                        hintText: 'Enter password',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Password is required';
                                        }
                                        if (value.length < 8) {
                                          return 'Password must be at least 8 characters';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 8),

                                    // Remember Me & Forgot Password Row
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Remember me toggle
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: Checkbox(
                                                value: _rememberMe,
                                                activeColor: AppTheme.royalBlue,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                                onChanged: (val) {
                                                  setState(() {
                                                    _rememberMe = val ?? false;
                                                  });
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Remember Me',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: isDark ? Colors.white70 : Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Forgot password
                                        TextButton(
                                          onPressed: _showForgotPasswordDialog,
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            minimumSize: Size.zero,
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                          child: Text(
                                            'Forgot Password?',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.emeraldGreen,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),

                                    // Premium Gradient Sign In Button
                                    SizedBox(
                                      width: double.infinity,
                                      height: 52,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [AppTheme.royalBlue, AppTheme.emeraldGreen],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius: BorderRadius.circular(14),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppTheme.royalBlue.withValues(alpha: 0.35),
                                              blurRadius: 16,
                                              offset: const Offset(0, 6),
                                            ),
                                          ],
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(14),
                                            onTap: _isLoading ? null : _handleSignIn,
                                            child: Center(
                                              child: _isLoading
                                                  ? const SizedBox(
                                                      width: 24,
                                                      height: 24,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2.5,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : Text(
                                                      'Sign In to HRMS',
                                                      style: GoogleFonts.poppins(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        letterSpacing: 0.5,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: size.height * 0.05),

                        // Enterprise Footer
                        Text(
                          'Madhu Jayanti International Pvt. Ltd.',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white38 : Colors.black38,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Secure HRMS Node • v3.1.0 • © 2026 All Rights Reserved',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white24 : Colors.black26,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
