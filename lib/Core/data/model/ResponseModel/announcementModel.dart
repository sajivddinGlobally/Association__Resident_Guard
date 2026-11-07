import 'dart:convert';
import 'package:flutter/material.dart';

AnnouncementResponseModel announcementResponseModelFromJson(String str) =>
    AnnouncementResponseModel.fromJson(json.decode(str));

String announcementResponseModelToJson(AnnouncementResponseModel data) =>
    json.encode(data.toJson());

class AnnouncementResponseModel {
  final bool? status;
  final String? message;
  final AnnouncementData? data;

  AnnouncementResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory AnnouncementResponseModel.fromJson(Map<String, dynamic> json) =>
      AnnouncementResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : AnnouncementData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class AnnouncementData {
  final String? title;
  final String? subtitle;
  final int? unreadCount;
  final List<String>? categories;
  final List<AnnouncementItem>? announcements;

  AnnouncementData({
    this.title,
    this.subtitle,
    this.unreadCount,
    this.categories,
    this.announcements,
  });

  factory AnnouncementData.fromJson(Map<String, dynamic> json) =>
      AnnouncementData(
        title: json["title"],
        subtitle: json["subtitle"],
        unreadCount: json["unread_count"],
        categories: json["categories"] == null
            ? []
            : List<String>.from(json["categories"]!.map((x) => x)),
        announcements: json["announcements"] == null
            ? []
            : List<AnnouncementItem>.from(
                json["announcements"]!.map((x) => AnnouncementItem.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
        "unread_count": unreadCount,
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x)),
        "announcements": announcements == null
            ? []
            : List<dynamic>.from(announcements!.map((x) => x.toJson())),
      };
}

class AnnouncementItem {
  final String? id;
  final String? title;
  final String? shortDescription;
  final String? content;
  final String? category; // Maintenance, Security, Emergency, Event, General
  final String? targetAudience; // ALL, RESIDENTS, GUARDS
  final String? priority; // URGENT, HIGH, NORMAL, LOW
  final bool? isUrgent;
  final bool? isPinned;
  final bool? isUnread;
  final String? postedBy;
  final String? postedByRole;
  final String? postedDate;
  final String? validTill;
  final String? effectiveTime;
  final String? location;
  final String? attachmentName;
  final String? attachmentType; // PDF, IMAGE, NONE
  final String? contactPhone;
  final String? contactEmail;
  final String? actionLabel;

  AnnouncementItem({
    this.id,
    this.title,
    this.shortDescription,
    this.content,
    this.category,
    this.targetAudience,
    this.priority,
    this.isUrgent,
    this.isPinned,
    this.isUnread,
    this.postedBy,
    this.postedByRole,
    this.postedDate,
    this.validTill,
    this.effectiveTime,
    this.location,
    this.attachmentName,
    this.attachmentType,
    this.contactPhone,
    this.contactEmail,
    this.actionLabel,
  });

  factory AnnouncementItem.fromJson(Map<String, dynamic> json) =>
      AnnouncementItem(
        id: json["id"]?.toString(),
        title: json["title"],
        shortDescription: json["short_description"],
        content: json["content"],
        category: json["category"],
        targetAudience: json["target_audience"],
        priority: json["priority"],
        isUrgent: json["is_urgent"] ?? false,
        isPinned: json["is_pinned"] ?? false,
        isUnread: json["is_unread"] ?? false,
        postedBy: json["posted_by"],
        postedByRole: json["posted_by_role"],
        postedDate: json["posted_date"],
        validTill: json["valid_till"],
        effectiveTime: json["effective_time"],
        location: json["location"],
        attachmentName: json["attachment_name"],
        attachmentType: json["attachment_type"],
        contactPhone: json["contact_phone"],
        contactEmail: json["contact_email"],
        actionLabel: json["action_label"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "short_description": shortDescription,
        "content": content,
        "category": category,
        "target_audience": targetAudience,
        "priority": priority,
        "is_urgent": isUrgent,
        "is_pinned": isPinned,
        "is_unread": isUnread,
        "posted_by": postedBy,
        "posted_by_role": postedByRole,
        "posted_date": postedDate,
        "valid_till": validTill,
        "effective_time": effectiveTime,
        "location": location,
        "attachment_name": attachmentName,
        "attachment_type": attachmentType,
        "contact_phone": contactPhone,
        "contact_email": contactEmail,
        "action_label": actionLabel,
      };

  // UI Helper Getters matching app style
  Color get categoryColor {
    switch (category?.toUpperCase()) {
      case 'EMERGENCY':
        return const Color(0xFFD22424);
      case 'MAINTENANCE':
        return const Color(0xFFB8860B);
      case 'SECURITY':
        return const Color(0xFF2563EB);
      case 'EVENT':
        return const Color(0xFF7C3AED);
      case 'GENERAL':
      default:
        return const Color(0xFF101C16);
    }
  }

  Color get categoryBgColor {
    switch (category?.toUpperCase()) {
      case 'EMERGENCY':
        return const Color(0xFFFEE2E2);
      case 'MAINTENANCE':
        return const Color(0xFFFEF3C7);
      case 'SECURITY':
        return const Color(0xFFDBEAFE);
      case 'EVENT':
        return const Color(0xFFF3E8FF);
      case 'GENERAL':
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  IconData get categoryIcon {
    switch (category?.toUpperCase()) {
      case 'EMERGENCY':
        return Icons.warning_amber_rounded;
      case 'MAINTENANCE':
        return Icons.build_circle_outlined;
      case 'SECURITY':
        return Icons.security_rounded;
      case 'EVENT':
        return Icons.event_available_outlined;
      case 'GENERAL':
      default:
        return Icons.campaign_outlined;
    }
  }
}

// ==========================================
// DUMMY DATA FOR RESIDENT & GUARD PLATFORMS
// ==========================================
class DummyAnnouncementData {
  // Announcements tailored for Residents
  static List<AnnouncementItem> getResidentAnnouncements() {
    return [
      AnnouncementItem(
        id: "ANN-101",
        title: "Overhead Water Tank Cleaning & Supply Interruption",
        shortDescription:
            "Water supply will remain paused from 10:00 AM to 04:00 PM for all residential blocks due to bi-monthly tank sterilization.",
        content:
            "Dear Residents,\n\nPlease be informed that our quarterly overhead water tank cleaning, disinfection, and pressure pump inspection is scheduled for tomorrow.\n\n• Affected Blocks: Block A, B, C & D\n• Timings: 10:00 AM to 04:00 PM\n• Backup Supply: Low-pressure supply available for kitchen lines till 12:00 PM.\n\nKindly store adequate water for daily consumption before 09:30 AM. In case of water leakage or emergency requirement, contact the society maintenance control room.",
        category: "MAINTENANCE",
        targetAudience: "RESIDENTS",
        priority: "URGENT",
        isUrgent: true,
        isPinned: true,
        isUnread: true,
        postedBy: "Society Maintenance Committee",
        postedByRole: "Chief Facility Officer",
        postedDate: "Today • 09:15 AM",
        validTill: "Tomorrow • 05:00 PM",
        effectiveTime: "10:00 AM - 04:00 PM",
        location: "All Blocks (A, B, C, D)",
        attachmentName: "Tank_Cleaning_Schedule_Q4.pdf",
        attachmentType: "PDF",
        contactPhone: "+91 98765 43210",
        contactEmail: "facility@greenvalley.com",
        actionLabel: "View Schedule",
      ),
      AnnouncementItem(
        id: "ANN-102",
        title: "Annual General Body Meeting (AGM) 2026",
        shortDescription:
            "The Annual General Meeting of the Residents Welfare Association will be convened at the Central Clubhouse on Sunday at 11:00 AM.",
        content:
            "Dear Homeowners & Residents,\n\nThe Managing Committee cordially invites all flat owners and registered residents to attend the Annual General Meeting (AGM).\n\nAgenda Points:\n1. Presentation & approval of annual audited accounts.\n2. Review of ongoing security camera upgrades & smart access gates.\n3. Discussion on solar rooftop installation project.\n4. Election of new committee members for 2026-2027.\n\nHigh tea & refreshments will be served at the clubhouse lawn post-meeting. Quorum requirement is 30% of total members.",
        category: "EVENT",
        targetAudience: "RESIDENTS",
        priority: "HIGH",
        isUrgent: false,
        isPinned: true,
        isUnread: true,
        postedBy: "Managing Committee (RWA)",
        postedByRole: "General Secretary",
        postedDate: "Yesterday • 04:30 PM",
        validTill: "28 Oct 2026",
        effectiveTime: "Sunday, 11:00 AM",
        location: "Central Clubhouse Lawn",
        attachmentName: "AGM_Agenda_And_Financials.pdf",
        attachmentType: "PDF",
        contactPhone: "+91 98111 22334",
        contactEmail: "secretary@greenvalley.com",
        actionLabel: "RSVP Now",
      ),
      AnnouncementItem(
        id: "ANN-103",
        title: "New Digital Visitor Entry & Parcel Gate Pass Protocol",
        shortDescription:
            "Starting 1st of next month, all visitor entries and courier parcels must be pre-approved via the Resident Mobile App.",
        content:
            "Dear Residents,\n\nTo enhance campus security and eliminate congestion at main entrance Gate-1 & Gate-2, the association has made digital pre-approval mandatory for all outside visitors, cabs, and courier services.\n\nKey Highlights:\n• Generate a QR pass in 1 tap from your resident app before your guest arrives.\n• Unapproved visitors will be held at security gate until resident provides in-app authorization.\n• Parcels can be marked as 'Leave at Security Gate' for automated OTP delivery verification.\n\nThank you for cooperating with the security staff.",
        category: "SECURITY",
        targetAudience: "ALL",
        priority: "NORMAL",
        isUrgent: false,
        isPinned: false,
        isUnread: false,
        postedBy: "Security & Vigilance Cell",
        postedByRole: "Security Head",
        postedDate: "20 Oct 2026",
        validTill: "31 Oct 2026",
        effectiveTime: "24x7 Protocol",
        location: "Gate No. 1 & Gate No. 2",
        attachmentName: "Visitor_Pass_Guidelines.pdf",
        attachmentType: "PDF",
        contactPhone: "+91 98100 55443",
        contactEmail: "security@greenvalley.com",
        actionLabel: "Try Pre-Approval",
      ),
      AnnouncementItem(
        id: "ANN-104",
        title: "Swimming Pool & Gym Deep Sanitization Drive",
        shortDescription:
            "Recreational facilities including the clubhouse gym and pool will remain closed on Wednesday for deep chemical sanitization.",
        content:
            "Notice to all residents,\n\nOur health & fitness facilities are scheduled for their monthly deep hygiene treatment.\n\n• Swimming Pool: Closed Wednesday full day for chlorination & filter replacement.\n• Clubhouse Gymnasium: Closed Wednesday 01:00 PM to 06:00 PM.\n\nRegular operational hours will resume from Thursday morning 06:00 AM.",
        category: "GENERAL",
        targetAudience: "RESIDENTS",
        priority: "LOW",
        isUrgent: false,
        isPinned: false,
        isUnread: false,
        postedBy: "Clubhouse Administration",
        postedByRole: "Recreation Supervisor",
        postedDate: "18 Oct 2026",
        validTill: "24 Oct 2026",
        effectiveTime: "Wednesday (Full Day)",
        location: "Clubhouse & Sports Complex",
        attachmentName: null,
        attachmentType: "NONE",
        contactPhone: "+91 98711 00223",
        contactEmail: "clubhouse@greenvalley.com",
        actionLabel: null,
      ),
    ];
  }

  // Official Notice Board Circulars (Signed Orders, Policies & Bylaws)
  static List<AnnouncementItem> getResidentCirculars() {
    return [
      AnnouncementItem(
        id: "CIR-301",
        title: "Society Bye-Laws & Allotted Parking Policy (Resolution #42)",
        shortDescription:
            "Formal resolution on double parking penalty, EV charging installation permissions, and visitor basement slot allotments.",
        content:
            "OFFICIAL SOCIETY CIRCULAR - RWA/2026/RES-42:\n\nThe General Body has formally ratified the Revised Parking and Vehicle Regulatory Bye-Laws.\n\n1. All residents must affix society RFID tags on primary registered four-wheelers.\n2. Overnight parking in designated visitor bays incurs penalty charges.\n3. EV charging wall-box installation requires electrical load sanction from estate engineering team.\n\nDownload and retain the full Gazette circular attached below for complete bylaws.",
        category: "GENERAL",
        targetAudience: "RESIDENTS",
        priority: "HIGH",
        isUrgent: false,
        isPinned: true,
        isUnread: false,
        postedBy: "Executive Managing Committee",
        postedByRole: "President - RWA",
        postedDate: "15 Oct 2026",
        validTill: "Permanent Circular",
        effectiveTime: "Effective Immediately",
        location: "All Parking Basements (-1 & -2)",
        attachmentName: "Society_Parking_ByeLaws_Gazette_2026.pdf",
        attachmentType: "PDF",
        contactPhone: "+91 98111 22334",
        contactEmail: "rwa-office@greenvalley.com",
        actionLabel: "View Circular PDF",
      ),
      AnnouncementItem(
        id: "CIR-302",
        title: "Basement Fire Suppression Audit & Smoke Evacuation Directives",
        shortDescription:
            "Annual statutory fire safety audit clearance certificate & resident fire exit guidelines.",
        content:
            "CIVIL DEFENSE & FIRE SAFETY NOTICE:\n\nThe Department of Fire Services has renewed the No Objection Certificate (NOC) for our towers after inspecting wet risers, automatic sprinklers, and emergency staircase pressurization fans.\n\nKey Directives for Residents:\n• Never obstruct fire doors or stairwells with personal footwear racks or cycles.\n• Report any unlit emergency exit signs directly to the security cabin.\n• Review the attached evacuation layout plan for your respective tower floor.",
        category: "SECURITY",
        targetAudience: "RESIDENTS",
        priority: "HIGH",
        isUrgent: false,
        isPinned: true,
        isUnread: false,
        postedBy: "Fire Safety & Compliance Cell",
        postedByRole: "Safety Officer",
        postedDate: "12 Oct 2026",
        validTill: "31 Dec 2027",
        effectiveTime: "Standing Safety Directive",
        location: "Tower A, B, C & D Fire Stairs",
        attachmentName: "Fire_NOC_And_Evacuation_Plan.pdf",
        attachmentType: "PDF",
        contactPhone: "+91 98100 55443",
        contactEmail: "safety@greenvalley.com",
        actionLabel: "View Evacuation Plan",
      ),
      AnnouncementItem(
        id: "CIR-303",
        title: "Pet Care & Common Lawn Cleanliness Guidelines",
        shortDescription:
            "Advisory regarding mandatory leash rules in passenger elevators and pet defecation cleanup protocol.",
        content:
            "COMMUNITY ADVISORY:\n\nTo ensure harmony between pet parents and other residents:\n1. Pets must be on leash at all times in common corridors, elevators, and basement.\n2. Service elevator should be given preference when travelling with large pets.\n3. Pet owners must carry disposal bags during lawn walks.\n\nThank you for fostering a pet-friendly and clean society environment.",
        category: "GENERAL",
        targetAudience: "RESIDENTS",
        priority: "NORMAL",
        isUrgent: false,
        isPinned: false,
        isUnread: false,
        postedBy: "Environment & Health Sub-Committee",
        postedByRole: "Convenor",
        postedDate: "08 Oct 2026",
        validTill: "Standing Guideline",
        effectiveTime: "All Hours",
        location: "Central Parks & Elevators",
        attachmentName: "Pet_Policy_Guidelines_2026.pdf",
        attachmentType: "PDF",
        contactPhone: "+91 98711 00223",
        contactEmail: "environment@greenvalley.com",
        actionLabel: "View Policy",
      ),
    ];
  }

  // Announcements tailored specifically for Security Guards
  static List<AnnouncementItem> getGuardAnnouncements() {
    return [
      AnnouncementItem(
        id: "GRD-200",
        title: "New Digital Visitor Entry & Parcel Gate Pass Protocol",
        shortDescription:
            "Starting 1st of next month, all visitor entries and courier parcels must be pre-approved via the Resident Mobile App.",
        content:
            "Official Notice to All Campus Members & Security Personnel:\n\nTo enhance campus security and eliminate congestion at main entrance Gate-1 & Gate-2, the association has made digital pre-approval mandatory for all outside visitors, cabs, and courier services.\n\nKey Highlights:\n• Generate a QR pass in 1 tap from resident app before guest arrives.\n• Unapproved visitors held at security gate until resident provides in-app authorization.\n• Parcels can be marked as 'Leave at Security Gate' for automated OTP delivery verification.",
        category: "SECURITY",
        targetAudience: "ALL",
        postedBy: "Association Managing Committee",
        postedDate: "20 Oct 2026",
      ),
      AnnouncementItem(
        id: "GRD-201",
        title: "Mandatory Cab & Delivery Vehicle Verification SOP",
        shortDescription:
            "No commercial cab (Ola/Uber) or courier delivery person to enter premises without resident pre-approval or flat intercom confirmation.",
        content:
            "SECURITY DIRECTIVE - STRICT COMPLIANCE REQUIRED:\n\nAll guards stationed at Gate-1 and Gate-2 must strictly enforce the following entrance workflow:\n\n1. Check if the visitor has a valid QR Code Gate Pass generated by the flat owner.\n2. If not, initiate an in-app verification request from your Guard tablet before opening the boom barrier.\n3. Do not allow delivery bikes to park inside tower lobbies; guide them to designated 10-minute visitor bays.\n4. Log vehicle registration numbers for all four-wheelers without fast-tags.\n\nRandom spot checks will be carried out by the Estate Security Officer.",
        category: "SECURITY",
        targetAudience: "GUARDS",
        priority: "URGENT",
        isUrgent: true,
        isPinned: true,
        isUnread: true,
        postedBy: "Chief Security Officer (CSO)",
        postedByRole: "RWA Security Command",
        postedDate: "Today • 08:00 AM",
        validTill: "Active Standing Order",
        effectiveTime: "All Shifts (A, B & Night Shift)",
        location: "Gate-1, Gate-2 & Service Gate",
        attachmentName: "Gate_SOP_Standard_Operating_Procedure.pdf",
        attachmentType: "PDF",
        contactPhone: "+91 99999 11223",
        contactEmail: "security-ops@greenvalley.com",
        actionLabel: "Acknowledge SOP",
      ),
      AnnouncementItem(
        id: "GRD-202",
        title: "Emergency Gate Protocol: Fire Drill & Siren Testing",
        shortDescription:
            "Annual fire suppression & emergency exit gate test on Friday between 03:00 PM and 04:00 PM. Emergency lane to remain unobstructed.",
        content:
            "Attention All On-Duty & Reliever Security Staff:\n\nThe local Fire Brigade and Disaster Management team will conduct a simulated fire drill.\n\nGuard Instructions:\n• Keep emergency exit gates (Gate 3 & Gate 4) unlocked and manned.\n• Zero parking strictly enforced within 50 meters of fire hydrants.\n• Wear high-visibility fluorescent jackets during the exercise.\n• Escort simulated emergency vehicles along the main arterial society loop.",
        category: "EMERGENCY",
        targetAudience: "GUARDS",
        priority: "URGENT",
        isUrgent: true,
        isPinned: true,
        isUnread: true,
        postedBy: "Safety & Disaster Management Cell",
        postedByRole: "Emergency Coordinator",
        postedDate: "Yesterday • 02:00 PM",
        validTill: "24 Oct 2026",
        effectiveTime: "Friday • 03:00 PM - 04:00 PM",
        location: "Emergency Lanes & Fire Hydrants",
        attachmentName: "Evacuation_Map_Gate_Positions.pdf",
        attachmentType: "PDF",
        contactPhone: "+91 98111 88990",
        contactEmail: "emergency@greenvalley.com",
        actionLabel: "View Gate Map",
      ),
      AnnouncementItem(
        id: "GRD-203",
        title: "Winter Security Guard Shift Timings & Uniform Guidelines",
        shortDescription:
            "Winter shift rota revised. Night shift guards to collect winter heavy jackets and high-beam torches from control room.",
        content:
            "Notice to Security Personnel:\n\nRevised winter shift schedule is effective immediately:\n• Morning Shift: 07:00 AM - 03:00 PM\n• Evening Shift: 03:00 PM - 11:00 PM\n• Night Shift: 11:00 PM - 07:00 AM\n\nNight patrolling guards must record RFID baton check-ins at every basement and perimeter checkpoint every 45 minutes without fail.",
        category: "GENERAL",
        targetAudience: "GUARDS",
        priority: "NORMAL",
        isUrgent: false,
        isPinned: false,
        isUnread: false,
        postedBy: "Security Agency Supervisor",
        postedByRole: "Field Operations Manager",
        postedDate: "21 Oct 2026",
        validTill: "30 Nov 2026",
        effectiveTime: "Effective From Tonight",
        location: "Security Cabins & Guard Room",
        attachmentName: "Shift_Duty_Roster_Nov2026.pdf",
        attachmentType: "PDF",
        contactPhone: "+91 98765 00112",
        contactEmail: "guards@greenvalley.com",
        actionLabel: "View Roster",
      ),
      AnnouncementItem(
        id: "GRD-204",
        title: "Vendor & Renovation Contractor Entry Timings",
        shortDescription:
            "Heavy drilling and carpenter contractor entries are strictly permitted only between 09:00 AM to 06:00 PM (Monday to Saturday).",
        content:
            "Security Advisory:\n\nSeveral resident complaints were received regarding noisy construction work during quiet hours.\n\nStrict Rule for Gates:\n• No interior construction material trucks or labor allowed on Sundays or public holidays.\n• Verify daily contractor labor pass before permitting entry to residential towers.\n• Report any violations directly to the society control desk.",
        category: "MAINTENANCE",
        targetAudience: "GUARDS",
        priority: "HIGH",
        isUrgent: false,
        isPinned: false,
        isUnread: false,
        postedBy: "Estate Office",
        postedByRole: "Compliance Officer",
        postedDate: "19 Oct 2026",
        validTill: "31 Dec 2026",
        effectiveTime: "09:00 AM - 06:00 PM Only",
        location: "Gate-2 (Material Delivery Gate)",
        attachmentName: null,
        attachmentType: "NONE",
        contactPhone: "+91 98100 44332",
        contactEmail: "estate@greenvalley.com",
        actionLabel: null,
      ),
    ];
  }
}
