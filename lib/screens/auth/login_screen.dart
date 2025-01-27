import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import '../../blocs/auth_bloc/login_bloc/login_bloc.dart';
import '../../data/repositories/auth_repository.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: 'okesiap');
  final _emailController = TextEditingController(text: 'okesiap@mail.com');
  final _passwordController = TextEditingController(text: 'okesiap123');

  // Tambahkan FocusNode untuk setiap input
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.orange.withOpacity(0.1),
          title: Column(
            children: [
              const SizedBox(height: 10),
              Text(
                'Login'.toUpperCase(),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: BlocProvider(
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
                    color: Colors.orange[600],
                  ),
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
                    color: Colors.orange[600],
                  ),
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
            child: AnnotatedRegion(
              value: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
                systemNavigationBarColor: Colors.white,
                systemNavigationBarIconBrightness: Brightness.dark,
              ),
              child: Stack(
                children: [
                  CustomPaint(
                    painter: BlobPainter(),
                    child: Container(),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Image.asset(
                                'assets/images/main.webp',
                                height: 300,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Username',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            TextFormField(
                              controller: _usernameController,
                              focusNode: _usernameFocusNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(_emailFocusNode);
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter your username',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                    color: Colors.orange,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Username is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            const Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            TextFormField(
                              controller: _passwordController,
                              focusNode: _passwordFocusNode,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                hintText: 'Enter your password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                    color: Colors.orange,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              obscureText: true,
                              obscuringCharacter: '•', // Mengatur karakter yang digunakan untuk menyembunyikan teks
                              style: const TextStyle(
                                letterSpacing: 3.0, // Mengatur jarak antar karakter
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password is required';
                                }
                                return null;
                              },
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
                                                email: _emailController.text,
                                                password: _passwordController.text,
                                              ),
                                            );
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all(Colors.orange[600]),
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
                                      child: const Text(
                                        ' Register',
                                        style: TextStyle(
                                          color: Colors.orange,
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        resizeToAvoidBottomInset: true,
      ),
    );
  }
}

class BlobPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Blob di bagian atas
    final path = Path()
      ..moveTo(0, size.height * 0.1)
      ..cubicTo(
        size.width * 0.25, size.height * 0.005,
        size.width * 0.75, size.height * 0.3,
        size.width, size.height * 0.05,
      )
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    // Blob di bagian bawah
    final path2 = Path()
      ..moveTo(0, size.height-50)
      ..cubicTo(
        size.width * 0.25, size.height * 0.9,
        size.width * 0.75, size.height * 1.1,
        size.width, size.height * 0.9,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}