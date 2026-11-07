import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthService.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/getServiceRequetStatusModel.dart';

import '../../../Core/AuthService/AuthServiceProvider.dart';

final getServiceRequestStatusProvider = FutureProvider.family
    .autoDispose<GetServiceRequestStatusModel, String>((ref, id) async {
      final authService = ref.watch(authServiceProvider);
      return await authService.getServiceRequestStatus(id: id);
    });
