// To parse this JSON data, do
//
//     final getDocumentListModel = getDocumentListModelFromJson(jsonString);

import 'dart:convert';

GetDocumentListModel getDocumentListModelFromJson(String str) => GetDocumentListModel.fromJson(json.decode(str));

String getDocumentListModelToJson(GetDocumentListModel data) => json.encode(data.toJson());

class GetDocumentListModel {
    bool? status;
    Data? data;

    GetDocumentListModel({
        this.status,
        this.data,
    });

    factory GetDocumentListModel.fromJson(Map<String, dynamic> json) => GetDocumentListModel(
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
    Filters? filters;
    Summary? summary;
    List<FeaturedDocument>? featuredDocuments;

    Data({
        this.header,
        this.documentCentre,
        this.filters,
        this.summary,
        this.featuredDocuments,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: json["header"] == null ? null : Header.fromJson(json["header"]),
        documentCentre: json["document_centre"] == null ? null : DocumentCentre.fromJson(json["document_centre"]),
        filters: json["filters"] == null ? null : Filters.fromJson(json["filters"]),
        summary: json["summary"] == null ? null : Summary.fromJson(json["summary"]),
        featuredDocuments: json["featured_documents"] == null ? [] : List<FeaturedDocument>.from(json["featured_documents"]!.map((x) => FeaturedDocument.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "header": header?.toJson(),
        "document_centre": documentCentre?.toJson(),
        "filters": filters?.toJson(),
        "summary": summary?.toJson(),
        "featured_documents": featuredDocuments == null ? [] : List<dynamic>.from(featuredDocuments!.map((x) => x.toJson())),
    };
}

class DocumentCentre {
    String? title;
    String? subtitle;
    int? totalFiles;
    String? totalFilesLabel;
    int? activeFiles;
    String? activeFilesLabel;
    int? categoriesCount;
    String? categoriesLabel;

    DocumentCentre({
        this.title,
        this.subtitle,
        this.totalFiles,
        this.totalFilesLabel,
        this.activeFiles,
        this.activeFilesLabel,
        this.categoriesCount,
        this.categoriesLabel,
    });

    factory DocumentCentre.fromJson(Map<String, dynamic> json) => DocumentCentre(
        title: json["title"],
        subtitle: json["subtitle"],
        totalFiles: json["total_files"],
        totalFilesLabel: json["total_files_label"],
        activeFiles: json["active_files"],
        activeFilesLabel: json["active_files_label"],
        categoriesCount: json["categories_count"],
        categoriesLabel: json["categories_label"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
        "total_files": totalFiles,
        "total_files_label": totalFilesLabel,
        "active_files": activeFiles,
        "active_files_label": activeFilesLabel,
        "categories_count": categoriesCount,
        "categories_label": categoriesLabel,
    };
}

class FeaturedDocument {
    int? id;
    String? title;
    String? category;
    String? categoryKey;
    String? subtitle;
    String? badge;
    String? iconColor;
    String? fileType;
    String? fileSize;
    String? metaText;
    String? updatedDate;
    String? downloadUrl;
    String? viewDetailsUrl;

    FeaturedDocument({
        this.id,
        this.title,
        this.category,
        this.categoryKey,
        this.subtitle,
        this.badge,
        this.iconColor,
        this.fileType,
        this.fileSize,
        this.metaText,
        this.updatedDate,
        this.downloadUrl,
        this.viewDetailsUrl,
    });

    factory FeaturedDocument.fromJson(Map<String, dynamic> json) => FeaturedDocument(
        id: json["id"],
        title: json["title"],
        category: json["category"],
        categoryKey: json["category_key"],
        subtitle: json["subtitle"],
        badge: json["badge"],
        iconColor: json["icon_color"],
        fileType: json["file_type"],
        fileSize: json["file_size"],
        metaText: json["meta_text"],
        updatedDate: json["updated_date"],
        downloadUrl: json["download_url"],
        viewDetailsUrl: json["view_details_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "category": category,
        "category_key": categoryKey,
        "subtitle": subtitle,
        "badge": badge,
        "icon_color": iconColor,
        "file_type": fileType,
        "file_size": fileSize,
        "meta_text": metaText,
        "updated_date": updatedDate,
        "download_url": downloadUrl,
        "view_details_url": viewDetailsUrl,
    };
}

class Filters {
    String? active;
    List<String>? options;

    Filters({
        this.active,
        this.options,
    });

    factory Filters.fromJson(Map<String, dynamic> json) => Filters(
        active: json["active"],
        options: json["options"] == null ? [] : List<String>.from(json["options"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "active": active,
        "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x)),
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

class Summary {
    int? totalCount;
    int? filteredCount;

    Summary({
        this.totalCount,
        this.filteredCount,
    });

    factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        totalCount: json["total_count"],
        filteredCount: json["filtered_count"],
    );

    Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "filtered_count": filteredCount,
    };
}
