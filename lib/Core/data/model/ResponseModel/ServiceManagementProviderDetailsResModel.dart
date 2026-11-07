// To parse this JSON data, do
//
//     final serviceManagementProviderDetailsResModel = serviceManagementProviderDetailsResModelFromJson(jsonString);

import 'dart:convert';

ServiceManagementProviderDetailsResModel serviceManagementProviderDetailsResModelFromJson(String str) => ServiceManagementProviderDetailsResModel.fromJson(json.decode(str));

String serviceManagementProviderDetailsResModelToJson(ServiceManagementProviderDetailsResModel data) => json.encode(data.toJson());

class ServiceManagementProviderDetailsResModel {
    final bool status;
    final String message;
    final Data data;

    ServiceManagementProviderDetailsResModel({
        this.status = false,
        this.message = '',
        required this.data,
    });

    factory ServiceManagementProviderDetailsResModel.fromJson(Map<String, dynamic>? json) => ServiceManagementProviderDetailsResModel(
        status: json?["status"] ?? false,
        message: json?["message"] ?? '',
        data: json?["data"] != null
            ? Data.fromJson(json!["data"])
            : Data(
                header: Header(),
                registeredServiceProvider: RegisteredServiceProvider(stats: Stats()),
                providerInformation: ProviderInformation(),
                primaryContact: PrimaryContact(),
                contactDetails: ContactDetails(),
                assignedServices: AssignedServices(),
                providerPerformance: ProviderPerformance(),
                providerDocuments: ProviderDocuments(),
              ),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    final Header header;
    final RegisteredServiceProvider registeredServiceProvider;
    final ProviderInformation providerInformation;
    final PrimaryContact primaryContact;
    final ContactDetails contactDetails;
    final AssignedServices assignedServices;
    final ProviderPerformance providerPerformance;
    final ProviderDocuments providerDocuments;

    Data({
        required this.header,
        required this.registeredServiceProvider,
        required this.providerInformation,
        required this.primaryContact,
        required this.contactDetails,
        required this.assignedServices,
        required this.providerPerformance,
        required this.providerDocuments,
    });

    factory Data.fromJson(Map<String, dynamic>? json) => Data(
        header: json?["header"] != null
            ? Header.fromJson(json!["header"])
            : Header(),
        registeredServiceProvider: json?["registered_service_provider"] != null
            ? RegisteredServiceProvider.fromJson(json!["registered_service_provider"])
            : RegisteredServiceProvider(stats: Stats()),
        providerInformation: json?["provider_information"] != null
            ? ProviderInformation.fromJson(json!["provider_information"])
            : ProviderInformation(),
        primaryContact: json?["primary_contact"] != null
            ? PrimaryContact.fromJson(json!["primary_contact"])
            : PrimaryContact(),
        contactDetails: json?["contact_details"] != null
            ? ContactDetails.fromJson(json!["contact_details"])
            : ContactDetails(),
        assignedServices: json?["assigned_services"] != null
            ? AssignedServices.fromJson(json!["assigned_services"])
            : AssignedServices(),
        providerPerformance: json?["provider_performance"] != null
            ? ProviderPerformance.fromJson(json!["provider_performance"])
            : ProviderPerformance(),
        providerDocuments: json?["provider_documents"] != null
            ? ProviderDocuments.fromJson(json!["provider_documents"])
            : ProviderDocuments(),
    );

    Map<String, dynamic> toJson() => {
        "header": header.toJson(),
        "registered_service_provider": registeredServiceProvider.toJson(),
        "provider_information": providerInformation.toJson(),
        "primary_contact": primaryContact.toJson(),
        "contact_details": contactDetails.toJson(),
        "assigned_services": assignedServices.toJson(),
        "provider_performance": providerPerformance.toJson(),
        "provider_documents": providerDocuments.toJson(),
    };
}

class AssignedServices {
    final String title;
    final List<Service> services;

    AssignedServices({
        this.title = '',
        this.services = const [],
    });

    factory AssignedServices.fromJson(Map<String, dynamic>? json) => AssignedServices(
        title: json?["title"] ?? '',
        services: json?["services"] == null
            ? []
            : List<Service>.from(
                (json!["services"] as List).map((x) => Service.fromJson(x is Map<String, dynamic> ? x : {})),
              ),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "services": List<dynamic>.from(services.map((x) => x.toJson())),
    };
}

class Service {
    final int id;
    final String title;
    final String subtitle;
    final String status;

    Service({
        this.id = 0,
        this.title = '',
        this.subtitle = '',
        this.status = '',
    });

    factory Service.fromJson(Map<String, dynamic>? json) => Service(
        id: json?["id"] is int
            ? json!["id"]
            : (int.tryParse(json?["id"]?.toString() ?? '') ?? 0),
        title: json?["title"] ?? '',
        subtitle: json?["subtitle"] ?? '',
        status: json?["status"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "subtitle": subtitle,
        "status": status,
    };
}

class ContactDetails {
    String? title;
    String? phone;
    String? email;
    String? workingHours;
    String? emergencySupport;

    ContactDetails({
        this.title,
        this.phone,
        this.email,
        this.workingHours,
        this.emergencySupport,
    });

    factory ContactDetails.fromJson(Map<String, dynamic>? json) => ContactDetails(
        title: json?["title"],
        phone: json?["phone"],
        email: json?["email"],
        workingHours: json?["working_hours"],
        emergencySupport: json?["emergency_support"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "phone": phone,
        "email": email,
        "working_hours": workingHours,
        "emergency_support": emergencySupport,
    };
}

class Header {
    final String title;
    final String subtitle;

    Header({
        this.title = '',
        this.subtitle = '',
    });

    factory Header.fromJson(Map<String, dynamic>? json) => Header(
        title: json?["title"] ?? '',
        subtitle: json?["subtitle"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
    };
}

class PrimaryContact {
    String? title;
    String? contactPerson;
    String? contactRole;
    String? avatar;

    PrimaryContact({
        this.title,
        this.contactRole,
        this.contactPerson,
        this.avatar,
    });

    factory PrimaryContact.fromJson(Map<String, dynamic>? json) => PrimaryContact(
        title: json?["title"],
        contactPerson: json?["contact_person"],
        contactRole: json?["contact_role"],
        avatar: json?["avatar"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "contact_person": contactPerson,
        "contact_role": contactRole,
        "avatar": avatar,
    };
}

class ProviderDocuments {
    final String title;
    final List<Document> documents;

    ProviderDocuments({
        this.title = '',
        this.documents = const [],
    });

    factory ProviderDocuments.fromJson(Map<String, dynamic>? json) => ProviderDocuments(
        title: json?["title"] ?? '',
        documents: json?["documents"] == null
            ? []
            : List<Document>.from(
                (json!["documents"] as List).map((x) => Document.fromJson(x is Map<String, dynamic> ? x : {})),
              ),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "documents": List<dynamic>.from(documents.map((x) => x.toJson())),
    };
}

class Document {
    final String title;
    final String format;
    final String status;
    final String url;

    Document({
        this.title = '',
        this.format = '',
        this.status = '',
        this.url = '',
    });

    factory Document.fromJson(Map<String, dynamic>? json) => Document(
        title: json?["title"] ?? '',
        format: json?["format"] ?? '',
        status: json?["status"] ?? '',
        url: json?["url"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "format": format,
        "status": status,
        "url": url,
    };
}

class ProviderInformation {
    final String title;
    final String providerType;
    final String providerId;
    final String registrationDate;
    final String status;
    final String contractStatus;
    final String serviceArea;

    ProviderInformation({
        this.title = '',
        this.providerType = '',
        this.providerId = '',
        this.registrationDate = '',
        this.status = '',
        this.contractStatus = '',
        this.serviceArea = '',
    });

    factory ProviderInformation.fromJson(Map<String, dynamic>? json) => ProviderInformation(
        title: json?["title"] ?? '',
        providerType: json?["provider_type"] ?? '',
        providerId: json?["provider_id"] ?? '',
        registrationDate: json?["registration_date"] ?? '',
        status: json?["status"] ?? '',
        contractStatus: json?["contract_status"] ?? '',
        serviceArea: json?["service_area"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "provider_type": providerType,
        "provider_id": providerId,
        "registration_date": registrationDate,
        "status": status,
        "contract_status": contractStatus,
        "service_area": serviceArea,
    };
}

class ProviderPerformance {
    final String title;
    final int score;
    final String headline;
    final String serviceQuality;
    final String performanceUrl;

    ProviderPerformance({
        this.title = '',
        this.score = 0,
        this.headline = '',
        this.serviceQuality = '',
        this.performanceUrl = '',
    });

    factory ProviderPerformance.fromJson(Map<String, dynamic>? json) => ProviderPerformance(
        title: json?["title"] ?? '',
        score: json?["score"] is int
            ? json!["score"]
            : (int.tryParse(json?["score"]?.toString() ?? '') ?? 0),
        headline: json?["headline"] ?? '',
        serviceQuality: json?["service_quality"] ?? '',
        performanceUrl: json?["performance_url"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "score": score,
        "headline": headline,
        "service_quality": serviceQuality,
        "performance_url": performanceUrl,
    };
}

class RegisteredServiceProvider {
    final String badge;
    final String tag;
    final String name;
    final String subtitle;
    final Stats stats;

    RegisteredServiceProvider({
        this.badge = '',
        this.tag = '',
        this.name = '',
        this.subtitle = '',
        required this.stats,
    });

    factory RegisteredServiceProvider.fromJson(Map<String, dynamic>? json) => RegisteredServiceProvider(
        badge: json?["badge"] ?? '',
        tag: json?["tag"] ?? '',
        name: json?["name"] ?? '',
        subtitle: json?["subtitle"] ?? '',
        stats: json?["stats"] != null
            ? Stats.fromJson(json!["stats"])
            : Stats(),
    );

    Map<String, dynamic> toJson() => {
        "badge": badge,
        "tag": tag,
        "name": name,
        "subtitle": subtitle,
        "stats": stats.toJson(),
    };
}

class Stats {
    final String services;
    final String since;
    final String rating;

    Stats({
        this.services = '',
        this.since = '',
        this.rating = '',
    });

    factory Stats.fromJson(Map<String, dynamic>? json) => Stats(
        services: json?["services"]?.toString() ?? '',
        since: json?["since"]?.toString() ?? '',
        rating: json?["rating"]?.toString() ?? '',
    );

    Map<String, dynamic> toJson() => {
        "services": services,
        "since": since,
        "rating": rating,
    };
}