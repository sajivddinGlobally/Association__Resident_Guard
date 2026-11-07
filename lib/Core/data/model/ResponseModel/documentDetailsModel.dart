// To parse this JSON data, do
//
//     final documentDetailsModel = documentDetailsModelFromJson(jsonString);

import 'dart:convert';

DocumentDetailsModel documentDetailsModelFromJson(String str) => DocumentDetailsModel.fromJson(json.decode(str));

String documentDetailsModelToJson(DocumentDetailsModel data) => json.encode(data.toJson());

class DocumentDetailsModel {
    bool? status;
    Data? data;

    DocumentDetailsModel({
        this.status,
        this.data,
    });

    factory DocumentDetailsModel.fromJson(Map<String, dynamic> json) => DocumentDetailsModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
    };
}

class Data {
    Header? header;
    DocumentCentre? documentCentre;
    DocumentPreview? documentPreview;
    Actions? actions;
    DocumentInformation? documentInformation;
    List<RelatedDocument>? relatedDocuments;

    Data({
        this.header,
        this.documentCentre,
        this.documentPreview,
        this.actions,
        this.documentInformation,
        this.relatedDocuments,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: json["header"] == null ? null : Header.fromJson(json["header"]),
        documentCentre: json["document_centre"] == null ? null : DocumentCentre.fromJson(json["document_centre"]),
        documentPreview: json["document_preview"] == null ? null : DocumentPreview.fromJson(json["document_preview"]),
        actions: json["actions"] == null ? null : Actions.fromJson(json["actions"]),
        documentInformation: json["document_information"] == null ? null : DocumentInformation.fromJson(json["document_information"]),
        relatedDocuments: json["related_documents"] == null ? [] : List<RelatedDocument>.from(json["related_documents"]!.map((x) => RelatedDocument.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "header": header?.toJson(),
        "document_centre": documentCentre?.toJson(),
        "document_preview": documentPreview?.toJson(),
        "actions": actions?.toJson(),
        "document_information": documentInformation?.toJson(),
        "related_documents": relatedDocuments == null ? [] : List<dynamic>.from(relatedDocuments!.map((x) => x.toJson())),
    };
}

class Actions {
    Share? share;
    Download? download;

    Actions({
        this.share,
        this.download,
    });

    factory Actions.fromJson(Map<String, dynamic> json) => Actions(
        share: json["share"] == null ? null : Share.fromJson(json["share"]),
        download: json["download"] == null ? null : Download.fromJson(json["download"]),
    );

    Map<String, dynamic> toJson() => {
        "share": share?.toJson(),
        "download": download?.toJson(),
    };
}

class Download {
    String? label;
    String? downloadUrl;

    Download({
        this.label,
        this.downloadUrl,
    });

    factory Download.fromJson(Map<String, dynamic> json) => Download(
        label: json["label"],
        downloadUrl: json["download_url"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "download_url": downloadUrl,
    };
}

class Share {
    String? label;
    String? url;

    Share({
        this.label,
        this.url,
    });

    factory Share.fromJson(Map<String, dynamic> json) => Share(
        label: json["label"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "url": url,
    };
}

class DocumentCentre {
    String? title;
    String? subtitle;
    String? fileSize;
    String? pages;
    String? updated;
    Stats? stats;

    DocumentCentre({
        this.title,
        this.subtitle,
        this.fileSize,
        this.pages,
        this.updated,
        this.stats,
    });

    factory DocumentCentre.fromJson(Map<String, dynamic> json) => DocumentCentre(
        title: json["title"],
        subtitle: json["subtitle"],
        fileSize: json["file_size"],
        pages: json["pages"],
        updated: json["updated"],
        stats: json["stats"] == null ? null : Stats.fromJson(json["stats"]),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
        "file_size": fileSize,
        "pages": pages,
        "updated": updated,
        "stats": stats?.toJson(),
    };
}

class Stats {
    String? fileSize;
    String? pages;
    String? updated;

    Stats({
        this.fileSize,
        this.pages,
        this.updated,
    });

    factory Stats.fromJson(Map<String, dynamic> json) => Stats(
        fileSize: json["file_size"],
        pages: json["pages"],
        updated: json["updated"],
    );

    Map<String, dynamic> toJson() => {
        "file_size": fileSize,
        "pages": pages,
        "updated": updated,
    };
}

class DocumentInformation {
    String? documentName;
    String? category;
    String? documentType;
    String? fileSize;
    String? lastUpdated;
    List<Item>? items;

    DocumentInformation({
        this.documentName,
        this.category,
        this.documentType,
        this.fileSize,
        this.lastUpdated,
        this.items,
    });

    factory DocumentInformation.fromJson(Map<String, dynamic> json) => DocumentInformation(
        documentName: json["document_name"],
        category: json["category"],
        documentType: json["document_type"],
        fileSize: json["file_size"],
        lastUpdated: json["last_updated"],
        items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "document_name": documentName,
        "category": category,
        "document_type": documentType,
        "file_size": fileSize,
        "last_updated": lastUpdated,
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    };
}

class Item {
    String? label;
    String? value;

    Item({
        this.label,
        this.value,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        label: json["label"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
    };
}

class DocumentPreview {
    String? tag;
    String? propertyNumber;
    String? propertyType;
    String? propertyLocation;
    String? status;
    bool? isVerified;
    String? previewUrl;

    DocumentPreview({
        this.tag,
        this.propertyNumber,
        this.propertyType,
        this.propertyLocation,
        this.status,
        this.isVerified,
        this.previewUrl,
    });

    factory DocumentPreview.fromJson(Map<String, dynamic> json) => DocumentPreview(
        tag: json["tag"],
        propertyNumber: json["property_number"],
        propertyType: json["property_type"],
        propertyLocation: json["property_location"],
        status: json["status"],
        isVerified: json["is_verified"],
        previewUrl: json["preview_url"],
    );

    Map<String, dynamic> toJson() => {
        "tag": tag,
        "property_number": propertyNumber,
        "property_type": propertyType,
        "property_location": propertyLocation,
        "status": status,
        "is_verified": isVerified,
        "preview_url": previewUrl,
    };
}

class Header {
    String? title;
    String? subtitle;

    Header({
        this.title,
        this.subtitle,
    });

    factory Header.fromJson(Map<String, dynamic> json) => Header(
        title: json["title"],
        subtitle: json["subtitle"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
    };
}

class RelatedDocument {
    int? id;
    String? title;
    String? category;
    String? subtitle;
    String? fileType;
    String? fileSize;
    String? badge;
    String? viewUrl;

    RelatedDocument({
        this.id,
        this.title,
        this.category,
        this.subtitle,
        this.fileType,
        this.fileSize,
        this.badge,
        this.viewUrl,
    });

    factory RelatedDocument.fromJson(Map<String, dynamic> json) => RelatedDocument(
        id: json["id"],
        title: json["title"],
        category: json["category"],
        subtitle: json["subtitle"],
        fileType: json["file_type"],
        fileSize: json["file_size"],
        badge: json["badge"],
        viewUrl: json["view_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "category": category,
        "subtitle": subtitle,
        "file_type": fileType,
        "file_size": fileSize,
        "badge": badge,
        "view_url": viewUrl,
    };
}
