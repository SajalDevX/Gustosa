

import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:gustosa/app/shared/config/constants/enums.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../inject_dependency/dependencies.dart';
import 'dev_tool.dart';
import 'error_state.dart';

class ErrorHandler {
  static Future<bool> _isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }


  static Future<Either<ErrorState, T>> callApi<T>(
      Future<HttpResponse> Function() repositoryConnect,
      T Function(dynamic) repositoryParse,
      ) async {
    try {
      final response = await repositoryConnect();
      switch (response.statusCode) {
        case 200:
          try {
            return Right(repositoryParse(response));
          } catch (e) {
            return Left(DataParseError(Exception(e.toString())));
          }
        case 401:
          return Left(DataHttpError(HttpException.unAuthorized));
        case 500:
          return Left(DataHttpError(HttpException.internalServerError));
        default:
          return Left(DataHttpError(HttpException.unknown));
      }
    } on DioException catch (e) {
      // print(e.error);
      // print(e.response);
      // print(e.stackTrace);
      if (!await _isConnected()) {
        return Left(DataNetworkError(
            NetworkException.noInternetConnection, e.response));
      }

      switch (e.type) {
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
          return Left(
              DataNetworkError(NetworkException.timeOutError, e.response));
        default:
          return Left(DataNetworkError(NetworkException.unknown, e.response));
      }
    }
  }

  static Future<Either<ErrorState, T>> callSupabase<T>(
      Future<dynamic> Function() repositoryConnect,
      T Function(dynamic) repositoryParse,
      ) async {
    try {
      dynamic response = await repositoryConnect();
      return Right(repositoryParse(response));
    } catch (e, s) {
      // print(e.error);
      // print(e.response);
      // print(e.stackTrace);
      sl<Talker>().logTyped(SupabaseLogger(e.toString(), s, e));
      if (!await _isConnected()) {
        return Left(DataNetworkError(
            NetworkException.noInternetConnection, Response(
            requestOptions: RequestOptions(),
            data: "No internet connection!"
        )));
      } else {
        return Left(DataNetworkError(
            NetworkException.unknown, Response(
            requestOptions: RequestOptions(),
            data: "$e\n${s.toString()}"
        )));
      }
    }
  }
}
