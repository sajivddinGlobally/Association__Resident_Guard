import 'package:dio/dio.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthService.dart';
import 'package:property_association_or_resident/Core/Network/ApiStateNetwork.dart';
import 'package:property_association_or_resident/Core/Utils/preety.dio.dart';
import 'package:riverpod/riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  return createDio();
});

final apiProvider = Provider((ref) {
  final dio = ref.read(dioProvider);
  return ApiStateNetwork(dio);
});

final authServiceProvider = Provider((ref) {
  final api = ref.read(apiProvider);
  final dio = ref.read(dioProvider);
  return AuthService(api, dio: dio);
});
