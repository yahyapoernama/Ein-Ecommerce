import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/user_model.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      await authRepository.login(
        UserModel(
          username: event.username,
          password: event.password,
        ),
      );
      emit(LoginSuccess());
    } catch (e) {
      // Check if the error is a Map and contains 'errors' key
      if (e is List) {
        final errorMessages = e.map((error) => error['msg'] as String).toList();
        emit(LoginFailure(errors: errorMessages));
      } else {
        // Jika error bukan List, kirim pesan error default
        emit(LoginFailure(errors: [e.toString()]));
      }
    }
  }
}