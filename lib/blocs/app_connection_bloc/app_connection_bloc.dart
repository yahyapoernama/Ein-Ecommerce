import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:ein_ecommerce/services/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'app_connection_event.dart';
part 'app_connection_state.dart';

class AppConnectionBloc extends Bloc<AppConnectionEvent, AppConnectionState> {
  final Connectivity _connectivity;
  final Dio _dio;
  final ApiService _apiService = ApiService();
  final baseUrl = dotenv.env['API_URL'] ?? '';

  AppConnectionBloc(this._connectivity, this._dio) : super(AppConnectionInitial()) {
    _dio.options.connectTimeout = 10000; // 10 detik
    _dio.options.receiveTimeout = 20000; // 30 detik
    _dio.options.sendTimeout = 20000; // 30 detik

    on<CheckAppConnectionEvent>(_onCheckConnection);
  }

  Future<void> _onCheckConnection(
    CheckAppConnectionEvent event, 
    Emitter<AppConnectionState> emit
  ) async {
    emit(AppConnectionInitial());
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      emit(const NoInternetState());
    } else {
      try {
        final response = await _dio.get('${_apiService.baseUrl}/status');
        await Future.delayed(const Duration(seconds: 1));
        if (response.statusCode == 200) {
          emit(ConnectedState());
        } else {
          emit((const ServerUnreachableState()));
        }
      } on DioError catch (e) {
        if (e.type == DioErrorType.connectTimeout ||
            e.type == DioErrorType.sendTimeout ||
            e.type == DioErrorType.receiveTimeout ||
            e.type == DioErrorType.other) {
          emit(const ServerUnreachableState());
        } 
      }
    }
  }
}