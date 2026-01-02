import 'package:flutter/material.dart';
import 'package:showroom_mobil/services/api_service.dart';
import 'package:showroom_mobil/services/auth_service.dart';
import 'package:showroom_mobil/screens/home_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:showroom_mobil/constants/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    if (await AuthService.isLoggedIn()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      EasyLoading.show(status: 'Logging in...');

      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      try {
        final userData = await ApiService.login(username, password);

        if (userData != null) {
          await AuthService.saveUserData(
            userData['id'],
            userData['username'],
            userData['isAdmin'],
          );

          EasyLoading.showSuccess('Login successful!');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          EasyLoading.showError('Invalid username or password');
        }
      } catch (e) {
        print('Login error: $e');
        EasyLoading.showError('Connection error. Please try again.');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          // Background Pattern
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryBlue.withOpacity(0.03),
                    AppColors.backgroundLight,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo/Header
                    Container(
                      margin: const EdgeInsets.only(bottom: 40),
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryBlue.withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.directions_car,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'PREMIUM SHOWROOM',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.navyBlue,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Experience Luxury Automotive',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.grey600,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Login Card
                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Username Field
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              child: TextFormField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  labelStyle:
                                      TextStyle(color: AppColors.grey600),
                                  prefixIcon: Icon(Icons.person,
                                      color: AppColors.primaryBlue),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: AppColors.grey300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: AppColors.primaryBlue, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: AppColors.grey50,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 16,
                                  ),
                                ),
                                style: TextStyle(color: AppColors.grey900),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter username';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            // Password Field
                            Container(
                              margin: const EdgeInsets.only(bottom: 30),
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle:
                                      TextStyle(color: AppColors.grey600),
                                  prefixIcon: Icon(Icons.lock,
                                      color: AppColors.primaryBlue),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: AppColors.grey500,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: AppColors.grey300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: AppColors.primaryBlue, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: AppColors.grey50,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 16,
                                  ),
                                ),
                                style: TextStyle(color: AppColors.grey900),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter password';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            // Login Button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryBlue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                  shadowColor:
                                      AppColors.primaryBlue.withOpacity(0.3),
                                ),
                                child: _isLoading
                                    ? SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.login, size: 20),
                                          const SizedBox(width: 12),
                                          Text(
                                            'ACCESS SHOWROOM',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Admin Note
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.primaryBlue.withOpacity(0.1),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.security,
                                    size: 18,
                                    color: AppColors.primaryBlue,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Use: admin / admin123 for admin access',
                                      style: TextStyle(
                                        color: AppColors.grey700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Footer
                    Column(
                      children: [
                        Text(
                          'Premium Automotive Collection',
                          style: TextStyle(
                            color: AppColors.grey600,
                            fontSize: 12,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 1,
                              color: AppColors.grey300,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Icon(
                                Icons.circle,
                                size: 6,
                                color: AppColors.accentGold,
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 1,
                              color: AppColors.grey300,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
