import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:taskmanager/app.dart';
import 'package:taskmanager/ui/controller/auth_controller.dart';

class Apicaller {
  static final Logger _logger = Logger();
  static Future<ApiResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      _loggerRequest(url);
      Response response = await get(
        uri,
        headers: {
          'token': AuthController.accessToken ?? ''
          },
      );
      _loggerResponse(url, response);
      final int statusCode = response.statusCode;
      final decodedData = jsonDecode(response.body);

      if (statusCode == 200 || statusCode == 201) {
        return ApiResponse(
          responseCode: statusCode,
          responseData: decodedData,
          isSuccess: true,
        );
      } else if (statusCode == 401) {
        await _moveToLogIN();
        return ApiResponse(
          responseCode: -1,
          responseData: null,
          isSuccess: false,
        );
      } else {
        return ApiResponse(
          responseCode: statusCode,
          responseData: decodedData,
          isSuccess: false,
          errorMessage: "Request failed with status code: $statusCode",
        );
      }
    } catch (error) {
      return ApiResponse(
        responseCode: -1,
        responseData: null,
        isSuccess: false,
        errorMessage: error.toString(),
      );
    }
  }

  static Future<ApiResponse> postRequest({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      _loggerRequest(url, body: body);
      //post method e body lagbe
      //also headers
      Response response = await post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          'token': AuthController.accessToken ?? '',
        },
        // ignore: unnecessary_null_comparison
        body: body != null ? jsonEncode(body) : null,
      );

      _loggerResponse(url, response);
      final int statusCode = response.statusCode;
      final decodedData = jsonDecode(response.body);

      if (statusCode == 200 || statusCode == 201) {
        return ApiResponse(
          responseCode: statusCode,
          responseData: decodedData,
          isSuccess: true,
        );
      } 
      
//extra check 401 error, 
//jodi token expire hoy tahole login page e niye jabe
      else if (statusCode == 401) {
        await _moveToLogIN();
        return ApiResponse(
          responseCode: -1,
          responseData: null,
          isSuccess: false,
        );
      }
      
      
      else {
        return ApiResponse(
          responseCode: statusCode,
          responseData: decodedData,
          isSuccess: false,
          errorMessage: "Request failed with status code: $statusCode",
        );
      }
    } catch (error) {
      _logger.e("API Error: $error");
      return ApiResponse(
        responseCode: -1,
        responseData: null,
        isSuccess: false,
        errorMessage: error.toString(),
      );
    }
  }

  static void _loggerRequest(String url, {Map<String, dynamic>? body}) {
    _logger.i(
      "Url => $url \n"
      "Request Body => $body \n",
    );
  }

  static void _loggerResponse(String url, Response response) {
    _logger.i(
      "Url => $url \n"
      "Status Code  => ${response.statusCode}\n"
      "Response Boy  => ${response.body}\n",
    );
  }

  static Future<void> _moveToLogIN() async {
    await AuthController.clearUserData();
    Navigator.pushNamedAndRemoveUntil(
      //context er jonno app.dart e navigator key diyechi
      //normally context er jonno widget er moddhe thaka build method e context thake
      TaskManagementApp.navigator.currentContext!,
      '/login',
      (predicate) => false,
    );
  }
}

// Api response
// --> Body
// --> code

class ApiResponse {
  final int responseCode;
  final dynamic responseData;
  final bool isSuccess;
  final String? errorMessage;
  //ei data nite hbe constructor diye

  ApiResponse({
    required this.responseCode,
    required this.responseData,
    required this.isSuccess,
    this.errorMessage = "Something Went WRONG!",
  });
  //constructor called...oop concept
  //then future er moddhe apiresponse dibo
}

//future methods are kept static due to public access
