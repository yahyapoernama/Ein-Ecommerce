import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import '../../blocs/auth_bloc/register_bloc/register_bloc.dart';
import '../../data/repositories/auth_repository.dart';

class RegisterScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: 'okesiap');
  final _emailController = TextEditingController(text: 'okesiap@mail.com');
  final _passwordController = TextEditingController(text: 'okesiap123');

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: BlocProvider(
        create: (context) => RegisterBloc(
          authRepository: AuthRepository(),
        ),
        child: BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              toastification.dismissAll();
              toastification.show(
                context: context,
                type: ToastificationType.success,
                style: ToastificationStyle.flat,
                title: const Text('Success'),
                primaryColor: Colors.white,
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                progressBarTheme: ProgressIndicatorThemeData(
                  color: Colors.orange[600],
                ),
                alignment: Alignment.bottomCenter,
                description: const Text('Registration successful!'),
                autoCloseDuration: const Duration(seconds: 5),
              );
              Navigator.pushReplacementNamed(context, '/home'); // Navigasi ke halaman login
            }
            if (state is RegisterFailure) {
              toastification.dismissAll();
              toastification.show(
                context: context,
                type: ToastificationType.error,
                style: ToastificationStyle.flat,
                title: const Text('Error'),
                primaryColor: Colors.white,
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                progressBarTheme: ProgressIndicatorThemeData(
                  color: Colors.orange[600],
                ),
                alignment: Alignment.bottomCenter,
                autoCloseDuration: const Duration(seconds: 5),
                description: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      // state.errors.map((error) {
                      //   return Text(error); // Tambahkan bullet point sebelum setiap pesan error
                      // }).toList(),
                      state.errors.length == 1
                          ? [Text(state.errors[0])] // Tampilkan pesan tanpa bullet point jika hanya satu error
                          : state.errors.map((error) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('•'),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      error
                                    ),
                                  ),
                                ],
                              ); // Tambahkan bullet point sebelum setiap pesan error
                            }).toList(),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username is required';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<RegisterBloc, RegisterState>(
                    builder: (context, state) {
                      if (state is RegisterLoading) {
                        return const CircularProgressIndicator();
                      }
                      return ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<RegisterBloc>().add(
                                  RegisterButtonPressed(
                                    username: _usernameController.text,
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                          }
                        },
                        child: const Text('Register'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
