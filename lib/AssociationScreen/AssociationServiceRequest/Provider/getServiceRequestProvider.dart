import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/getServiceRequestModel.dart';
import '../../../Core/AuthService/AuthServiceProvider.dart';

final getServiceRequestProvider = FutureProvider.family
    .autoDispose<GetServiceRequestModel, ({String? status, String? search})>((
      ref,
      params,
    ) async {
      final authService = ref.watch(authServiceProvider);
      return await authService.getServiceRequests(
        status: params.status,
        search: params.search,
      );
    });
