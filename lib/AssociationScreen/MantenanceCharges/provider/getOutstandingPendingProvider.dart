import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/outstandingPendingModel.dart';

final getOutstandingPendingProvider = FutureProvider.family
    .autoDispose<OutstandingPendingModel, ({String filter, String search})>((
      ref,
      parameter,
    ) async {
      final authService = ref.read(authServiceProvider);
      return authService.getOutstandingPending(
        filter: parameter.filter,
        search: parameter.search,
      );
    });
