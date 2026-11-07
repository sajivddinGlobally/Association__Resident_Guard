import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../Core/AuthService/AuthServiceProvider.dart';
import '../../../Core/data/model/ResponseModel/assocationComplaintResModel.dart';

final getComplaintProvider = FutureProvider.family
    .autoDispose<
      AssociationComplaintResModel,
      ({String status, String search})
    >((ref, params) async {
      final authService = ref.watch(authServiceProvider);
      return await authService.getComplaintData(
        status: params.status,
        search: params.search,
      );
    });
