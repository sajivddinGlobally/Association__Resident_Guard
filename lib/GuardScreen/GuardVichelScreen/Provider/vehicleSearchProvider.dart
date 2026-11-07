import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/GuardScreen/Model/VehicleSearchResModel.dart';

final vehicleSearchProvider =
    FutureProvider.family<VehicleSearchResModel?, String>((
      ref,
      vehicleNumber,
    ) async {
      final trimmed = vehicleNumber.trim();
      if (trimmed.isEmpty) {
        return null;
      }
      final service = ref.read(authServiceProvider);
      return await service.vehicleSearchData(trimmed);
    });
