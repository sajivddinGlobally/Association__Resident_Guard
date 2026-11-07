// import 'dart:developer';
// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:property_association_or_resident/AssociationScreen/AssociationProperty/addUnitBodyModel.dart';
// import 'package:property_association_or_resident/Core/Network/ApiStateNetwork.dart';
// import 'package:property_association_or_resident/Core/data/model/BodyModel/aiAssistanceBodyModel.dart';
// import 'package:property_association_or_resident/Core/data/model/BodyModel/resetPassBodyModel.dart';
// import 'package:property_association_or_resident/Core/data/model/ResponseModel/commiteDashboardModel.dart';
// import 'package:property_association_or_resident/Core/data/model/ResponseModel/complexDetailsModel.dart';
// import 'package:property_association_or_resident/Core/data/model/ResponseModel/documentDetailsModel.dart';
// import 'package:property_association_or_resident/Core/data/model/ResponseModel/getAlertModel.dart';
// import 'package:property_association_or_resident/Core/data/model/ResponseModel/getPropertyAssistantModel.dart';
// import 'package:property_association_or_resident/Core/data/model/ResponseModel/getPropertyUnitDetailsModel.dart';
// import 'package:property_association_or_resident/Core/data/model/ResponseModel/getPropertyUnitListModel.dart';
// import 'package:property_association_or_resident/Core/data/model/ResponseModel/pendingMaintananceModel.dart';
// import 'package:property_association_or_resident/GuardScreen/Model/VehicleSearchResModel.dart';
// import 'package:property_association_or_resident/GuardScreen/Model/VisitorPassResModel.dart';
// import 'package:property_association_or_resident/GuardScreen/Model/guardDashbordModel.dart';
// import 'package:property_association_or_resident/GuardScreen/Model/historyGuardResModel.dart';
// import 'package:property_association_or_resident/GuardScreen/Model/historyRecordsModel.dart';
// import 'package:property_association_or_resident/ResidentScreen/Model/MaintenanceActivitiesResModel.dart';
// import 'package:property_association_or_resident/ResidentScreen/Model/getVisitorPassListModel.dart';
// import '../../AssociationScreen/AssociationAuditReport/provider/getInspecitonReportModel.dart';
// import '../../AssociationScreen/AssociationAuditReport/provider/getInspectionReportDetailsModel.dart';
// import '../../AssociationScreen/AssociationProperty/addUnitResModel.dart';
// import '../../GuardScreen/Model/addParcelResModel.dart';
// import '../../GuardScreen/Model/addVisitorResModel.dart';
// import '../../GuardScreen/Model/getFlatApartmentModel.dart';
// import '../../GuardScreen/Model/guardProfileModel.dart';
// import '../../GuardScreen/Model/markOutResModel.dart';
// import '../../GuardScreen/Model/parcelHandoverResModel.dart';
// import '../../ResidentScreen/Model/ResidentCommunityContactResModel.dart';
// import '../../ResidentScreen/Model/ResidentEmergencyContactResModel.dart';
// import '../../ResidentScreen/Model/ResidentMmcStatusResModel.dart';
// import '../../ResidentScreen/Model/ResidentPropertyDetailsResModel.dart';
// import '../../ResidentScreen/Model/addResidentComplainResModel.dart';
// import '../../ResidentScreen/Model/closeComplaintBodyModel.dart';
// import '../../ResidentScreen/Model/complainCloseResModel.dart';
// import '../../ResidentScreen/Model/createPassVisitorBodyModel.dart';
// import '../../ResidentScreen/Model/createPassVisotroResModel.dart';
// import '../../ResidentScreen/Model/getComplaintListModel.dart';
// import '../../ResidentScreen/Model/getComplaintTrackingModel.dart';
// import '../../ResidentScreen/Model/getPassListResModel.dart';
// import '../../ResidentScreen/Model/getResidentCalenderModel.dart';
// import '../../ResidentScreen/Model/getResidentParcelModel.dart';
// import '../../ResidentScreen/Model/residentParcelRespondBodyModel.dart';
// import '../../ResidentScreen/Model/residentParcelRespondResModel.dart';
// import '../../ResidentScreen/Model/residentVisitorPassResModel.dart';
// import '../../ResidentScreen/Model/residentVisitorRespondResModel.dart';
// import '../../ResidentScreen/Model/getResidentProfileModel.dart';
// import '../../ResidentScreen/Model/residentDashboardModel.dart';
// import '../../GuardScreen/Model/guardCommonResModel.dart';
// import '../../GuardScreen/Model/frequentVisitorsResModel.dart';
// import '../../GuardScreen/Model/scanPassResModel.dart';
// import '../../GuardScreen/Model/visitorFormDataResModel.dart';
// import '../../GuardScreen/Model/parcelFormDataResModel.dart';
// import '../../GuardScreen/Model/recentVehicleSearchesResModel.dart';
// import '../data/model/BodyModel/addResidentBodyModel.dart';
// import '../data/model/BodyModel/assocationCalenderBodyModel.dart';
// import '../data/model/BodyModel/changePasswordBodyModel.dart';
// import '../data/model/BodyModel/forgotPassBodyModel.dart';
// import '../data/model/BodyModel/loginBodyModel.dart';
// import '../data/model/BodyModel/registerBodyModel.dart';
// import '../data/model/BodyModel/updateTicketStatusBodyModel.dart';
// import '../data/model/BodyModel/verifyOtpBodyModel.dart';
// import '../data/model/ResponseModel/GetGuardShiftsModel.dart';
// import '../data/model/ResponseModel/GetNotificaionListModel.dart';
// import '../data/model/ResponseModel/MarkNotificationReadResModel.dart';
// import '../data/model/ResponseModel/ServiceManagementPerformanceResModel.dart';
// import '../data/model/ResponseModel/ServiceManagementResModel.dart';
// import '../data/model/ResponseModel/addGuardResModel.dart';
// import '../data/model/ResponseModel/addResidentResModel.dart';
// import '../data/model/ResponseModel/assocationComplaintResModel.dart';
// import '../data/model/ResponseModel/associationCalenderresModel.dart';
// import '../data/model/ResponseModel/AssociationReportResModel.dart';
// import '../data/model/ResponseModel/changePassResModel.dart';
// import '../data/model/ResponseModel/complaintStatusResModel.dart';
// import '../data/model/ResponseModel/defaulterDetailsModel.dart';
// import '../data/model/ResponseModel/defaulterListModel.dart';
// import '../data/model/ResponseModel/editProfileResModel.dart';
// import '../data/model/ResponseModel/forgotPassResModel.dart';
// import '../data/model/ResponseModel/getAssignedModel.dart';
// import '../data/model/ResponseModel/getComplaintDetailsResModel.dart';
// import '../data/model/ResponseModel/getDocumentListModel.dart';
// import '../data/model/ResponseModel/getProfileModel.dart';
// import '../data/model/ResponseModel/getResidentDetailsModel.dart';
// import '../data/model/ResponseModel/getResidentResModel.dart';
// import '../data/model/ResponseModel/getServiceRequestDetailsModel.dart';
// import '../data/model/ResponseModel/getServiceRequestModel.dart';
// import '../data/model/ResponseModel/getServiceRequetStatusModel.dart';
// import '../data/model/ResponseModel/getUnitsModel.dart';
// import '../data/model/ResponseModel/loginResModel.dart';
// import '../data/model/ResponseModel/logoutModel.dart';
// import '../data/model/ResponseModel/maintananceChargesModel.dart';
// import '../data/model/ResponseModel/maintananceDetailsModel.dart';
// import '../data/model/ResponseModel/maintananceOverviewModel.dart';
// import '../data/model/ResponseModel/maintenanceChargeStatusModel.dart';
// import '../data/model/ResponseModel/outstandingPendingModel.dart';
// import '../data/model/ResponseModel/serviceWorkOrdersResModel.dart';
// import '../data/model/ResponseModel/registerResModel.dart';
// import '../data/model/ResponseModel/resetPassResModel.dart';
// import '../data/model/ResponseModel/ServiceManagementDetailsResModel.dart';
// import '../data/model/ResponseModel/ServiceManagementProviderDetailsResModel.dart';
// import '../data/model/BodyModel/addAnnouncementBodyModel.dart';
// import '../data/model/ResponseModel/addAnnouncementResModel.dart';
// import '../data/model/ResponseModel/getCommitteeAnnouncementModel.dart';
// import '../data/model/ResponseModel/residentAnnouncementResModel.dart';
// import '../data/model/ResponseModel/verifyOtpResModel.dart';

// class AuthService {
//   final ApiStateNetwork api;
//   final Dio? dio;

//   AuthService(this.api, {this.dio});

//   Future<GetUnAssignedResModel> getUnassigned() async {
//     try {
//       final response = await api.getunassigned();
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<RegisterResModel> register({
//     required String name,
//     required String email,
//     required String phone,
//     required String password,
//     required String confirmPassword,
//     required String role,
//     required String complexId,
//     required String address,
//   }) async {
//     try {
//       final body = RegisterBodyModel(
//         email: email,
//         password: password,
//         phone: phone,
//         name: name,
//         role: role,
//         confirmPassword: confirmPassword,
//         complexId: complexId,
//         address: address,
//       );
//       final response = await api.register(body);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<LoginResModel> login({
//     required String email,
//     required String password,
//     required String role,
//   }) async {
//     try {
//       final body = LoginBodyModel(login: email, password: password, role: role);
//       final response = await api.login(body);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<ForgotPassResModel> forgotPassword({required String email}) async {
//     try {
//       final body = ForgotPassBodyModel(email: email);
//       final response = await api.forgotPass(body);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<VerifyOtpResModel> verifyOTP({
//     required String email,
//     required String otp,
//   }) async {
//     try {
//       final body = VerifyOtpBodyModel(email: email, otp: otp);
//       final response = await api.verifyOtp(body);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<ResetPassResModel> resetPassword({
//     required String newPassword,
//     required String confirmPassword,
//     required String email,
//   }) async {
//     try {
//       final body = ResetPassBodyModel(
//         newPassword: newPassword,
//         confirmPassword: confirmPassword,
//         email: email,
//       );
//       final response = await api.resetPassword(body);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<ChangePasswordResModel> changePassword({
//     required String currentPassword,
//     required String newPassword,
//     required String confirmNewPassword,
//   }) async {
//     try {
//       final body = ChangePasswordBodyModel(
//         currentPassword: currentPassword,
//         newPassword: newPassword,
//         confirmNewPassword: confirmNewPassword,
//       );
//       final response = await api.changePassword(body);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<GetProfileModel> getProfileData({dynamic propertyId}) async {
//     try {
//       final response = await api.getProfileData(propertyId);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<LogoutModel> logout() async {
//     try {
//       final response = await api.logout();
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<EditProfileResModel> editProfile({
//     required String name,
//     required String phone,
//     required MultipartFile? image,
//   }) async {
//     try {
//       final response = await api.editProfile(name, phone, image);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<CommiteDashboardModel> getCommitteeDashboardData() async {
//     try {
//       final response = await api.getCommitteeDashboardData();
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<ComplexDetailsModel> getComplexDetails() async {
//     try {
//       final response = await api.getComplexDetails();
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<GetPropertyUnitListModel> getPropertyUnitList({
//     String? status,
//     String? block,
//     String? search,
//   }) async {
//     try {
//       final response = await api.getPropertyUnitList(
//         status: (status != null && status.trim().isNotEmpty)
//             ? status.trim()
//             : null,
//         block: (block != null && block.trim().isNotEmpty) ? block.trim() : null,
//         search: (search != null && search.trim().isNotEmpty)
//             ? search.trim()
//             : null,
//       );
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<GetPropertyUnitDetailsModel> getPropertyUnitDetails({
//     required String id,
//   }) async {
//     try {
//       final response = await api.getPropertyUnitDetails(id);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<GetServiceRequestModel> getServiceRequests({
//     String? status,
//     String? search,
//     String? type = "service_request",
//   }) async {
//     try {
//       final response = await api.getServiceRequestList(
//         status,
//         search,
//         type: type,
//       );
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<GetServiceRequestDetailsModel> getServiceRequestDetails({
//     required String id,
//   }) async {
//     try {
//       final response = await api.getServiceRequestDetails(id);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<GetServiceRequestStatusModel> getServiceRequestStatus({
//     required String id,
//   }) async {
//     try {
//       final response = await api.getServiceRequestStatus(id: id);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<GetDocumentListModel> getDocumentList({
//     required String category,
//     required String search,
//   }) async {
//     try {
//       final response = await api.getDocumentList(category, search);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<DocumentDetailsModel> getDocumentDetails({required String id}) async {
//     try {
//       final response = await api.getDocumentDetails(id);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<MaintananceOverviewModel> getMaintenanceOverview() async {
//     try {
//       final response = await api.getMaintenanceOverview();
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<PendingMaintenanceModel> getPendingMaintanance({
//     String? priority,
//     String? search,
//   }) async {
//     try {
//       final response = await api.getPendingMaintenance(
//         priority: priority,
//         search: search,
//       );
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<MaintananceDetailsModel> getMaintananceDetails({
//     required String id,
//   }) async {
//     try {
//       final response = await api.getMaintananceDetails(id);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<dynamic> updateMaintenanceStatus({
//     required String id,
//     required String status,
//     String? notes,
//   }) async {
//     try {
//       if (dio != null) {
//         final res = await dio!.post(
//           "https://realestate.gwsstaging.com/api/v1/committee/maintenance/$id/status",
//           data: {
//             "status": status,
//             if (notes != null && notes.isNotEmpty) "notes": notes,
//           },
//         );
//         return res.data;
//       }
//       return null;
//     } catch (e) {
//       log("Error updating maintenance status: $e");
//       rethrow;
//     }
//   }

//   /// Association / admin: society ka visitor In/Out log (reporting ke liye).
//   /// Backend: GET /api/v1/committee/visitor-logs
//   Future<Map<String, dynamic>> getCommitteeVisitorLogs({
//     String? dateFrom,
//     String? dateTo,
//     String? status,
//     String? search,
//     bool onlyInside = false,
//     int page = 1,
//     int perPage = 20,
//   }) async {
//     try {
//       final res = await dio!.get(
//         "https://realestate.gwsstaging.com/api/v1/committee/visitor-logs",
//         queryParameters: {
//           if (dateFrom != null && dateFrom.isNotEmpty) "date_from": dateFrom,
//           if (dateTo != null && dateTo.isNotEmpty) "date_to": dateTo,
//           if (status != null && status.isNotEmpty) "status": status,
//           if (search != null && search.isNotEmpty) "search": search,
//           if (onlyInside) "only_inside": 1,
//           "page": page,
//           "per_page": perPage,
//         },
//       );
//       final data = res.data;
//       return data is Map<String, dynamic> ? data : <String, dynamic>{};
//     } catch (e) {
//       log("Error fetching visitor logs: $e");
//       rethrow;
//     }
//   }

//   Future<MaintananceChargesModel> getMaintananceCharges() async {
//     try {
//       final response = await api.getMaintananceCharges();
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<MaintananceChargeStatusModel> maintenanceChargeStatus({
//     required String tab,
//   }) async {
//     try {
//       final response = await api.maintenanceChargeStatus(tab);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<DefaulterListResModel> getDefaulterList({
//     required String filter,
//     required String search,
//   }) async {
//     try {
//       final response = await api.getDefaulterList(filter, search);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<ServiceWorkOrdersResModel> getServiceWorkOrders({
//     String? status,
//     String? search,
//   }) async {
//     try {
//       final response = await api.getServiceWorkOrders(
//         status: status,
//         search: search,
//       );
//       return response;
//     } catch (e) {
//       log("Error fetching service work orders: $e");
//       rethrow;
//     }
//   }

//   Future<AddUnitResModel> addUnit({
//     required String name,
//     required String area,
//     required String bedroom,
//     required String floor,
//     required String location,
//   }) async {
//     try {
//       final body = AddUnitBodyModel(
//         unitNumber: name,
//         area: area,
//         bedrooms: bedroom,
//         floor: floor,
//         location: location,
//       );
//       final response = await api.addUnit(body);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<DefaulterDetailsModel> getDefaulterDetails({
//     required String id,
//   }) async {
//     try {
//       final response = await api.getDefaulterDetails(id);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<dynamic> sendDefaulterReminder({required String id}) async {
//     try {
//       if (dio != null) {
//         final res = await dio!.post(
//           "https://realestate.gwsstaging.com/api/v1/committee/charges/defaulters/$id/send-reminder",
//           data: {},
//         );
//         return res.data;
//       }
//       return null;
//     } catch (e) {
//       log("Error sending defaulter reminder: $e");
//       rethrow;
//     }
//   }

//   Future<dynamic> receiveDefaulterPay({
//     required String id,
//     required dynamic amount,
//     required String paidVia,
//     required String paymentDate,
//     String? notes,
//   }) async {
//     try {
//       if (dio != null) {
//         final num? parsedAmount = num.tryParse(amount.toString());
//         final res = await dio!.post(
//           "https://realestate.gwsstaging.com/api/v1/committee/charges/defaulters/$id/receive-pay",
//           data: {
//             "paid_via": paidVia,
//             "amount": parsedAmount ?? amount,
//             "payment_date": paymentDate,
//             if (notes != null && notes.isNotEmpty) "notes": notes,
//           },
//         );
//         return res.data;
//       }
//       return null;
//     } catch (e) {
//       log("Error receiving defaulter pay: $e");
//       rethrow;
//     }
//   }

//   Future<dynamic> toggleDefaulterStatus({required String id}) async {
//     try {
//       if (dio != null) {
//         final res = await dio!.post(
//           "https://realestate.gwsstaging.com/api/v1/committee/charges/defaulters/$id/toggle-status",
//           data: {},
//         );
//         return res.data;
//       }
//       return null;
//     } catch (e) {
//       log("Error toggling defaulter status: $e");
//       rethrow;
//     }
//   }

//   ///////////////////////////////////
//   ///
//   Future<AssociationComplaintResModel> getComplaintData({
//     required String status,
//     required String search,
//     String? type = "complaint",
//   }) async {
//     try {
//       final response = await api.getComplaintData(status, search, type: type);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<GetComplaintDetailsResModel> getComplaintDetails({
//     required String id,
//   }) async {
//     try {
//       final response = await api.getComplaintDetails(id);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<dynamic> updateTicketStatus({
//     required String id,
//     required String status,
//   }) async {
//     try {
//       final body = UpdateTicketStatusBodyModel(status: status);
//       final response = await api.updateTicketStatus(id, body);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<dynamic> createServiceTicket({
//     required String serviceCategory,
//     String? serviceType,
//     required String title,
//     required String details,
//     String? preferredDate,
//     String? preferredTime,
//     required String priority,
//     MultipartFile? attachment,
//     required String type,
//     int? propertyId,
//   }) async {
//     try {
//       final response = await api.createService(
//         serviceCategory,
//         serviceType,
//         title,
//         details,
//         preferredDate,
//         preferredTime,
//         priority,
//         attachment,
//         type,
//         propertyId,
//       );
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<dynamic> createComplaintTicket({
//     required String serviceCategory,
//     String? serviceType,
//     required String title,
//     required String details,
//     String? preferredDate,
//     String? preferredTime,
//     required String priority,
//     MultipartFile? attachment,
//     int? propertyId,
//   }) async {
//     return await createServiceTicket(
//       serviceCategory: serviceCategory,
//       serviceType: serviceType,
//       title: title,
//       details: details,
//       preferredDate: preferredDate,
//       preferredTime: preferredTime,
//       priority: priority,
//       attachment: attachment,
//       type: "complaint",
//       propertyId: propertyId,
//     );
//   }

//   Future<ComplaintStatusResModel> getComplaintStatus({
//     required String id,
//   }) async {
//     try {
//       final response = await api.complaintStatus(id);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<OutstandingPendingModel> getOutstandingPending({
//     required String filter,
//     required String search,
//   }) async {
//     try {
//       final response = await api.getOutstatndingPedning(filter, search);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   /////////////////////////////////// Resident /////////////////

//   Future<GetUnitsModel> getAvailableUnits() async {
//     try {
//       final units = await api.getAvailableUnits();
//       return units;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<AddResidentResModel> addResident({
//     required String name,
//     required String email,
//     required String phone,
//     required String password,
//     required String confirmPassword,
//     required String unitNumber,
//     required bool termsAccepted,
//     required String residentType,
//     String? vehicleNumber,
//   }) async {
//     try {
//       final body = AddResedentBodyModel(
//         name: name,
//         email: email,
//         phone: phone,
//         password: password,
//         confirmPassword: confirmPassword,
//         unitNumber: unitNumber,
//         termsAccepted: termsAccepted,
//         residentType: residentType,
//         vehicleNumber: vehicleNumber,
//       );
//       final response = await api.addResident(body);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<GetResidentListModel> getResidentList() async {
//     try {
//       final response = await api.getResidentList();
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<GetResidentDetailsModel> getResidentDetails({
//     required String id,
//   }) async {
//     try {
//       final response = await api.getResidentDetails(id);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<GetAlertModel> getAlerts({required String filter}) async {
//     try {
//       final response = await api.getAlerts(filter);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<GetNotificaionListModel> getNotificaionList({
//     required String filter,
//   }) async {
//     try {
//       final response = await api.getNotificaionList(filter);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<MarkNotificationReadResModel> markNotificationRead({
//     required String id,
//   }) async {
//     try {
//       final response = await api.markNotificationRead(id);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<MarkNotificationReadResModel?> markMultipleNotificationsRead({
//     required List<String> ids,
//   }) async {
//     if (ids.isEmpty) return null;
//     try {
//       final joinedIds = ids.join(',');
//       final response = await api.markNotificationRead(joinedIds);
//       return response;
//     } catch (e) {
//       log("Error marking notifications as read: $e");
//       return null;
//     }
//   }

//   Future<AssociationCalenderResModel> addAssociationCalendar({
//     required String eventName,
//     required String eventType,
//     required String visitDate,
//     required String visitTime,
//     required String endTime,
//     required String organizedBy,
//     required String eventFor,
//     required String description,
//     required String location,
//   }) async {
//     try {
//       final body = AssociationCalenderBodyModel(
//         eventName: eventName,
//         eventType: eventType,
//         visitDate: DateTime.parse(visitDate),
//         visitTime: visitTime,
//         endTime: endTime,
//         organizedBy: organizedBy,
//         eventFor: eventFor,
//         description: description,
//         location: location,
//       );
//       final response = await api.addAssociationCalendar(body);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<GetPropertyAssistantModel> getPropertyAssistant() async {
//     try {
//       final response = await api.getPropertyAssistant();
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<GetPropertyAssistantModel> sendMessageToAi({
//     required String query,
//   }) async {
//     try {
//       final body = AiAssistanceBodyModel(query: query);
//       final response = await api.sendMessageToAi(body);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<ServiceManagementResModelDart> getServiceManagementData({
//     required String status,
//     required String search,
//   }) async {
//     try {
//       final queryStatus = status.isEmpty || status.toLowerCase() == "all"
//           ? null
//           : status;
//       final querySearch = search.trim().isEmpty ? null : search.trim();
//       final response = await api.getServiceManagement(queryStatus, querySearch);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<ServiceManagementDetailsResModel> serviceManagementDetailsData({
//     required String id,
//   }) async {
//     try {
//       final response = await api.serviceManagementDetails(id);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<ServiceManagementProviderDetailsResModel>
//   serviceManagementProviderDetailsData({required String id}) async {
//     try {
//       final response = await api.serviceManagementProviderDetails(id);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<ServiceManagementPerformanceResModel>
//   serviceManagementPerformanceData({required String id}) async {
//     try {
//       final response = await api.serviceManagementPerformance(id);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<AssociationReportResModel> associationReportData({
//     required String status,
//     required String search,
//   }) async {
//     try {
//       final response = await api.associationReport(status, search);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<GetInspectionReportModel> getInspectionReport({
//     required String filter,
//     required String type,
//     dynamic propertyId,
//   }) async {
//     try {
//       final response = await api.getInspectionReport(filter, type, propertyId);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<GetInspectionReportDetailsModel> getInspectionReportDetails({
//     required String id,
//   }) async {
//     try {
//       final response = await api.getInpectionReportDetails(id);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<AddGuardResModel> addGuardData({
//     required String name,
//     required String phone,
//     required String password,
//     required String guardPost,
//     required String shiftId,
//     required String email,
//     required MultipartFile? image,
//   }) async {
//     try {
//       final response = await api.addGuard(
//         name,
//         phone,
//         password,
//         guardPost,
//         shiftId,
//         email,
//         image,
//       );
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<GetGuardShiftsModel> getGuardShifts() async {
//     try {
//       final response = await api.getGuardShifts();
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   //////////////////////////  resident dashboard   //////////////////////

//   Future<ResidentDashbordModel> getResidentDashboardData() async {
//     try {
//       final response = await api.getResidentDashbordData();
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<GetResidentProfileModel> getResidentProfileData() async {
//     try {
//       final response = await api.getResidentProfileData();
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<AddResidentComplaintResModel> addResidentComplaintData({
//     required String category,
//     required String subject,
//     required String description,
//     required MultipartFile? photo,
//     String? areaType,
//     String? location,
//     String? priority,
//   }) async {
//     try {
//       final response = await api.addResidentComplaint(
//         category,
//         subject,
//         description,
//         photo,
//         areaType: areaType,
//         location: location,
//         priority: priority,
//       );
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   // Future<GetComplaintRequestListModel> getComplaintFormData() async {
//   //   try {
//   //     final response = await api.getComplaintFormData();
//   //     return response;
//   //   } catch (e) {
//   //     rethrow;
//   //   }
//   // }

//   Future<GetComplaintListModel> getComplaintList({
//     required String status,
//   }) async {
//     try {
//       final response = await api.getComplaintList(status: status);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<GetComplaintTrackingModel> getComplaintTracking({
//     required String id,
//   }) async {
//     try {
//       final response = await api.getComplaintTracking(id);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<ResidentMmcStatusResModel> residentMmnStatusData() async {
//     try {
//       final response = await api.residentMmcStatus();
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<ResidentPropertyDetailsResModel> residentPropertyDetailsData() async {
//     try {
//       final response = await api.residentPropertyDetails();
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<ResidentCommunityContactResModel> residentCommunityContact() async {
//     try {
//       final response = await api.residentCommunityContact();
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<CreatVisitorPassResModdel> createVisitorPassRequest({
//     required String visitorName,
//     required String mobileNumber,
//     required String visitorType,
//     required String visitDate,
//     required String visitTime,
//     required String purposeOfVisit,
//     bool isFrequent = false,
//     String? frequentRole,
//   }) async {
//     try {
//       final body = CreateVisitorPassBodyModdel(
//         visitorName: visitorName,
//         mobileNumber: mobileNumber,
//         visitorType: visitorType,
//         visitDate: visitDate,
//         visitTime: visitTime,
//         purposeOfVisit: purposeOfVisit,
//         isFrequent: isFrequent,
//         frequentRole: frequentRole,
//       );
//       final response = await api.createVisitorPassRequest(body);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<GetVisitorPassListModel> getVisitorPass() async {
//     try {
//       final response = await api.getVisitorPass();
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<GetResidentCalenderModel> getResidentCalender({String? month}) async {
//     try {
//       final response = await api.getResidentCalender(month: month);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<ResidentEmergencyContactResModel> emergencyContactData() async {
//     try {
//       final response = await api.emergencyContact();
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<ComplainCloseResModel> closeComplant({
//     required String id,
//     String? reason,
//     String? remarks,
//   }) async {
//     try {
//       final body = ComplainCloseBodyModel(
//         status: "closed",
//         residentStatus: "closed",
//       );
//       final response = await api.closeComplant(id, body);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<GetResidentParcelModel> getResidentParcel() async {
//     try {
//       final response = await api.getResidentParcel();
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<ResidentParcelRespondResModel> respondResidentParcelData({
//     required String parcelId,
//     required String action,
//     String? deliveryMode,
//     String? remarks,
//   }) async {
//     try {
//       final body = ResidentParcelRespondBodyModel(
//         action: action,
//         deliveryMode: deliveryMode,
//         remarks: remarks,
//       );
//       final response = await api.respondResidentParcel(parcelId, body);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<ResidnetVisitorPassResModel> getresideitVisitorPassData() async {
//     try {
//       final response = await api.getresideitVisitorPass();
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<MaintenanceActivitiesResModel> maintenanceActivitiesData() async {
//     try {
//       final response = await api.maintenanceActive();
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<GetPassListResModel> getPass() async {
//     try {
//       final response = await api.getPass();
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   ////////////////// Guard //////////////////////

//   Future<GuardDashBoardModel> guardDashBoardData() async {
//     try {
//       final response = await api.guardDashBoard();
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<HistoryRecordsResModel> historyRecordsData(String filter) async {
//     try {
//       final response = await api.historyRecords(filter);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<VehicleSearchResModel> vehicleSearchData(String vehicleNumber) async {
//     try {
//       final response = await api.vehicleSearch(vehicleNumber);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<HistoryGuardResModel> historyGuardData() async {
//     try {
//       final response = await api.historyGuard();
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<AddVisitorResModel> addVisitorData({
//     required String visitorName,
//     required String visitorPhone,
//     required String flatNumber,
//     required String visitType,
//     required String vehicleNumber,
//     required String purpose,
//     File? visitorPhoto,
//     String? isFrequent,
//     String? frequentRole,
//   }) async {
//     try {
//       final response = await api.addVisitor(
//         visitorName: visitorName,
//         visitorPhone: visitorPhone,
//         flatNumber: flatNumber,
//         visitType: visitType,
//         vehicleNumber: vehicleNumber,
//         purpose: purpose,
//         visitorPhoto: visitorPhoto,
//         isFrequent: isFrequent,
//         frequentRole: frequentRole,
//       );
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<GetFlatApartmentModel> getFlatApartmentData() async {
//     try {
//       final response = await api.getFlatApartment();
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<VisitorPassResModel> getVisitorPassDataGuard(String id) async {
//     try {
//       final response = await api.getVisitorPassGuard(id);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<GuardProfileModel> guardProfileData() async {
//     try {
//       final response = await api.guardProfileData();
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<MarkOutResModel> markOutData(String id) async {
//     try {
//       final response = await api.markOut(id);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<AddParcelResModel> addParcelData({
//     required String vendorName,
//     required String flatNumber,
//     required String parcelType,
//     required String trackingNumber,
//     required String handlingType,
//     required File parcelPhoto,
//   }) async {
//     try {
//       final response = await api.addParcel(
//         vendorName: vendorName,
//         flatNumber: flatNumber,
//         parcelType: parcelType,
//         trackingNumber: trackingNumber,
//         handlingType: handlingType,
//         parcelPhoto: parcelPhoto,
//       );
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<ParcelHandoverResModel> parcelHandoverData(String id) async {
//     try {
//       final response = await api.parcelHandover(id);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<ParcelHandoverResModel> verifyParcelHandoverData({
//     required String id,
//     String? otp,
//     String? pickupCode,
//   }) async {
//     try {
//       final code = otp ?? pickupCode ?? "";
//       final response = await api.verifyParcelHandover(id, {
//         "otp": code,
//         "pickup_code": code,
//       });
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<GuardCommonResModel> toggleGuardShiftData() async {
//     try {
//       final response = await api.toggleGuardShift();
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<VisitorFormDataResModel> getGuardVisitorFormData() async {
//     try {
//       final response = await api.getGuardVisitorFormData();
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<ScanPassResModel> scanVisitorPassData({
//     required String passCode,
//     String? qrData,
//     String? action, // verify (default) | mark_in | mark_out
//   }) async {
//     try {
//       String cleanCode = passCode.trim();
//       if (cleanCode.contains('PASS:')) {
//         cleanCode = cleanCode.split('PASS:').last.split('|').first;
//       }
//       cleanCode = cleanCode.replaceAll('#', '').trim();

//       final response = await api.scanVisitorPass({
//         "pass_code": cleanCode,
//         "code": cleanCode,
//         if (action != null && action.isNotEmpty) "action": action,
//       });
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<FrequentVisitorsResModel> getFrequentVisitorsData() async {
//     try {
//       final response = await api.getFrequentVisitors();
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<GuardCommonResModel> quickEntryFrequentVisitorData(String id) async {
//     try {
//       final response = await api.quickEntryFrequentVisitor(id);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<RecentVehicleSearchesResModel> getRecentVehicleSearchesData() async {
//     try {
//       final response = await api.getRecentVehicleSearches();
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<GuardCommonResModel> sendGuardSosData({
//     String reason = "Security Alert Triggered at Gate",
//   }) async {
//     try {
//       final response = await api.sendGuardSos({
//         "alert_type": "EMERGENCY_SOS",
//         "reason": reason,
//         "triggered_at": DateTime.now().toIso8601String(),
//       });
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<GuardCommonResModel> verbalApproveVisitorData({
//     required String id,
//     String action = "approved",
//     String? remarks,
//   }) async {
//     try {
//       final response = await api.verbalApproveVisitor(id, {
//         "status": action,
//         "action": action,
//         if (remarks != null) "remarks": remarks,
//       });
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<GuardCommonResModel> respondGuardVisitorData({
//     required String id,
//     required String action,
//   }) async {
//     try {
//       final response = await api.respondGuardVisitor(id, {
//         "action": action,
//         "status": action,
//       });
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<ParcelFormDataResModel> getGuardParcelFormData() async {
//     try {
//       final response = await api.getGuardParcelFormData();
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<GuardCommonResModel> respondGuardParcelData({
//     required String id,
//     required String action,
//   }) async {
//     try {
//       final response = await api.respondGuardParcel(id, {
//         "action": action,
//         "status": action,
//       });
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<ResidentVisitorRespondResModel> respondResidentVisitorData({
//     required String id,
//     required String action,
//     String? remarks,
//   }) async {
//     try {
//       final response = await api.respondResidentVisitor(id, {
//         "action": action,
//         "status": action,
//         if (remarks != null) "remarks": remarks,
//       });
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   /// ==========================================
//   /// COMMITTEE ADD ANNOUNCEMENT API
//   /// POST: https://realestate.gwsstaging.com/api/v1/committee/announcements
//   /// ==========================================
//   Future<AddAnnouncementResModel> addAnnouncement({
//     required String title,
//     required String message,
//     String? type = "maintenance",
//     String? priority = "high",
//     String? targetAudience = "residents",
//     bool? pinned = true,
//   }) async {
//     try {
//       final body = AddAnnouncementBodyModel(
//         title: title,
//         message: message,
//         type: type,
//         priority: priority,
//         targetAudience: targetAudience,
//         pinned: pinned,
//       );

//       log("Add Announcement Payload: ${body.toJson()}");

//       if (dio != null) {
//         final res = await dio!.post(
//           "https://realestate.gwsstaging.com/api/v1/committee/announcements",
//           data: body.toJson(),
//         );
//         log("Add Announcement Response: ${res.data}");
//         return AddAnnouncementResModel.fromJson(res.data);
//       } else {
//         throw Exception("Dio client is not initialized in AuthService");
//       }
//     } catch (e) {
//       log("Error adding announcement: $e");
//       rethrow;
//     }
//   }

//   /// ==========================================
//   /// COMMITTEE GET ANNOUNCEMENTS API
//   /// GET: https://realestate.gwsstaging.com/api/v1/committee/announcements
//   /// ==========================================
//   Future<GetCommitteeAnnouncementModel> getCommitteeAnnouncements() async {
//     try {
//       if (dio != null) {
//         final res = await dio!.get(
//           "https://realestate.gwsstaging.com/api/v1/committee/announcements",
//         );
//         log("Get Committee Announcements Response: ${res.data}");
//         return GetCommitteeAnnouncementModel.fromJson(res.data);
//       } else {
//         throw Exception("Dio client is not initialized in AuthService");
//       }
//     } catch (e) {
//       log("Error fetching committee announcements: $e");
//       rethrow;
//     }
//   }

//   /// ==========================================
//   /// RESIDENT GET ANNOUNCEMENTS API
//   /// GET: https://realestate.gwsstaging.com/api/v1/resident/announcements
//   /// ==========================================
//   Future<GetResidentAnnouncementModel> getResidentAnnouncements() async {
//     try {
//       if (dio != null) {
//         final res = await dio!.get(
//           "https://realestate.gwsstaging.com/api/v1/resident/announcements",
//         );
//         log("Get Resident Announcements Response: ${res.data}");
//         return GetResidentAnnouncementModel.fromJson(res.data);
//       } else {
//         throw Exception("Dio client is not initialized in AuthService");
//       }
//     } catch (e) {
//       log("Error fetching resident announcements: $e");
//       rethrow;
//     }
//   }

//   // ---------- Resident: service request / completion / frequent visitors ----------
//   // Naye endpoints Dio se call ho rahe hain (Retrofit .g.dart regenerate karne ki zaroorat nahi).
//   static const String _base = "https://realestate.gwsstaging.com/api/v1";

//   Future<Map<String, dynamic>> getResidentServiceFormData() async {
//     final res = await dio!.get("$_base/resident/service-requests/form-data");
//     return Map<String, dynamic>.from(res.data as Map);
//   }

//   /// Resident ki taraf se Service Request (multipart: attachment optional).
//   Future<Map<String, dynamic>> createResidentServiceRequest({
//     required String category,
//     required String serviceType,
//     required String title,
//     required String details,
//     required String preferredDate,
//     required String preferredTime,
//     required String priority,
//     MultipartFile? attachment,
//   }) async {
//     final form = FormData.fromMap({
//       'category': category,
//       'service_type': serviceType,
//       'title': title,
//       'description': details,
//       'preferred_date': preferredDate,
//       'preferred_time': preferredTime,
//       'priority': priority.toLowerCase(),
//       if (attachment != null) 'attachment': attachment,
//     });
//     final res = await dio!.post("$_base/resident/service-requests", data: form);
//     return Map<String, dynamic>.from(res.data as Map);
//   }

//   /// Resident khud bolta hai ki kaam ho gaya (association Resolved nahi kar sakti).
//   Future<Map<String, dynamic>> markResidentRequestCompleted({
//     required String id,
//     int? rating,
//     String? feedback,
//   }) async {
//     final res = await dio!.post(
//       "$_base/resident/complaints/$id/complete",
//       data: {
//         if (rating != null) "rating": rating,
//         if (feedback != null && feedback.trim().isNotEmpty)
//           "feedback": feedback.trim(),
//       },
//     );
//     return Map<String, dynamic>.from(res.data as Map);
//   }

//   Future<Map<String, dynamic>> getResidentFrequentVisitors() async {
//     final res = await dio!.get("$_base/resident/frequent-visitors");
//     return Map<String, dynamic>.from(res.data as Map);
//   }
// }

import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationProperty/addUnitBodyModel.dart';
import 'package:property_association_or_resident/Core/Network/ApiStateNetwork.dart';
import 'package:property_association_or_resident/Core/data/model/BodyModel/aiAssistanceBodyModel.dart';
import 'package:property_association_or_resident/Core/data/model/BodyModel/resetPassBodyModel.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/commiteDashboardModel.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/complexDetailsModel.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/documentDetailsModel.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/getAlertModel.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/getPropertyAssistantModel.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/getPropertyUnitDetailsModel.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/getPropertyUnitListModel.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/pendingMaintananceModel.dart';
import 'package:property_association_or_resident/GuardScreen/Model/VehicleSearchResModel.dart';
import 'package:property_association_or_resident/GuardScreen/Model/VisitorPassResModel.dart';
import 'package:property_association_or_resident/GuardScreen/Model/guardDashbordModel.dart';
import 'package:property_association_or_resident/GuardScreen/Model/historyGuardResModel.dart';
import 'package:property_association_or_resident/GuardScreen/Model/historyRecordsModel.dart';
import 'package:property_association_or_resident/ResidentScreen/Model/MaintenanceActivitiesResModel.dart';
import 'package:property_association_or_resident/ResidentScreen/Model/getVisitorPassListModel.dart';
import '../../AssociationScreen/AssociationAuditReport/provider/getInspecitonReportModel.dart';
import '../../AssociationScreen/AssociationAuditReport/provider/getInspectionReportDetailsModel.dart';
import '../../AssociationScreen/AssociationProperty/addUnitResModel.dart';
import '../../GuardScreen/Model/addParcelResModel.dart';
import '../../GuardScreen/Model/addVisitorResModel.dart';
import '../../GuardScreen/Model/getFlatApartmentModel.dart';
import '../../GuardScreen/Model/guardProfileModel.dart';
import '../../GuardScreen/Model/markOutResModel.dart';
import '../../GuardScreen/Model/parcelHandoverResModel.dart';
import '../../ResidentScreen/Model/ResidentCommunityContactResModel.dart';
import '../../ResidentScreen/Model/ResidentEmergencyContactResModel.dart';
import '../../ResidentScreen/Model/ResidentMmcStatusResModel.dart';
import '../../ResidentScreen/Model/ResidentPropertyDetailsResModel.dart';
import '../../ResidentScreen/Model/addResidentComplainResModel.dart';
import '../../ResidentScreen/Model/closeComplaintBodyModel.dart';
import '../../ResidentScreen/Model/complainCloseResModel.dart';
import '../../ResidentScreen/Model/createPassVisitorBodyModel.dart';
import '../../ResidentScreen/Model/createPassVisotroResModel.dart';
import '../../ResidentScreen/Model/getComplaintListModel.dart';
import '../../ResidentScreen/Model/getComplaintTrackingModel.dart';
import '../../ResidentScreen/Model/getPassListResModel.dart';
import '../../ResidentScreen/Model/getResidentCalenderModel.dart';
import '../../ResidentScreen/Model/getResidentParcelModel.dart';
import '../../ResidentScreen/Model/residentParcelRespondBodyModel.dart';
import '../../ResidentScreen/Model/residentParcelRespondResModel.dart';
import '../../ResidentScreen/Model/residentVisitorPassResModel.dart';
import '../../ResidentScreen/Model/residentVisitorRespondResModel.dart';
import '../../ResidentScreen/Model/getResidentProfileModel.dart';
import '../../ResidentScreen/Model/residentDashboardModel.dart';
import '../../GuardScreen/Model/guardCommonResModel.dart';
import '../../GuardScreen/Model/frequentVisitorsResModel.dart';
import '../../GuardScreen/Model/scanPassResModel.dart';
import '../../GuardScreen/Model/visitorFormDataResModel.dart';
import '../../GuardScreen/Model/parcelFormDataResModel.dart';
import '../../GuardScreen/Model/recentVehicleSearchesResModel.dart';
import '../data/model/BodyModel/addResidentBodyModel.dart';
import '../data/model/BodyModel/assocationCalenderBodyModel.dart';
import '../data/model/BodyModel/changePasswordBodyModel.dart';
import '../data/model/BodyModel/forgotPassBodyModel.dart';
import '../data/model/BodyModel/loginBodyModel.dart';
import '../data/model/BodyModel/registerBodyModel.dart';
import '../data/model/BodyModel/updateTicketStatusBodyModel.dart';
import '../data/model/BodyModel/verifyOtpBodyModel.dart';
import '../data/model/ResponseModel/GetGuardShiftsModel.dart';
import '../data/model/ResponseModel/GetNotificaionListModel.dart';
import '../data/model/ResponseModel/MarkNotificationReadResModel.dart';
import '../data/model/ResponseModel/ServiceManagementPerformanceResModel.dart';
import '../data/model/ResponseModel/ServiceManagementResModel.dart';
import '../data/model/ResponseModel/addGuardResModel.dart';
import '../data/model/ResponseModel/addResidentResModel.dart';
import '../data/model/ResponseModel/assocationComplaintResModel.dart';
import '../data/model/ResponseModel/associationCalenderresModel.dart';
import '../data/model/ResponseModel/AssociationReportResModel.dart';
import '../data/model/ResponseModel/changePassResModel.dart';
import '../data/model/ResponseModel/complaintStatusResModel.dart';
import '../data/model/ResponseModel/defaulterDetailsModel.dart';
import '../data/model/ResponseModel/defaulterListModel.dart';
import '../data/model/ResponseModel/editProfileResModel.dart';
import '../data/model/ResponseModel/forgotPassResModel.dart';
import '../data/model/ResponseModel/getAssignedModel.dart';
import '../data/model/ResponseModel/getComplaintDetailsResModel.dart';
import '../data/model/ResponseModel/getDocumentListModel.dart';
import '../data/model/ResponseModel/getProfileModel.dart';
import '../data/model/ResponseModel/getResidentDetailsModel.dart';
import '../data/model/ResponseModel/getResidentResModel.dart';
import '../data/model/ResponseModel/getServiceRequestDetailsModel.dart';
import '../data/model/ResponseModel/getServiceRequestModel.dart';
import '../data/model/ResponseModel/getServiceRequetStatusModel.dart';
import '../data/model/ResponseModel/getUnitsModel.dart';
import '../data/model/ResponseModel/loginResModel.dart';
import '../data/model/ResponseModel/logoutModel.dart';
import '../data/model/ResponseModel/maintananceChargesModel.dart';
import '../data/model/ResponseModel/maintananceDetailsModel.dart';
import '../data/model/ResponseModel/maintananceOverviewModel.dart';
import '../data/model/ResponseModel/maintenanceChargeStatusModel.dart';
import '../data/model/ResponseModel/outstandingPendingModel.dart';
import '../data/model/ResponseModel/serviceWorkOrdersResModel.dart';
import '../data/model/ResponseModel/registerResModel.dart';
import '../data/model/ResponseModel/resetPassResModel.dart';
import '../data/model/ResponseModel/ServiceManagementDetailsResModel.dart';
import '../data/model/ResponseModel/ServiceManagementProviderDetailsResModel.dart';
import '../data/model/BodyModel/addAnnouncementBodyModel.dart';
import '../data/model/ResponseModel/addAnnouncementResModel.dart';
import '../data/model/ResponseModel/getCommitteeAnnouncementModel.dart';
import '../data/model/ResponseModel/residentAnnouncementResModel.dart';
import '../data/model/ResponseModel/verifyOtpResModel.dart';

class AuthService {
  final ApiStateNetwork api;
  final Dio? dio;

  AuthService(this.api, {this.dio});

  Future<GetUnAssignedResModel> getUnassigned() async {
    try {
      final response = await api.getunassigned();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<RegisterResModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    required String role,
    required String complexId,
    required String address,
  }) async {
    try {
      final body = RegisterBodyModel(
        email: email,
        password: password,
        phone: phone,
        name: name,
        role: role,
        confirmPassword: confirmPassword,
        complexId: complexId,
        address: address,
      );
      final response = await api.register(body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<LoginResModel> login({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final body = LoginBodyModel(login: email, password: password, role: role);
      final response = await api.login(body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ForgotPassResModel> forgotPassword({required String email}) async {
    try {
      final body = ForgotPassBodyModel(email: email);
      final response = await api.forgotPass(body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<VerifyOtpResModel> verifyOTP({
    required String email,
    required String otp,
  }) async {
    try {
      final body = VerifyOtpBodyModel(email: email, otp: otp);
      final response = await api.verifyOtp(body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ResetPassResModel> resetPassword({
    required String newPassword,
    required String confirmPassword,
    required String email,
  }) async {
    try {
      final body = ResetPassBodyModel(
        newPassword: newPassword,
        confirmPassword: confirmPassword,
        email: email,
      );
      final response = await api.resetPassword(body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ChangePasswordResModel> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    try {
      final body = ChangePasswordBodyModel(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmNewPassword: confirmNewPassword,
      );
      final response = await api.changePassword(body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetProfileModel> getProfileData({dynamic propertyId}) async {
    try {
      final response = await api.getProfileData(propertyId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<LogoutModel> logout() async {
    try {
      final response = await api.logout();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<EditProfileResModel> editProfile({
    required String name,
    required String phone,
    required MultipartFile? image,
  }) async {
    try {
      final response = await api.editProfile(name, phone, image);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<CommiteDashboardModel> getCommitteeDashboardData() async {
    try {
      final response = await api.getCommitteeDashboardData();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ComplexDetailsModel> getComplexDetails() async {
    try {
      final response = await api.getComplexDetails();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetPropertyUnitListModel> getPropertyUnitList({
    String? status,
    String? block,
    String? search,
  }) async {
    try {
      final response = await api.getPropertyUnitList(
        status: (status != null && status.trim().isNotEmpty)
            ? status.trim()
            : null,
        block: (block != null && block.trim().isNotEmpty) ? block.trim() : null,
        search: (search != null && search.trim().isNotEmpty)
            ? search.trim()
            : null,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetPropertyUnitDetailsModel> getPropertyUnitDetails({
    required String id,
  }) async {
    try {
      final response = await api.getPropertyUnitDetails(id);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetServiceRequestModel> getServiceRequests({
    String? status,
    String? search,
    String? type = "service_request",
  }) async {
    try {
      final response = await api.getServiceRequestList(
        status,
        search,
        type: type,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetServiceRequestDetailsModel> getServiceRequestDetails({
    required String id,
  }) async {
    try {
      final response = await api.getServiceRequestDetails(id);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetServiceRequestStatusModel> getServiceRequestStatus({
    required String id,
  }) async {
    try {
      final response = await api.getServiceRequestStatus(id: id);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetDocumentListModel> getDocumentList({
    required String category,
    required String search,
  }) async {
    try {
      final response = await api.getDocumentList(category, search);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<DocumentDetailsModel> getDocumentDetails({required String id}) async {
    try {
      final response = await api.getDocumentDetails(id);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<MaintananceOverviewModel> getMaintenanceOverview() async {
    try {
      final response = await api.getMaintenanceOverview();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<PendingMaintenanceModel> getPendingMaintanance({
    String? priority,
    String? search,
  }) async {
    try {
      final response = await api.getPendingMaintenance(
        priority: priority,
        search: search,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<MaintananceDetailsModel> getMaintananceDetails({
    required String id,
  }) async {
    try {
      final response = await api.getMaintananceDetails(id);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> updateMaintenanceStatus({
    required String id,
    required String status,
    String? notes,
  }) async {
    try {
      if (dio != null) {
        final res = await dio!.post(
          "https://realestate.gwsstaging.com/api/v1/committee/maintenance/$id/status",
          data: {
            "status": status,
            if (notes != null && notes.isNotEmpty) "notes": notes,
          },
        );
        return res.data;
      }
      return null;
    } catch (e) {
      log("Error updating maintenance status: $e");
      rethrow;
    }
  }

  /// Association / admin: society ka visitor In/Out log (reporting ke liye).
  /// Backend: GET /api/v1/committee/visitor-logs
  Future<Map<String, dynamic>> getCommitteeVisitorLogs({
    String? dateFrom,
    String? dateTo,
    String? status,
    String? search,
    bool onlyInside = false,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final res = await dio!.get(
        "https://realestate.gwsstaging.com/api/v1/committee/visitor-logs",
        queryParameters: {
          if (dateFrom != null && dateFrom.isNotEmpty) "date_from": dateFrom,
          if (dateTo != null && dateTo.isNotEmpty) "date_to": dateTo,
          if (status != null && status.isNotEmpty) "status": status,
          if (search != null && search.isNotEmpty) "search": search,
          if (onlyInside) "only_inside": 1,
          "page": page,
          "per_page": perPage,
        },
      );
      final data = res.data;
      return data is Map<String, dynamic> ? data : <String, dynamic>{};
    } catch (e) {
      log("Error fetching visitor logs: $e");
      rethrow;
    }
  }

  Future<MaintananceChargesModel> getMaintananceCharges() async {
    try {
      final response = await api.getMaintananceCharges();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<MaintananceChargeStatusModel> maintenanceChargeStatus({
    required String tab,
  }) async {
    try {
      final response = await api.maintenanceChargeStatus(tab);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<DefaulterListResModel> getDefaulterList({
    required String filter,
    required String search,
  }) async {
    try {
      final response = await api.getDefaulterList(filter, search);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ServiceWorkOrdersResModel> getServiceWorkOrders({
    String? status,
    String? search,
  }) async {
    try {
      final response = await api.getServiceWorkOrders(
        status: status,
        search: search,
      );
      return response;
    } catch (e) {
      log("Error fetching service work orders: $e");
      rethrow;
    }
  }

  Future<AddUnitResModel> addUnit({
    required String name,
    required String area,
    required String bedroom,
    required String floor,
    required String location,
    String? block, // Block dropdown se ("Block A" ...)
  }) async {
    try {
      final body = AddUnitBodyModel(
        unitNumber: name,
        block: block,
        area: area,
        bedrooms: bedroom,
        floor: floor,
        location: location,
      );
      final response = await api.addUnit(body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<DefaulterDetailsModel> getDefaulterDetails({
    required String id,
  }) async {
    try {
      final response = await api.getDefaulterDetails(id);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> sendDefaulterReminder({required String id}) async {
    try {
      if (dio != null) {
        final res = await dio!.post(
          "https://realestate.gwsstaging.com/api/v1/committee/charges/defaulters/$id/send-reminder",
          data: {},
        );
        return res.data;
      }
      return null;
    } catch (e) {
      log("Error sending defaulter reminder: $e");
      rethrow;
    }
  }

  Future<dynamic> receiveDefaulterPay({
    required String id,
    required dynamic amount,
    required String paidVia,
    required String paymentDate,
    String? notes,
  }) async {
    try {
      if (dio != null) {
        final num? parsedAmount = num.tryParse(amount.toString());
        final res = await dio!.post(
          "https://realestate.gwsstaging.com/api/v1/committee/charges/defaulters/$id/receive-pay",
          data: {
            "paid_via": paidVia,
            "amount": parsedAmount ?? amount,
            "payment_date": paymentDate,
            if (notes != null && notes.isNotEmpty) "notes": notes,
          },
        );
        return res.data;
      }
      return null;
    } catch (e) {
      log("Error receiving defaulter pay: $e");
      rethrow;
    }
  }

  Future<dynamic> toggleDefaulterStatus({required String id}) async {
    try {
      if (dio != null) {
        final res = await dio!.post(
          "https://realestate.gwsstaging.com/api/v1/committee/charges/defaulters/$id/toggle-status",
          data: {},
        );
        return res.data;
      }
      return null;
    } catch (e) {
      log("Error toggling defaulter status: $e");
      rethrow;
    }
  }

  ///////////////////////////////////
  ///
  Future<AssociationComplaintResModel> getComplaintData({
    required String status,
    required String search,
    String? type = "complaint",
  }) async {
    try {
      final response = await api.getComplaintData(status, search, type: type);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetComplaintDetailsResModel> getComplaintDetails({
    required String id,
  }) async {
    try {
      final response = await api.getComplaintDetails(id);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> updateTicketStatus({
    required String id,
    required String status,
  }) async {
    try {
      final body = UpdateTicketStatusBodyModel(status: status);
      final response = await api.updateTicketStatus(id, body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> createServiceTicket({
    required String serviceCategory,
    String? serviceType,
    required String title,
    required String details,
    String? preferredDate,
    String? preferredTime,
    required String priority,
    MultipartFile? attachment,
    required String type,
    int? propertyId,
  }) async {
    try {
      final response = await api.createService(
        serviceCategory,
        serviceType,
        title,
        details,
        preferredDate,
        preferredTime,
        priority,
        attachment,
        type,
        propertyId,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> createComplaintTicket({
    required String serviceCategory,
    String? serviceType,
    required String title,
    required String details,
    String? preferredDate,
    String? preferredTime,
    required String priority,
    MultipartFile? attachment,
    int? propertyId,
  }) async {
    return await createServiceTicket(
      serviceCategory: serviceCategory,
      serviceType: serviceType,
      title: title,
      details: details,
      preferredDate: preferredDate,
      preferredTime: preferredTime,
      priority: priority,
      attachment: attachment,
      type: "complaint",
      propertyId: propertyId,
    );
  }

  Future<ComplaintStatusResModel> getComplaintStatus({
    required String id,
  }) async {
    try {
      final response = await api.complaintStatus(id);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<OutstandingPendingModel> getOutstandingPending({
    required String filter,
    required String search,
  }) async {
    try {
      final response = await api.getOutstatndingPedning(filter, search);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /////////////////////////////////// Resident /////////////////

  Future<GetUnitsModel> getAvailableUnits() async {
    try {
      final units = await api.getAvailableUnits();
      return units;
    } catch (e) {
      rethrow;
    }
  }

  Future<AddResidentResModel> addResident({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    required String unitNumber,
    required bool termsAccepted,
    required String residentType,
    String? vehicleNumber,
  }) async {
    try {
      final body = AddResedentBodyModel(
        name: name,
        email: email,
        phone: phone,
        password: password,
        confirmPassword: confirmPassword,
        unitNumber: unitNumber,
        termsAccepted: termsAccepted,
        residentType: residentType,
        vehicleNumber: vehicleNumber,
      );
      final response = await api.addResident(body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetResidentListModel> getResidentList() async {
    try {
      final response = await api.getResidentList();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetResidentDetailsModel> getResidentDetails({
    required String id,
  }) async {
    try {
      final response = await api.getResidentDetails(id);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetAlertModel> getAlerts({required String filter}) async {
    try {
      final response = await api.getAlerts(filter);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetNotificaionListModel> getNotificaionList({
    required String filter,
  }) async {
    try {
      final response = await api.getNotificaionList(filter);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<MarkNotificationReadResModel> markNotificationRead({
    required String id,
  }) async {
    try {
      final response = await api.markNotificationRead(id);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<MarkNotificationReadResModel?> markMultipleNotificationsRead({
    required List<String> ids,
  }) async {
    if (ids.isEmpty) return null;
    try {
      final joinedIds = ids.join(',');
      final response = await api.markNotificationRead(joinedIds);
      return response;
    } catch (e) {
      log("Error marking notifications as read: $e");
      return null;
    }
  }

  Future<AssociationCalenderResModel> addAssociationCalendar({
    required String eventName,
    required String eventType,
    required String visitDate,
    required String visitTime,
    required String endTime,
    required String organizedBy,
    required String eventFor,
    required String description,
    required String location,
  }) async {
    try {
      final body = AssociationCalenderBodyModel(
        eventName: eventName,
        eventType: eventType,
        visitDate: DateTime.parse(visitDate),
        visitTime: visitTime,
        endTime: endTime,
        organizedBy: organizedBy,
        eventFor: eventFor,
        description: description,
        location: location,
      );
      final response = await api.addAssociationCalendar(body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetPropertyAssistantModel> getPropertyAssistant() async {
    try {
      final response = await api.getPropertyAssistant();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetPropertyAssistantModel> sendMessageToAi({
    required String query,
  }) async {
    try {
      final body = AiAssistanceBodyModel(query: query);
      final response = await api.sendMessageToAi(body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ServiceManagementResModelDart> getServiceManagementData({
    required String status,
    required String search,
  }) async {
    try {
      final queryStatus = status.isEmpty || status.toLowerCase() == "all"
          ? null
          : status;
      final querySearch = search.trim().isEmpty ? null : search.trim();
      final response = await api.getServiceManagement(queryStatus, querySearch);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ServiceManagementDetailsResModel> serviceManagementDetailsData({
    required String id,
  }) async {
    try {
      final response = await api.serviceManagementDetails(id);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ServiceManagementProviderDetailsResModel>
  serviceManagementProviderDetailsData({required String id}) async {
    try {
      final response = await api.serviceManagementProviderDetails(id);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ServiceManagementPerformanceResModel>
  serviceManagementPerformanceData({required String id}) async {
    try {
      final response = await api.serviceManagementPerformance(id);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<AssociationReportResModel> associationReportData({
    required String status,
    required String search,
  }) async {
    try {
      final response = await api.associationReport(status, search);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetInspectionReportModel> getInspectionReport({
    required String filter,
    required String type,
    dynamic propertyId,
  }) async {
    try {
      final response = await api.getInspectionReport(filter, type, propertyId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetInspectionReportDetailsModel> getInspectionReportDetails({
    required String id,
  }) async {
    try {
      final response = await api.getInpectionReportDetails(id);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<AddGuardResModel> addGuardData({
    required String name,
    required String phone,
    required String password,
    required String guardPost,
    required String shiftId,
    required String email,
    required MultipartFile? image,
  }) async {
    try {
      final response = await api.addGuard(
        name,
        phone,
        password,
        guardPost,
        shiftId,
        email,
        image,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetGuardShiftsModel> getGuardShifts() async {
    try {
      final response = await api.getGuardShifts();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //////////////////////////  resident dashboard   //////////////////////

  Future<ResidentDashbordModel> getResidentDashboardData() async {
    try {
      final response = await api.getResidentDashbordData();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetResidentProfileModel> getResidentProfileData() async {
    try {
      final response = await api.getResidentProfileData();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<AddResidentComplaintResModel> addResidentComplaintData({
    required String category,
    required String subject,
    required String description,
    required MultipartFile? photo,
    String? areaType,
    String? location,
    String? priority,
  }) async {
    try {
      final response = await api.addResidentComplaint(
        category,
        subject,
        description,
        photo,
        areaType: areaType,
        location: location,
        priority: priority,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Future<GetComplaintRequestListModel> getComplaintFormData() async {
  //   try {
  //     final response = await api.getComplaintFormData();
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<GetComplaintListModel> getComplaintList({
    required String status,
  }) async {
    try {
      final response = await api.getComplaintList(status: status);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetComplaintTrackingModel> getComplaintTracking({
    required String id,
  }) async {
    try {
      final response = await api.getComplaintTracking(id);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ResidentMmcStatusResModel> residentMmnStatusData() async {
    try {
      final response = await api.residentMmcStatus();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ResidentPropertyDetailsResModel> residentPropertyDetailsData() async {
    try {
      final response = await api.residentPropertyDetails();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ResidentCommunityContactResModel> residentCommunityContact() async {
    try {
      final response = await api.residentCommunityContact();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<CreatVisitorPassResModdel> createVisitorPassRequest({
    required String visitorName,
    required String mobileNumber,
    required String visitorType,
    required String visitDate,
    required String visitTime,
    required String purposeOfVisit,
    bool isFrequent = false,
    String? frequentRole,
  }) async {
    try {
      final body = CreateVisitorPassBodyModdel(
        visitorName: visitorName,
        mobileNumber: mobileNumber,
        visitorType: visitorType,
        visitDate: visitDate,
        visitTime: visitTime,
        purposeOfVisit: purposeOfVisit,
        isFrequent: isFrequent,
        frequentRole: frequentRole,
      );
      final response = await api.createVisitorPassRequest(body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetVisitorPassListModel> getVisitorPass() async {
    try {
      final response = await api.getVisitorPass();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetResidentCalenderModel> getResidentCalender({String? month}) async {
    try {
      final response = await api.getResidentCalender(month: month);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ResidentEmergencyContactResModel> emergencyContactData() async {
    try {
      final response = await api.emergencyContact();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ComplainCloseResModel> closeComplant({
    required String id,
    String? reason,
    String? remarks,
  }) async {
    try {
      final body = ComplainCloseBodyModel(
        status: "closed",
        residentStatus: "closed",
      );
      final response = await api.closeComplant(id, body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetResidentParcelModel> getResidentParcel() async {
    try {
      final response = await api.getResidentParcel();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ResidentParcelRespondResModel> respondResidentParcelData({
    required String parcelId,
    required String action,
    String? deliveryMode,
    String? remarks,
  }) async {
    try {
      final body = ResidentParcelRespondBodyModel(
        action: action,
        deliveryMode: deliveryMode,
        remarks: remarks,
      );
      final response = await api.respondResidentParcel(parcelId, body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ResidnetVisitorPassResModel> getresideitVisitorPassData() async {
    try {
      final response = await api.getresideitVisitorPass();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<MaintenanceActivitiesResModel> maintenanceActivitiesData() async {
    try {
      final response = await api.maintenanceActive();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetPassListResModel> getPass() async {
    try {
      final response = await api.getPass();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  ////////////////// Guard //////////////////////

  Future<GuardDashBoardModel> guardDashBoardData() async {
    try {
      final response = await api.guardDashBoard();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<HistoryRecordsResModel> historyRecordsData(String filter) async {
    try {
      final response = await api.historyRecords(filter);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<VehicleSearchResModel> vehicleSearchData(String vehicleNumber) async {
    try {
      final response = await api.vehicleSearch(vehicleNumber);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<HistoryGuardResModel> historyGuardData() async {
    try {
      final response = await api.historyGuard();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<AddVisitorResModel> addVisitorData({
    required String visitorName,
    required String visitorPhone,
    required String flatNumber,
    required String visitType,
    required String vehicleNumber,
    required String purpose,
    File? visitorPhoto,
    String? isFrequent,
    String? frequentRole,
  }) async {
    try {
      final response = await api.addVisitor(
        visitorName: visitorName,
        visitorPhone: visitorPhone,
        flatNumber: flatNumber,
        visitType: visitType,
        vehicleNumber: vehicleNumber,
        purpose: purpose,
        visitorPhoto: visitorPhoto,
        isFrequent: isFrequent,
        frequentRole: frequentRole,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetFlatApartmentModel> getFlatApartmentData() async {
    try {
      final response = await api.getFlatApartment();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<VisitorPassResModel> getVisitorPassDataGuard(String id) async {
    try {
      final response = await api.getVisitorPassGuard(id);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GuardProfileModel> guardProfileData() async {
    try {
      final response = await api.guardProfileData();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<MarkOutResModel> markOutData(String id) async {
    try {
      final response = await api.markOut(id);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<AddParcelResModel> addParcelData({
    required String vendorName,
    required String flatNumber,
    required String parcelType,
    required String trackingNumber,
    required String handlingType,
    required File parcelPhoto,
  }) async {
    try {
      final response = await api.addParcel(
        vendorName: vendorName,
        flatNumber: flatNumber,
        parcelType: parcelType,
        trackingNumber: trackingNumber,
        handlingType: handlingType,
        parcelPhoto: parcelPhoto,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ParcelHandoverResModel> parcelHandoverData(String id) async {
    try {
      final response = await api.parcelHandover(id);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ParcelHandoverResModel> verifyParcelHandoverData({
    required String id,
    String? otp,
    String? pickupCode,
  }) async {
    try {
      final code = otp ?? pickupCode ?? "";
      final response = await api.verifyParcelHandover(id, {
        "otp": code,
        "pickup_code": code,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GuardCommonResModel> toggleGuardShiftData() async {
    try {
      final response = await api.toggleGuardShift();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<VisitorFormDataResModel> getGuardVisitorFormData() async {
    try {
      final response = await api.getGuardVisitorFormData();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ScanPassResModel> scanVisitorPassData({
    required String passCode,
    String? qrData,
    String? action, // verify (default) | mark_in | mark_out
  }) async {
    try {
      String cleanCode = passCode.trim();
      if (cleanCode.contains('PASS:')) {
        cleanCode = cleanCode.split('PASS:').last.split('|').first;
      }
      cleanCode = cleanCode.replaceAll('#', '').trim();

      final response = await api.scanVisitorPass({
        "pass_code": cleanCode,
        "code": cleanCode,
        if (action != null && action.isNotEmpty) "action": action,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<FrequentVisitorsResModel> getFrequentVisitorsData() async {
    try {
      final response = await api.getFrequentVisitors();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GuardCommonResModel> quickEntryFrequentVisitorData(String id) async {
    try {
      final response = await api.quickEntryFrequentVisitor(id);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<RecentVehicleSearchesResModel> getRecentVehicleSearchesData() async {
    try {
      final response = await api.getRecentVehicleSearches();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GuardCommonResModel> sendGuardSosData({
    String reason = "Security Alert Triggered at Gate",
  }) async {
    try {
      final response = await api.sendGuardSos({
        "alert_type": "EMERGENCY_SOS",
        "reason": reason,
        "triggered_at": DateTime.now().toIso8601String(),
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GuardCommonResModel> verbalApproveVisitorData({
    required String id,
    String action = "approved",
    String? remarks,
  }) async {
    try {
      final response = await api.verbalApproveVisitor(id, {
        "status": action,
        "action": action,
        if (remarks != null) "remarks": remarks,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GuardCommonResModel> respondGuardVisitorData({
    required String id,
    required String action,
  }) async {
    try {
      final response = await api.respondGuardVisitor(id, {
        "action": action,
        "status": action,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ParcelFormDataResModel> getGuardParcelFormData() async {
    try {
      final response = await api.getGuardParcelFormData();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GuardCommonResModel> respondGuardParcelData({
    required String id,
    required String action,
  }) async {
    try {
      final response = await api.respondGuardParcel(id, {
        "action": action,
        "status": action,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ResidentVisitorRespondResModel> respondResidentVisitorData({
    required String id,
    required String action,
    String? remarks,
  }) async {
    try {
      final response = await api.respondResidentVisitor(id, {
        "action": action,
        "status": action,
        if (remarks != null) "remarks": remarks,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// ==========================================
  /// COMMITTEE ADD ANNOUNCEMENT API
  /// POST: https://realestate.gwsstaging.com/api/v1/committee/announcements
  /// ==========================================
  Future<AddAnnouncementResModel> addAnnouncement({
    required String title,
    required String message,
    String? type = "maintenance",
    String? priority = "high",
    String? targetAudience = "residents",
    bool? pinned = true,
  }) async {
    try {
      final body = AddAnnouncementBodyModel(
        title: title,
        message: message,
        type: type,
        priority: priority,
        targetAudience: targetAudience,
        pinned: pinned,
      );

      log("Add Announcement Payload: ${body.toJson()}");

      if (dio != null) {
        final res = await dio!.post(
          "https://realestate.gwsstaging.com/api/v1/committee/announcements",
          data: body.toJson(),
        );
        log("Add Announcement Response: ${res.data}");
        return AddAnnouncementResModel.fromJson(res.data);
      } else {
        throw Exception("Dio client is not initialized in AuthService");
      }
    } catch (e) {
      log("Error adding announcement: $e");
      rethrow;
    }
  }

  /// ==========================================
  /// COMMITTEE GET ANNOUNCEMENTS API
  /// GET: https://realestate.gwsstaging.com/api/v1/committee/announcements
  /// ==========================================
  Future<GetCommitteeAnnouncementModel> getCommitteeAnnouncements() async {
    try {
      if (dio != null) {
        final res = await dio!.get(
          "https://realestate.gwsstaging.com/api/v1/committee/announcements",
        );
        log("Get Committee Announcements Response: ${res.data}");
        return GetCommitteeAnnouncementModel.fromJson(res.data);
      } else {
        throw Exception("Dio client is not initialized in AuthService");
      }
    } catch (e) {
      log("Error fetching committee announcements: $e");
      rethrow;
    }
  }

  /// ==========================================
  /// RESIDENT GET ANNOUNCEMENTS API
  /// GET: https://realestate.gwsstaging.com/api/v1/resident/announcements
  /// ==========================================
  Future<GetResidentAnnouncementModel> getResidentAnnouncements() async {
    try {
      if (dio != null) {
        final res = await dio!.get(
          "https://realestate.gwsstaging.com/api/v1/resident/announcements",
        );
        log("Get Resident Announcements Response: ${res.data}");
        return GetResidentAnnouncementModel.fromJson(res.data);
      } else {
        throw Exception("Dio client is not initialized in AuthService");
      }
    } catch (e) {
      log("Error fetching resident announcements: $e");
      rethrow;
    }
  }

  // ---------- Resident: service request / completion / frequent visitors ----------
  // Naye endpoints Dio se call ho rahe hain (Retrofit .g.dart regenerate karne ki zaroorat nahi).
  static const String _base = "https://realestate.gwsstaging.com/api/v1";

  Future<Map<String, dynamic>> getResidentServiceFormData() async {
    final res = await dio!.get("$_base/resident/service-requests/form-data");
    return Map<String, dynamic>.from(res.data as Map);
  }

  /// Resident ki taraf se Service Request (multipart: attachment optional).
  Future<Map<String, dynamic>> createResidentServiceRequest({
    required String category,
    required String serviceType,
    required String title,
    required String details,
    required String preferredDate,
    required String preferredTime,
    required String priority,
    MultipartFile? attachment,
  }) async {
    final form = FormData.fromMap({
      'category': category,
      'service_type': serviceType,
      'title': title,
      'description': details,
      'preferred_date': preferredDate,
      'preferred_time': preferredTime,
      'priority': priority.toLowerCase(),
      if (attachment != null) 'attachment': attachment,
    });
    final res = await dio!.post("$_base/resident/service-requests", data: form);
    return Map<String, dynamic>.from(res.data as Map);
  }

  /// Resident khud bolta hai ki kaam ho gaya (association Resolved nahi kar sakti).
  Future<Map<String, dynamic>> markResidentRequestCompleted({
    required String id,
    int? rating,
    String? feedback,
  }) async {
    final res = await dio!.post(
      "$_base/resident/complaints/$id/complete",
      data: {
        if (rating != null) "rating": rating,
        if (feedback != null && feedback.trim().isNotEmpty)
          "feedback": feedback.trim(),
      },
    );
    return Map<String, dynamic>.from(res.data as Map);
  }

  Future<Map<String, dynamic>> getResidentFrequentVisitors() async {
    final res = await dio!.get("$_base/resident/frequent-visitors");
    return Map<String, dynamic>.from(res.data as Map);
  }
}
