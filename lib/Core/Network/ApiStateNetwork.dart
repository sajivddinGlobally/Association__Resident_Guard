import 'dart:io';
import 'package:dio/dio.dart';
import 'package:property_association_or_resident/Core/data/model/BodyModel/aiAssistanceBodyModel.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/complexDetailsModel.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/defaulterDetailsModel.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/documentDetailsModel.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/getPropertyAssistantModel.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/getPropertyUnitDetailsModel.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/getPropertyUnitListModel.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/getResidentDetailsModel.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/getServiceRequestModel.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/getServiceRequetStatusModel.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/maintananceChargesModel.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/maintananceDetailsModel.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/outstandingPendingModel.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/pendingMaintananceModel.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/serviceWorkOrdersResModel.dart';
import 'package:property_association_or_resident/GuardScreen/Model/VehicleSearchResModel.dart';
import 'package:property_association_or_resident/GuardScreen/Model/VisitorPassResModel.dart';
import 'package:property_association_or_resident/GuardScreen/Model/guardDashbordModel.dart';
import 'package:property_association_or_resident/GuardScreen/Model/historyGuardResModel.dart';
import 'package:property_association_or_resident/GuardScreen/Model/historyRecordsModel.dart';
import 'package:property_association_or_resident/ResidentScreen/Model/MaintenanceActivitiesResModel.dart';
import 'package:property_association_or_resident/ResidentScreen/Model/getComplaintListModel.dart';
import 'package:property_association_or_resident/ResidentScreen/Model/getComplaintTrackingModel.dart';
import 'package:property_association_or_resident/ResidentScreen/Model/getVisitorPassListModel.dart';
import 'package:retrofit/retrofit.dart';
import '../../AssociationScreen/AssociationAuditReport/provider/getInspecitonReportModel.dart';
import '../../AssociationScreen/AssociationAuditReport/provider/getInspectionReportDetailsModel.dart';
import '../../AssociationScreen/AssociationProperty/addUnitBodyModel.dart';
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
import '../../ResidentScreen/Model/createPassVisotroResModel.dart';
import '../../ResidentScreen/Model/createPassVisitorBodyModel.dart';
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
import '../data/model/BodyModel/resetPassBodyModel.dart'
    show ResetPassBodyModel;
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
import '../data/model/ResponseModel/commiteDashboardModel.dart';
import '../data/model/ResponseModel/complaintStatusResModel.dart';
import '../data/model/ResponseModel/defaulterListModel.dart';
import '../data/model/ResponseModel/forgotPassResModel.dart';
import '../data/model/ResponseModel/getAlertModel.dart';
import '../data/model/ResponseModel/getAssignedModel.dart';
import '../data/model/ResponseModel/getComplaintDetailsResModel.dart';
import '../data/model/ResponseModel/getDocumentListModel.dart';
import '../data/model/ResponseModel/getProfileModel.dart';
import '../data/model/ResponseModel/getResidentResModel.dart';
import '../data/model/ResponseModel/getServiceRequestDetailsModel.dart';
import '../data/model/ResponseModel/getUnitsModel.dart';
import '../data/model/ResponseModel/loginResModel.dart';
import '../data/model/ResponseModel/logoutModel.dart';
import '../data/model/ResponseModel/maintananceOverviewModel.dart';
import '../data/model/ResponseModel/maintenanceChargeStatusModel.dart';
import '../data/model/ResponseModel/registerResModel.dart';
import '../data/model/ResponseModel/resetPassResModel.dart';
import '../data/model/ResponseModel/ServiceManagementDetailsResModel.dart';
import '../data/model/ResponseModel/ServiceManagementProviderDetailsResModel.dart';
import '../data/model/ResponseModel/verifyOtpResModel.dart';
import '../data/model/ResponseModel/editProfileResModel.dart';

part 'ApiStateNetwork.g.dart';

@RestApi(baseUrl: "https://realestate.gwsstaging.com")
abstract class ApiStateNetwork {
  factory ApiStateNetwork(Dio dio, {String baseUrl}) = _ApiStateNetwork;

  @GET("/api/v1/complexes/unassigned-head")
  Future<GetUnAssignedResModel> getunassigned();

  @POST("/api/v1/auth/register")
  Future<RegisterResModel> register(@Body() RegisterBodyModel body);

  @POST("/api/v1/auth/login")
  Future<LoginResModel> login(@Body() LoginBodyModel body);

  @POST("/api/v1/auth/forgot-password")
  Future<ForgotPassResModel> forgotPass(@Body() ForgotPassBodyModel body);

  @POST("/api/v1/auth/verify-otp")
  Future<VerifyOtpResModel> verifyOtp(@Body() VerifyOtpBodyModel body);

  @POST("/api/v1/auth/reset-password")
  Future<ResetPassResModel> resetPassword(@Body() ResetPassBodyModel body);

  @PUT("/api/v1/auth/password")
  Future<ChangePasswordResModel> changePassword(
    @Body() ChangePasswordBodyModel body,
  );

  @GET("/api/v1/auth/me")
  Future<GetProfileModel> getProfileData(@Query("property_id") int? propertyId);

  @POST("/api/v1/auth/logout")
  Future<LogoutModel> logout();

  @MultiPart()
  @POST("/api/v1/auth/profile")
  Future<EditProfileResModel> editProfile(
    @Part(name: "name") String name,
    @Part(name: "phone") String phone,
    @Part(name: "image") MultipartFile? image,
  );

  @GET("/api/v1/committee/dashboard")
  Future<CommiteDashboardModel> getCommitteeDashboardData();

  @GET("/api/v1/committee/complex/details")
  Future<ComplexDetailsModel> getComplexDetails();

  @GET("/api/v1/committee/units")
  Future<GetPropertyUnitListModel> getPropertyUnitList({
    @Query("status") String? status,
    @Query("block") String? block,
    @Query("search") String? search,
  });

  @GET("/api/v1/committee/units/{id}")
  Future<GetPropertyUnitDetailsModel> getPropertyUnitDetails(
    @Path("id") String id,
  );

  @GET("/api/v1/committee/service-requests")
  Future<GetServiceRequestModel> getServiceRequestList(
    @Query("status") String? status,
    @Query("search") String? search, {
    @Query("type") String? type,
  });

  @GET("/api/v1/committee/tickets/{id}/details")
  Future<GetServiceRequestDetailsModel> getServiceRequestDetails(
    @Path("id") String id,
  );

  @POST("/api/v1/committee/tickets/{id}/status")
  Future<dynamic> updateTicketStatus(
    @Path("id") String id,
    @Body() UpdateTicketStatusBodyModel body,
  );

  @MultiPart()
  @POST("/api/v1/tickets")
  Future<dynamic> createService(
    @Part(name: "service_category") String serviceCategory,
    @Part(name: "service_type") String? serviceType,
    @Part(name: "title") String title,
    @Part(name: "details") String details,
    @Part(name: "preferred_date") String? preferredDate,
    @Part(name: "preferred_time") String? preferredTime,
    @Part(name: "priority") String priority,
    @Part(name: "attachment") MultipartFile? attachment,
    @Part(name: "type") String type,
    @Part(name: "property_id") int? propertyId,
  );

  @GET("/api/v1/committee/service-requests/{id}/tracking")
  Future<GetServiceRequestStatusModel> getServiceRequestStatus({
    @Path("id") required String id,
  });

  @GET("/api/v1/committee/documents")
  Future<GetDocumentListModel> getDocumentList(
    @Query("category") String category,
    @Query("search") String search,
  );

  @GET("/api/v1/committee/documents/{id}")
  Future<DocumentDetailsModel> getDocumentDetails(@Path('id') String id);

  @GET("/api/v1/committee/maintenance/overview")
  Future<MaintananceOverviewModel> getMaintenanceOverview();

  @GET("/api/v1/committee/maintenance/pending")
  Future<PendingMaintenanceModel> getPendingMaintenance({
    @Query("priority") String? priority,
    @Query("search") String? search,
  });

  @GET("/api/v1/committee/maintenance/{id}/details")
  Future<MaintananceDetailsModel> getMaintananceDetails(@Path("id") String id);

  @GET("/api/v1/committee/charges/overview")
  Future<MaintananceChargesModel> getMaintananceCharges();

  @GET("/api/v1/committee/charges/status")
  Future<MaintananceChargeStatusModel> maintenanceChargeStatus(
    @Query('tab') String tab,
  );

  @GET("/api/v1/committee/charges/defaulters")
  Future<DefaulterListResModel> getDefaulterList(
    @Query('filter') String filter,
    @Query('search') String search,
  );

  @GET("/api/v1/committee/charges/defaulters/{id}")
  Future<DefaulterDetailsModel> getDefaulterDetails(@Path("id") String id);

  @GET("/api/v1/committee/service-work-orders")
  Future<ServiceWorkOrdersResModel> getServiceWorkOrders({
    @Query("status") String? status,
    @Query("search") String? search,
  });

  @POST("/api/v1/committee/units")
  Future<AddUnitResModel> addUnit(@Body() AddUnitBodyModel body);

  /////////////////////////
  @GET("/api/v1/committee/complaints")
  Future<AssociationComplaintResModel> getComplaintData(
    @Query("status") String? status,
    @Query("search") String? search, {
    @Query("type") String? type,
  });

  @GET("/api/v1/committee/complaints/{id}")
  Future<GetComplaintDetailsResModel> getComplaintDetails(
    @Path("id") String id,
  );
  @GET("/api/v1/committee/complaints/{id}/status")
  Future<ComplaintStatusResModel> complaintStatus(@Path("id") String id);

  @GET("/api/v1/committee/charges/pending")
  Future<OutstandingPendingModel> getOutstatndingPedning(
    @Query('filter') String filter,
    @Query('search') String search,
  );

  @GET("/api/v1/committee/units/available")
  Future<GetUnitsModel> getAvailableUnits();

  @POST("/api/v1/committee/residents")
  Future<AddResidentResModel> addResident(@Body() AddResedentBodyModel body);

  @GET("/api/v1/committee/residents")
  Future<GetResidentListModel> getResidentList();

  @GET("/api/v1/committee/residents/{id}")
  Future<GetResidentDetailsModel> getResidentDetails(@Path('id') String id);

  @GET("/api/v1/committee/alerts")
  Future<GetAlertModel> getAlerts(@Query('filter') String filter);

  @GET("/api/v1/notifications")
  Future<GetNotificaionListModel> getNotificaionList(
    @Query("filter") String filter,
  );

  @POST("/api/v1/notifications/{id}/read")
  Future<MarkNotificationReadResModel> markNotificationRead(
    @Path("id") String id,
  );

  @POST("/api/v1/association-calendar")
  Future<AssociationCalenderResModel> addAssociationCalendar(
    @Body() AssociationCalenderBodyModel body,
  );

  @GET("/api/v1/ai/property-assistant")
  Future<GetPropertyAssistantModel> getPropertyAssistant();

  @POST("/api/v1/ai/property-assistant")
  Future<GetPropertyAssistantModel> sendMessageToAi(
    @Body() AiAssistanceBodyModel body,
  );

  @GET("/api/v1/services")
  Future<ServiceManagementResModelDart> getServiceManagement(
    @Query("status") String? status,
    @Query("search") String? search,
  );

  @GET("/api/v1/services/{id}")
  Future<ServiceManagementDetailsResModel> serviceManagementDetails(
    @Path("id") String id,
  );

  @GET("/api/v1/services/{id}/provider")
  Future<ServiceManagementProviderDetailsResModel>
  serviceManagementProviderDetails(@Path("id") String id);

  @GET("/api/v1/services/{id}/performance")
  Future<ServiceManagementPerformanceResModel> serviceManagementPerformance(
    @Path("id") String id,
  );

  @GET("/api/v1/committee/reports")
  Future<AssociationReportResModel> associationReport(
    @Query("category") String? status,
    @Query("search") String? search,
  );

  @GET("/api/v1/inspections")
  Future<GetInspectionReportModel> getInspectionReport(
    @Query("filter") String filter,
    @Query("type") String type,
    @Query("property_id") int? propertyId,
  );

  @GET("/api/v1/inspections/{id}")
  Future<GetInspectionReportDetailsModel> getInpectionReportDetails(
    @Path('id') String id,
  );

  @MultiPart()
  @POST("/api/v1/committee/guards")
  Future<AddGuardResModel> addGuard(
    @Part(name: "name") String name,
    @Part(name: "phone") String phone,
    @Part(name: "password") String password,
    @Part(name: "guard_post") String guardPostId,
    @Part(name: "shift_id") String shiftId,
    @Part(name: "email") String email,
    @Part(name: "avatar") MultipartFile? image,
  );

  @GET("/api/v1/committee/shifts")
  Future<GetGuardShiftsModel> getGuardShifts();

  /////////////////////////////// resident dashbord ////////////////
  @GET("/api/v1/resident/dashboard")
  Future<ResidentDashbordModel> getResidentDashbordData();

  @GET("/api/v1/auth/me")
  Future<GetResidentProfileModel> getResidentProfileData();

  @MultiPart()
  @POST("/api/v1/resident/complaints")
  Future<AddResidentComplaintResModel> addResidentComplaint(
    @Part(name: "category") String category,
    @Part(name: "subject") String subject,
    @Part(name: "description") String description,
    @Part(name: "photo") MultipartFile? photo, {
    @Part(name: "area_type") String? areaType,
    @Part(name: "location") String? location,
    @Part(name: "priority") String? priority,
  });

  // @GET("/api/v1/resident/complaints/form-data")
  // Future<GetComplaintRequestListModel> getComplaintFormData();

  @GET("/api/v1/resident/complaints")
  Future<GetComplaintListModel> getComplaintList({
    @Query("status") String? status,
  });

  @GET("/api/v1/resident/complaints/{id}")
  Future<GetComplaintTrackingModel> getComplaintTracking(@Path('id') String id);

  @GET("/api/v1/resident/mmc-status")
  Future<ResidentMmcStatusResModel> residentMmcStatus();

  @GET("/api/v1/resident/property/details")
  Future<ResidentPropertyDetailsResModel> residentPropertyDetails();

  @GET("/api/v1/resident/communication")
  Future<ResidentCommunityContactResModel> residentCommunityContact();

  @GET("/api/v1/resident/visitor-pass")
  Future<GetVisitorPassListModel> getVisitorPass();

  @GET("/api/v1/resident/calendar")
  Future<GetResidentCalenderModel> getResidentCalender({
    @Query("month") String? month,
  });

  @GET("/api/v1/resident/emergency-contact")
  Future<ResidentEmergencyContactResModel> emergencyContact();

  @POST("/api/v1/resident/complaints/{id}/close")
  Future<ComplainCloseResModel> closeComplant(
    @Path("id") String id,
    @Body() ComplainCloseBodyModel body,
  );

  @GET("/api/v1/resident/parcels")
  Future<GetResidentParcelModel> getResidentParcel();

  @POST("/api/v1/resident/parcels/{id}/respond")
  Future<ResidentParcelRespondResModel> respondResidentParcel(
    @Path("id") String id,
    @Body() ResidentParcelRespondBodyModel body,
  );

  @POST("/api/v1/resident/visitors/{id}/respond")
  Future<ResidentVisitorRespondResModel> respondResidentVisitor(
    @Path("id") String id,
    @Body() Map<String, dynamic> body,
  );

  @GET("/api/v1/resident/visitor-pass")
  Future<ResidnetVisitorPassResModel> getresideitVisitorPass();

  @GET("/api/v1/resident/maintenance-activities")
  Future<MaintenanceActivitiesResModel> maintenanceActive();

  @POST("/api/v1/resident/visitor-pass")
  Future<CreatVisitorPassResModdel> createVisitorPassRequest(
    @Body() CreateVisitorPassBodyModdel body,
  );

  @GET("/api/v1/resident/visitor-passes")
  Future<GetPassListResModel> getPass();

  /////////////// Guard ///////////////////

  @GET("/api/v1/guard/dashboard")
  Future<GuardDashBoardModel> guardDashBoard();

  @POST("/api/v1/guard/shift/toggle")
  Future<GuardCommonResModel> toggleGuardShift();

  @GET("/api/v1/guard/history")
  Future<HistoryRecordsResModel> historyRecords(@Query("filter") String filter);

  @GET("/api/v1/guard/vehicles/search")
  Future<VehicleSearchResModel> vehicleSearch(
    @Query("vehicle_number") String vehicleNumber,
  );

  @GET("/api/v1/guard/vehicles/recent-searches")
  Future<RecentVehicleSearchesResModel> getRecentVehicleSearches();

  @POST("/api/v1/guard/sos")
  Future<GuardCommonResModel> sendGuardSos(@Body() Map<String, dynamic> body);

  @GET("/api/v1/guard/guards-on-duty")
  Future<HistoryGuardResModel> historyGuard();

  @GET("/api/v1/guard/visitors/form-data")
  Future<VisitorFormDataResModel> getGuardVisitorFormData();

  @POST('/api/v1/guard/visitors')
  @MultiPart()
  Future<AddVisitorResModel> addVisitor({
    @Part(name: 'visitor_name') required String visitorName,
    @Part(name: 'visitor_phone') required String visitorPhone,
    @Part(name: 'flat_number') required String flatNumber,
    @Part(name: 'visit_type') required String visitType,
    @Part(name: 'vehicle_number') required String vehicleNumber,
    @Part(name: 'purpose') required String purpose,
    @Part(name: 'visitor_photo') File? visitorPhoto,
    @Part(name: 'is_frequent') String? isFrequent,
    @Part(name: 'frequent_role') String? frequentRole,
  });

  @POST("/api/v1/guard/visitors/scan-pass")
  Future<ScanPassResModel> scanVisitorPass(@Body() Map<String, dynamic> body);

  @GET("/api/v1/guard/frequent-visitors")
  Future<FrequentVisitorsResModel> getFrequentVisitors();

  @POST("/api/v1/guard/frequent-visitors/{id}/quick-entry")
  Future<GuardCommonResModel> quickEntryFrequentVisitor(@Path("id") String id);

  @GET('/api/v1/guard/visitors/{id}/pass')
  Future<VisitorPassResModel> getVisitorPassGuard(@Path("id") String id);

  @POST("/api/v1/guard/visitors/{id}/verbal-approve")
  Future<GuardCommonResModel> verbalApproveVisitor(
    @Path("id") String id,
    @Body() Map<String, dynamic> body,
  );

  @POST("/api/v1/guard/visitors/{id}/respond")
  Future<GuardCommonResModel> respondGuardVisitor(
    @Path("id") String id,
    @Body() Map<String, dynamic> body,
  );

  @GET("/api/v1/guard/properties")
  Future<GetFlatApartmentModel> getFlatApartment();

  @GET("/api/v1/guard/profile")
  Future<GuardProfileModel> guardProfileData();

  @POST("/api/v1/guard/visitors/{id}/mark-out")
  Future<MarkOutResModel> markOut(@Path("id") String id);

  @GET("/api/v1/guard/parcels/form-data")
  Future<ParcelFormDataResModel> getGuardParcelFormData();

  @MultiPart()
  @POST('/api/v1/guard/parcels')
  Future<AddParcelResModel> addParcel({
    @Part(name: 'vendor_name') required String vendorName,
    @Part(name: 'flat_number') required String flatNumber,
    @Part(name: 'parcel_type') required String parcelType,
    @Part(name: 'tracking_number') required String trackingNumber,
    @Part(name: 'handling_type') required String handlingType,
    @Part(name: 'parcel_photo') required File parcelPhoto,
  });

  @POST('/api/v1/guard/parcels/{id}/handover')
  Future<ParcelHandoverResModel> parcelHandover(@Path("id") String id);

  @POST('/api/v1/guard/parcels/{id}/verify-handover')
  Future<ParcelHandoverResModel> verifyParcelHandover(
    @Path("id") String id,
    @Body() Map<String, dynamic> body,
  );

  @POST('/api/v1/guard/parcels/{id}/respond')
  Future<GuardCommonResModel> respondGuardParcel(
    @Path("id") String id,
    @Body() Map<String, dynamic> body,
  );
}
