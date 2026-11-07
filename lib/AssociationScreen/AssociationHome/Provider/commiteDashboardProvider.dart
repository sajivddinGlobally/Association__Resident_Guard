import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/commiteDashboardModel.dart';

final commiteDashboardProvider =
    FutureProvider.autoDispose<CommiteDashboardModel>((ref) async {
      final service = ref.read(authServiceProvider);
      return await service.getCommitteeDashboardData();
    });
