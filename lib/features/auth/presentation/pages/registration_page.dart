import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_task_manager/core/routes/app_routes.dart';
import 'package:smart_task_manager/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:smart_task_manager/features/auth/presentation/cubit/auth_state.dart';
import 'package:smart_task_manager/features/auth/presentation/widgets/custom_text_field.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.user != null) {
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.dashboard,
                arguments: state.user!.uid,
              );
            }
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
              context.read<AuthCubit>().clearError();
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.task_alt, size: 64),
                const SizedBox(height: 8),
                const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: emailController,
                  hintText: "Email",
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: state.isPasswordObscure,
                  suffixIcon: state.isPasswordObscure
                      ? Icons.visibility_off
                      : Icons.visibility,
                  toggleIcon: () =>
                      context.read<AuthCubit>().togglePasswordVisibility(),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: state.isLoading
                      ? null
                      : () {
                          context.read<AuthCubit>()
                            ..emailChanged(emailController.text)
                            ..passwordChanged(passwordController.text)
                            ..registerUser();
                        },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: state.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Register',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                  child: const Text("Already have an account? Login"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}