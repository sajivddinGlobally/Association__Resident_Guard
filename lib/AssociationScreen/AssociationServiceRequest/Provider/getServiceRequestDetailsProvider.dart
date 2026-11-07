import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/getServiceRequestDetailsModel.dart';

final getServiceRequestDetailsProvider = FutureProvider.family
    .autoDispose<GetServiceRequestDetailsModel, String>((ref, id) async {
      final service = ref.read(authServiceProvider);
      return await service.getServiceRequestDetails(id: id);
    });
