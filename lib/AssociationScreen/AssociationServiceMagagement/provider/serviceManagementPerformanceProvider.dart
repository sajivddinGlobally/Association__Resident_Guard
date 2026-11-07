import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';

import '../../../Core/data/model/ResponseModel/ServiceManagementPerformanceResModel.dart';

final serviceManagementPerformanceProvider = FutureProvider.family
    .autoDispose<ServiceManagementPerformanceResModel , String>((ref, unitID) async {
      final service = ref.read(authServiceProvider);
      return await service.serviceManagementPerformanceData(id: unitID);
    });