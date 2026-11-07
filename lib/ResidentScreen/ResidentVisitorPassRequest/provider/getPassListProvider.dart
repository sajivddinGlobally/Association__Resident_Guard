import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/ResidentScreen/Model/residentVisitorPassResModel.dart';

final getPassListProvider =
    FutureProvider.autoDispose<ResidnetVisitorPassResModel>((ref) async {
      final service = ref.watch(authServiceProvider);
      return await service.getresideitVisitorPassData();
    });
