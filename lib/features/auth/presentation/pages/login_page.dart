import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injection.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';

import '../../../../features/admin/shared/presentation/pages/dashboard_main_layout.dart';
import '../../../../features/b2b_dashboard/presentation/pages/b2b_main_layout.dart';
import '../../../../features/client_dashboard/presentation/pages/client_main_layout.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _navigateToDashboard(BuildContext context, String role) {
    Widget destination;
    switch (role.toLowerCase()) {
      case 'admin':
        destination =
            const DashboardLayout(); // Assuming this is Admin Dashboard
        break;
      case 'b2b':
        destination = const B2bMainLayout();
        break;
      case 'b2c':
      default:
        destination = const ClientMainLayout();
        break;
    }

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => destination));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginCubit>(),
      child: Scaffold(
        backgroundColor: const Color(0xFF0F172A), // Premium dark background
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                    if (state is LoginSuccess) {
                      _navigateToDashboard(context, state.role);
                    } else if (state is LoginError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is LoginLoading;

                    return Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Icon(
                            Icons.flight_takeoff,
                            size: 64,
                            color: Colors.blueAccent,
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            "Welcome Back",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 32),
                          TextFormField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                              ),
                              prefixIcon: const Icon(
                                Icons.email,
                                color: Colors.blueAccent,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                            validator: (val) {
                              if (val == null || val.isEmpty)
                                return 'Please enter your email';
                              if (!val.contains('@'))
                                return 'Please enter a valid email';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                              ),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.blueAccent,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                            validator: (val) {
                              if (val == null || val.isEmpty)
                                return 'Please enter your password';
                              if (val.length < 6) return 'Password too short';
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<LoginCubit>().login(
                                        _emailController.text,
                                        _passwordController.text,
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
