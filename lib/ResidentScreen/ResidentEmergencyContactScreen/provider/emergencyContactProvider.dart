import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/ResidentScreen/Model/ResidentEmergencyContactResModel.dart';

final emergencyContactProvider =
    FutureProvider.autoDispose<ResidentEmergencyContactResModel>((ref) async {
      final service = ref.read(authServiceProvider);
      return await service.emergencyContactData();
    });