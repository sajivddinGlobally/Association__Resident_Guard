import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/ResidentScreen/Model/getVisitorPassListModel.dart';

final getVisitorListProvider =
    FutureProvider.autoDispose<GetVisitorPassListModel>((ref) async {
      final apiState = ref.watch(authServiceProvider);
      return apiState.getVisitorPass();
    });
