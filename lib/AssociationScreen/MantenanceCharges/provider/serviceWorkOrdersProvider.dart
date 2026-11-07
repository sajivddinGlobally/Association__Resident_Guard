import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../Core/AuthService/AuthServiceProvider.dart';
import '../../../../Core/data/model/ResponseModel/serviceWorkOrdersResModel.dart';

final serviceWorkOrdersProvider = FutureProvider.family
    .autoDispose<ServiceWorkOrdersResModel, ({String status, String search})>((
      ref,
      params,
    ) async {
      final authService = ref.watch(authServiceProvider);
      return await authService.getServiceWorkOrders(
        status: params.status.isEmpty ? "all" : params.status,
        search: params.search.isEmpty ? null : params.search,
      );
    });
