import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/ServiceManagementResModel.dart';

final getServiceManagementProvider = FutureProvider.family
    .autoDispose<
      ServiceManagementResModelDart,
      ({String status, String search})
    >((ref, parm) async {
      final service = ref.read(authServiceProvider);
      return await service.getServiceManagementData(
        status: parm.status,
        search: parm.search,
      );
    });
