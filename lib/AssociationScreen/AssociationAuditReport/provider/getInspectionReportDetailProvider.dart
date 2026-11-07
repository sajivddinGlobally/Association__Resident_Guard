import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationAuditReport/provider/getInspectionReportDetailsModel.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';

final getInspectionReportDetailsProvider =
    FutureProvider.family.autoDispose<GetInspectionReportDetailsModel, String>((
      ref,
      id,
    ) async {
      final authService = ref.watch(authServiceProvider);
      return authService.getInspectionReportDetails(id: id);
    });
