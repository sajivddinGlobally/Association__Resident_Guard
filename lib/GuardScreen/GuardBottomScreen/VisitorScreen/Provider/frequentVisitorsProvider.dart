import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/GuardScreen/Model/frequentVisitorsResModel.dart';

final frequentVisitorsProvider =
    FutureProvider.autoDispose<FrequentVisitorsResModel>((ref) async {
  final service = ref.read(authServiceProvider);
  return await service.getFrequentVisitorsData();
});
