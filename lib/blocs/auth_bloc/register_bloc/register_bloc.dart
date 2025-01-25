import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/user_model.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepository;

  RegisterBloc({required this.authRepository}) : super(RegisterInitial()) {
    on<RegisterButtonPressed>(_onRegisterButtonPressed);
  }

  Future<void> _onRegisterButtonPressed(
    RegisterButtonPressed event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    try {
      await authRepository.register(
        UserModel(
          username: event.username,
          email: event.email,
          password: event.password,
        ),
      );
      emit(RegisterSuccess());
    } catch (e) {
      // Check if the error is a Map and contains 'errors' key
      if (e is List) {
        final errorMessages = e.map((error) => error['msg'] as String).toList();
        emit(RegisterFailure(errors: errorMessages));
      } else {
        // Jika error bukan List, kirim pesan error default
        emit(RegisterFailure(errors: [e.toString()]));
      }
    }
  }
}