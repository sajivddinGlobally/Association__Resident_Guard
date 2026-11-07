import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Core/AuthService/AuthServiceProvider.dart';
import 'getInspecitonReportModel.dart';

final getInspectionReportProvider = FutureProvider.family
    .autoDispose<GetInspectionReportModel, ({String filter, String type})>((
      ref,
      params,
    ) async {
      final service = ref.read(authServiceProvider);
      return await service.getInspectionReport(
        filter: params.filter,
        type: params.type,
      );
    });
