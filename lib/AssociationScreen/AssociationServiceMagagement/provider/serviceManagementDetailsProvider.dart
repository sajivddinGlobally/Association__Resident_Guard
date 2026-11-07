import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/ServiceManagementDetailsResModel.dart';

final serviceManagementDetailsProvider = FutureProvider.family
    .autoDispose<ServiceManagementDetailsResModel, String>((ref, unitID) async {
      final service = ref.read(authServiceProvider);
      return await service.serviceManagementDetailsData(id: unitID);
    });