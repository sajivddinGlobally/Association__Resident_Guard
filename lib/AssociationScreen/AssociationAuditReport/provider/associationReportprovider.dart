import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/AssociationReportResModel.dart';

final associationReportprovider = FutureProvider.family
    .autoDispose<AssociationReportResModel, ({String status, String search})>((
      ref,
      params,
    ) async {
      final authService = ref.watch(authServiceProvider);
      return await authService.associationReportData(
        status: params.status,
        search: params.search,
      );
    });

