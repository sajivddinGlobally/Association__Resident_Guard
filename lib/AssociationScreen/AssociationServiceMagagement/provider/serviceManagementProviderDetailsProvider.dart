import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/ServiceManagementProviderDetailsResModel.dart';

final serviceManagementProviderDetailsProvider = FutureProvider.family
    .autoDispose<ServiceManagementProviderDetailsResModel, String>((ref, unitID) async {
      final service = ref.read(authServiceProvider);
      return await service.serviceManagementProviderDetailsData(id: unitID);
    });