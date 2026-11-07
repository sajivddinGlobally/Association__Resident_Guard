import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/ResidentScreen/Model/getComplaintListModel.dart';

final getComplaintListProvider = FutureProvider.family
    .autoDispose<GetComplaintListModel, String>((ref, status) async {
      final srvice = ref.read(authServiceProvider);
      return await srvice.getComplaintList(status: status);
    });
