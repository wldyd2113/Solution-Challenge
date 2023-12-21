import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


FlutterSecureStorage storage = const FlutterSecureStorage();
String REFRESH_TOKEN_KEY = 'refreshToken';
String ACCESS_TOKEN_KEY = 'accessToken';
String iosip = 'http://127.0.0.1:3000/auth/login';
String androidip = 'http://10.0.2.2:3000/auth/login';
