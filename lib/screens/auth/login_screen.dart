import 'package:ein_ecommerce/components/forms/custom_input.dart';
import 'package:ein_ecommerce/constants/app_colors.dart';
import 'package:ein_ecommerce/utils/blob_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import '../../blocs/auth_bloc/login_bloc/login_bloc.dart';
import '../../data/repositories/auth_repository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Tambahkan FocusNode untuk setiap input
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: AnnotatedRegion(
          value: SystemUiOverlayStyle(
            statusBarColor: AppColors.primary,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: AppColors.primary,
            systemNavigationBarIconBrightness: Brightness.light,
            systemNavigationBarDividerColor: AppColors.primary,
          ),
          child: SafeArea(
            child: BlocProvider(
              create: (context) => LoginBloc(
                authRepository: AuthRepository(),
              ),
              child: BlocListener<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is LoginSuccess) {
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
                        color: Colors.orange[300],
                      ),
                      borderSide: const BorderSide(width: 0),
                      alignment: Alignment.bottomCenter,
                      description: const Text('Login successful!'),
                      autoCloseDuration: const Duration(seconds: 5),
                    );
                    Navigator.pushReplacementNamed(context, '/home'); // Navigasi ke halaman login
                  }
                  if (state is LoginFailure) {
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
                        color: Colors.orange[300],
                      ),
                      borderSide: const BorderSide(width: 0),
                      alignment: Alignment.bottomCenter,
                      autoCloseDuration: const Duration(seconds: 5),
                      description: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: state.errors.length == 1
                            ? [Text(state.errors[0])] // Tampilkan pesan tanpa bullet point jika hanya satu error
                            : state.errors.map((error) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('•'),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(error),
                                    ),
                                  ],
                                ); // Tambahkan bullet point sebelum setiap pesan error
                              }).toList(),
                      ),
                    );
                  }
                },
                child: Stack(
                  children: [
                    CustomPaint(
                      painter: BlobPainter(
                        color: AppColors.primary,
                      ),
                      child: Container(),
                    ),
                    SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 100,
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: Text(
                                  'Login'.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40.0,
                                  ),
                                ),
                              ),
                              Center(
                                child: Image.asset(
                                  'assets/images/main.webp',
                                  height: 300,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(16.0),
                                margin: const EdgeInsets.only(bottom: 16.0),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomInput(
                                      inputName: 'Username',
                                      controller: _usernameController,
                                      focusNode: _usernameFocusNode,
                                      hintText: 'Enter your username',
                                      withLabel: true,
                                      validator: (value) => value!.isEmpty ? 'Username is required' : null,
                                    ),
                                    const SizedBox(height: 16.0),
                                    CustomInput(
                                      inputName: 'Password',
                                      controller: _passwordController,
                                      focusNode: _passwordFocusNode,
                                      hintText: 'Enter your password',
                                      withLabel: true,
                                      validator: (value) => value!.isEmpty ? 'Password is required' : null,
                                      obscureText: !isPasswordVisible,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isPasswordVisible = !isPasswordVisible;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    BlocBuilder<LoginBloc, LoginState>(
                                      builder: (context, state) {
                                        return SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              if (_formKey.currentState!.validate()) {
                                                context.read<LoginBloc>().add(
                                                      LoginButtonPressed(
                                                        username: _usernameController.text,
                                                        password: _passwordController.text,
                                                      ),
                                                    );
                                              }
                                            },
                                            style: ButtonStyle(
                                              backgroundColor: WidgetStateProperty.all(AppColors.primary),
                                              foregroundColor: WidgetStateProperty.all(Colors.white),
                                              shape: WidgetStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                              padding: WidgetStateProperty.all(const EdgeInsets.all(15)),
                                            ),
                                            child: state is LoginLoading
                                                ? const SizedBox(
                                                    width: 26,
                                                    height: 26,
                                                    child: CircularProgressIndicator(
                                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                    ),
                                                  )
                                                : const Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.login),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        'Login',
                                                        style: TextStyle(
                                                          fontSize: 18.0,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                        );
                                      },
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text('Don\'t have an account?'),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(context, '/register');
                                              },
                                              child: Text(
                                                ' Register',
                                                style: TextStyle(
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        resizeToAvoidBottomInset: true,
      ),
    );
  }
}
