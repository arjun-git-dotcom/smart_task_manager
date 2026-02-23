import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_task_manager/core/routes/app_routes.dart';
import 'package:smart_task_manager/features/auth/presentation/cubit/auth_cubit.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
   void initState() {
    super.initState();
    _navigate();
  }
  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2)); 
    
    final authCubit = context.read<AuthCubit>();
    await authCubit.checkCurrentUser();          
    
    if (!mounted) return;
    
    final state = authCubit.state;               
    
    if (state.user != null) {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard, arguments: state.user!.uid);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.task_alt, size: 80),
      SizedBox(height: 16),
      Text('Smart Task Manager',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      SizedBox(height: 32),
      CircularProgressIndicator(),
    ],
        ),
      ),
    );
  }
}