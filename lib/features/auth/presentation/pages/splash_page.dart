import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injection.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'login_page.dart';

import '../../../../features/admin/shared/presentation/pages/dashboard_main_layout.dart';
import '../../../../features/b2b_dashboard/presentation/pages/b2b_main_layout.dart';
import '../../../../features/client_dashboard/presentation/pages/client_main_layout.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  void _navigateToDashboard(BuildContext context, String role) {
    Widget destination;
    switch (role.toLowerCase()) {
      case 'admin':
        destination = const DashboardLayout();
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

  void _navigateToLogin(BuildContext context) {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>()..checkAuth(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            _navigateToDashboard(context, state.user.role);
          } else if (state is Unauthenticated || state is AuthError) {
            // Unauthenticated means no token or 404, AuthError means network error.
            // We route to login in both cases for now.
            _navigateToLogin(context);
          }
        },
        child: const Scaffold(
          backgroundColor: Color(0xFF0F172A),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.flight_takeoff, size: 80, color: Colors.blueAccent),
                SizedBox(height: 24),
                CircularProgressIndicator(color: Colors.blueAccent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
