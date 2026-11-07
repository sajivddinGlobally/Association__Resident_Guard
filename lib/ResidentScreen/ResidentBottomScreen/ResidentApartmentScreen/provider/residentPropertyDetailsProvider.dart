import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/ResidentScreen/Model/ResidentPropertyDetailsResModel.dart';

final residentPropertyDetailsProvider  =
    FutureProvider.autoDispose<ResidentPropertyDetailsResModel>((ref) async {
      final service = ref.read(authServiceProvider);
      return await service.residentPropertyDetailsData();
    });