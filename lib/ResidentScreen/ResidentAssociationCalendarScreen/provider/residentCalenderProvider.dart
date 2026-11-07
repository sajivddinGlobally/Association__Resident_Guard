import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/ResidentScreen/Model/getResidentCalenderModel.dart';

final getResidentCalenderProvider =
    FutureProvider.autoDispose.family<GetResidentCalenderModel, String?>((
      ref,
      month,
    ) async {
      final service = ref.read(authServiceProvider);
      return await service.getResidentCalender(month: month);
    });
