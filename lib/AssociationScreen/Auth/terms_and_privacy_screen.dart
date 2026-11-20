import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';

class TermsAndPrivacyScreen extends StatefulWidget {
  final int initialTab; // 0: Terms & Conditions, 1: Privacy Policy

  const TermsAndPrivacyScreen({super.key, this.initialTab = 0});

  @override
  State<TermsAndPrivacyScreen> createState() => _TermsAndPrivacyScreenState();
}

class _TermsAndPrivacyScreenState extends State<TermsAndPrivacyScreen> {
  late int _selectedTab;
  final ScrollController _scrollController = ScrollController();

  // 3 Primary Colors: Beech (Background), Golden, and Black
  static const Color _bg = AppColors.scaffoldBg; // Beech
  static const Color _gold = Color(0xFFB8860B); // Rich Golden
  static const Color _black = Color(0xFF101C16); // Deep Black

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _switchTab(int index) {
    if (_selectedTab != index) {
      setState(() {
        _selectedTab = index;
      });
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopAppBar(),
            SizedBox(height: 10.h),
            _buildTabSelector(),
            SizedBox(height: 14.h),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_selectedTab == 0)
                      ..._buildTermsContent()
                    else
                      ..._buildPrivacyContent(),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(6.r),
            child: Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: _black, width: 1.2.w),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.arrow_back, color: _black, size: 22.sp),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _selectedTab == 0 ? "Terms & Conditions" : "Privacy Policy",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: _black,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "STAYO Property Management Application",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w600,
                    color: _gold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: _gold, width: 1.5.w),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _switchTab(0),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 11.h),
                  decoration: BoxDecoration(
                    color: _selectedTab == 0 ? _black : Colors.transparent,
                    borderRadius: BorderRadius.circular(26.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Terms & Conditions",
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: _selectedTab == 0 ? Colors.white : _black,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 6.w),
            Expanded(
              child: GestureDetector(
                onTap: () => _switchTab(1),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 11.h),
                  decoration: BoxDecoration(
                    color: _selectedTab == 1 ? _black : Colors.transparent,
                    borderRadius: BorderRadius.circular(26.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Privacy Policy",
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: _selectedTab == 1 ? Colors.white : _black,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metaCard({
    required String title,
    required String subtitle,
    required Map<String, String> meta,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: _gold, width: 1.5.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  "assets/updatelogo.jpeg",
                  width: 44.w,
                  height: 44.w,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      color: _black,
                      shape: BoxShape.circle,
                      border: Border.all(color: _gold, width: 1.w),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "S",
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 22.sp,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: _black,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: _gold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(color: _gold.withValues(alpha: 0.35), height: 1.5.h),
          SizedBox(height: 12.h),
          ...meta.entries.map((e) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 135.w,
                    child: Text(
                      e.key,
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: _black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      e.value,
                      style: GoogleFonts.outfit(
                        fontSize: 14.5.sp,
                        fontWeight: FontWeight.w500,
                        color: _black,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String number,
    required String title,
    required List<String> paragraphs,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: _black.withValues(alpha: 0.28), width: 1.2.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _black,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  number,
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: _black,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...paragraphs.map((p) {
            final isBullet = p.startsWith("• ") || p.startsWith("- ");
            final isSubNumber =
                RegExp(r"^\d+\.\d+").hasMatch(p) ||
                RegExp(r"^[a-z]\.").hasMatch(p);

            return Padding(
              padding: EdgeInsets.only(bottom: 9.h),
              child: Text(
                p,
                textAlign: TextAlign.justify,
                style: GoogleFonts.outfit(
                  fontSize: 15.sp,
                  fontWeight: (isBullet || isSubNumber)
                      ? FontWeight.w500
                      : FontWeight.w400,
                  color: _black,
                  height: 1.55,
                  letterSpacing: -0.15,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _contactCard({
    required String title,
    required String phone,
    required String email,
    required String website,
    required String office,
    String? grievanceOfficer,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: _gold, width: 1.8.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.headset_mic_rounded, size: 24.sp, color: _gold),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 17.5.sp,
                    fontWeight: FontWeight.w700,
                    color: _black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Divider(color: _gold.withValues(alpha: 0.35), height: 1.5.h),
          SizedBox(height: 10.h),
          _contactRow(Icons.phone_outlined, "Phone", phone),
          _contactRow(Icons.email_outlined, "Email", email),
          _contactRow(Icons.language_outlined, "Website", website),
          _contactRow(Icons.location_on_outlined, "Registered Office", office),
          if (grievanceOfficer != null && grievanceOfficer.isNotEmpty)
            _contactRow(
              Icons.person_outline,
              "Grievance Officer",
              grievanceOfficer,
            ),
        ],
      ),
    );
  }

  Widget _contactRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18.sp, color: _gold),
          SizedBox(width: 8.w),
          Text(
            "$label: ",
            style: GoogleFonts.outfit(
              fontSize: 14.5.sp,
              fontWeight: FontWeight.w700,
              color: _black,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 14.5.sp,
                fontWeight: FontWeight.w500,
                color: _black,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // TERMS AND CONDITIONS DATA
  // ----------------------------------------------------
  List<Widget> _buildTermsContent() {
    return [
      _metaCard(
        title: "STAYO TERMS OF USE",
        subtitle: "Property Management Application",
        meta: {
          "Application Name": "STAYO",
          "Owner / Operator": "Ascent PMS Care Private Limited",
          "Website": "www.ascentpms.care",
          "Phone": "9567345740",
          "Effective Date": "November 2026",
        },
      ),
      _sectionCard(
        number: "01",
        title: "INTRODUCTION AND ACCEPTANCE",
        paragraphs: [
          "1.1. Welcome to STAYO, a digital property management application designed to simplify, streamline and improve the management of independent residential properties and multi-unit residential communities.",
          "1.2. STAYO provides a common digital platform for property owners, residents, tenants, apartment associations, residents’ associations, property managers, administrators, security personnel, maintenance teams, contractors, suppliers and other authorised stakeholders.",
          "1.3. The application is designed to facilitate property-related administrative, financial, operational and communication activities through a centralised digital system.",
          "1.4. These Terms and Conditions govern the access to and use of the STAYO mobile application, website, dashboard, software and associated services.",
          "1.5. By downloading, installing, registering, accessing or using the application, you acknowledge that you have read, understood and agreed to comply with these Terms and Conditions, together with the applicable Privacy Policy and other policies published by STAYO.",
          "1.6. If you do not agree with these Terms and Conditions, you must discontinue the use of the application.",
          "1.7. These Terms and Conditions apply to all categories of users accessing STAYO, irrespective of their assigned role or access level.",
        ],
      ),
      _sectionCard(
        number: "02",
        title: "DEFINITIONS AND INTERPRETATION",
        paragraphs: [
          "For the purpose of these Terms and Conditions, the following expressions shall have the meanings assigned to them:",
          "2.1. STAYO / Company: Refers to the legal entity owning, developing, operating or providing the STAYO application and associated services.",
          "2.2. Application / Platform: Refers to the STAYO mobile application, web application, administrative dashboard, software and associated digital interfaces.",
          "2.3. User: Refers to any individual who accesses, registers or uses the application.",
          "2.4. Property: Refers to an independent house, villa, apartment, residential building, commercial building or other premises registered on the platform.",
          "2.5. Community: Refers to a residential apartment complex, gated community, housing society or group of residential units managed collectively.",
          "2.6. Property Owner: Refers to the legal owner or duly authorised representative of a property.",
          "2.7. Resident: Refers to an individual residing in a property or residential community.",
          "2.8. Tenant: Refers to an individual occupying a property under a rental, lease or other lawful occupancy arrangement.",
          "2.9. Association: Refers to a residents’ association, apartment owners’ association, housing society or other authorised body responsible for managing a residential community.",
          "2.10. Administrator: Refers to an individual authorised by the property owner, association or management organisation to administer the application and manage property-related information.",
          "2.11. Property Manager: Refers to an individual or organisation appointed to coordinate, supervise or undertake property management activities.",
          "2.12. Service Provider: Refers to contractors, technicians, suppliers, security agencies, housekeeping personnel, maintenance personnel and other third parties engaged for property-related services.",
          "2.13. Visitor: Refers to any guest, delivery executive, vendor, service technician, domestic worker or other individual seeking access to a property or community.",
          "2.14. MMC: Refers to Monthly Maintenance Charges or periodic maintenance contributions payable by property owners, residents or other persons liable under the applicable agreement or association rules.",
          "2.15. Subscription: Refers to the fee or payment applicable for accessing the STAYO platform or its designated features.",
          "2.16. Digital Records: Refers to information, transaction histories, reports, photographs, documents, notifications, entries and other records generated, uploaded or maintained through the application.",
        ],
      ),
      _sectionCard(
        number: "03",
        title: "PURPOSE AND SCOPE OF THE APPLICATION",
        paragraphs: [
          "3.1. STAYO is a property management technology platform intended to digitise and streamline the administrative, operational and financial management of independent properties and residential communities.",
          "3.2. The application is designed to reduce manual processes, improve transparency, facilitate communication and provide systematic monitoring of property-related activities.",
          "3.3. Depending on the subscription plan and configuration, the application may provide the following facilities:",
          "a. Independent property management.",
          "b. Residential community management.",
          "c. Property and resident information management.",
          "d. Visitor registration, approval and entry management.",
          "e. Security and gate-entry management.",
          "f. Delivery and courier management.",
          "g. Monthly maintenance charge generation and collection tracking.",
          "h. Digital accounting and financial reporting.",
          "i. Income and expenditure management.",
          "j. Outstanding dues and defaulter tracking.",
          "k. Complaint and maintenance request management.",
          "l. Emergency and priority-based issue tracking.",
          "m. Contractor and supplier management.",
          "n. Work allocation and completion monitoring.",
          "o. Security, housekeeping and staff management.",
          "p. Attendance and performance monitoring.",
          "q. Asset and inventory management.",
          "r. Purchase requests and stock monitoring.",
          "s. Property inspections and audit reports.",
          "t. Digital notices, announcements and communication.",
          "u. Document storage and management.",
          "v. Other property-related facilities introduced by STAYO.",
          "3.4. The availability of individual features may depend on the selected subscription plan, property configuration, user permissions and technical availability.",
          "3.5. STAYO reserves the right to modify, improve, introduce or discontinue features as part of its ongoing development, subject to applicable contractual and legal obligations.",
        ],
      ),
      _sectionCard(
        number: "04",
        title: "ELIGIBILITY AND USER REGISTRATION",
        paragraphs: [
          "4.1. Individuals must be at least 18 years of age to independently register for an account, except where an account is created or managed by a legally authorised representative in accordance with applicable law.",
          "4.2. Users must provide accurate, complete and updated information during registration.",
          "4.3. Users shall not provide false names, contact details, property information or other misleading particulars.",
          "4.4. STAYO may request additional information or verification documents where necessary for security, account validation or regulatory compliance.",
          "4.5. Each user is responsible for maintaining the confidentiality of their login credentials, passwords and other authentication information.",
          "4.6. Users must not share their login credentials with unauthorised individuals.",
          "4.7. Any activity performed through a user’s account shall be treated as activity associated with that account, subject to investigation where unauthorised access is reported.",
          "4.8. Users must immediately report suspected unauthorised access, account compromise or suspicious activities to the administrator or STAYO support team.",
          "4.9. STAYO reserves the right to suspend or restrict accounts involving fraudulent registration, identity misrepresentation, misuse or violation of these Terms.",
        ],
      ),
      _sectionCard(
        number: "05",
        title: "PROPERTY AND COMMUNITY REGISTRATION",
        paragraphs: [
          "5.1. Independent properties and residential communities may be registered on STAYO by property owners, authorised representatives, associations or appointed property management organisations.",
          "5.2. The person registering a property or community shall confirm that they possess the necessary authority to submit the relevant information and activate the application services.",
          "5.3. The registering authority shall be responsible for ensuring the accuracy of property details, unit numbers, ownership information, occupancy records and other information uploaded to the platform.",
          "5.4. STAYO shall not independently verify the legal ownership, title, tenancy or occupancy rights of every property or individual registered on the application unless a specific verification service is expressly provided.",
          "5.5. Any disputes relating to property ownership, tenancy, association membership, management authority or occupancy rights shall be resolved by the concerned parties in accordance with applicable laws.",
          "5.6. The property owner or association shall ensure that appropriate permissions and authorisations have been obtained before uploading information belonging to residents, tenants, employees or visitors.",
          "5.7. STAYO reserves the right to request supporting documents or suspend a property registration where legitimate concerns regarding authority or authenticity arise.",
        ],
      ),
      _sectionCard(
        number: "06",
        title: "USER ROLES, PERMISSIONS AND ACCESS CONTROL",
        paragraphs: [
          "6.1. STAYO may provide different user roles depending on the requirements of each property or community.",
          "6.2. Such roles may include:",
          "a. Property Owner.",
          "b. Resident.",
          "c. Tenant.",
          "d. Association President or Chairperson.",
          "e. Association Secretary.",
          "f. Association Treasurer.",
          "g. Property Administrator.",
          "h. Property Manager.",
          "i. Security Supervisor.",
          "j. Security Personnel.",
          "k. Housekeeping Supervisor.",
          "l. Maintenance Personnel.",
          "m. Contractor or Supplier.",
          "n. Other authorised users.",
          "6.3. Each user shall receive access to features and information based on the permissions assigned by the authorised administrator.",
          "6.4. Users shall not attempt to access information or administrative functions beyond their assigned permissions.",
          "6.5. Administrators shall be responsible for assigning appropriate permissions and reviewing access periodically.",
          "6.6. When a user ceases to be a resident, employee, office-bearer or authorised representative, the concerned administrator shall take appropriate steps to deactivate or modify that user’s access.",
          "6.7. Users shall not misuse their assigned authority to access, modify, disclose or manipulate information belonging to other users.",
          "6.8. STAYO may maintain system activity logs for security, accountability and administrative purposes.",
        ],
      ),
      _sectionCard(
        number: "07",
        title: "VISITOR MANAGEMENT AND ENTRY CONTROL",
        paragraphs: [
          "7.1. STAYO provides digital visitor management facilities to facilitate the recording, verification, approval and monitoring of visitors entering registered properties and communities.",
          "7.2. Residents may receive visitor notifications and approve or reject visitor entry requests through the application, where the facility is enabled.",
          "7.3. Security personnel may record visitor information, including name, contact number, vehicle registration details, purpose of visit, entry time and exit time, as required by the property’s security procedures.",
          "7.4. Residents shall be responsible for providing accurate visitor-related information and responding to approval requests wherever required.",
          "7.5. Security personnel shall follow the entry procedures and instructions established by the property owner or association.",
          "7.6. The final decision regarding permitting or denying entry shall remain with the authorised security personnel or property administration, subject to applicable laws and property rules.",
          "7.7. STAYO functions as a digital visitor-recording and access-coordination platform. It does not independently verify the identity, intentions, background or conduct of every visitor.",
          "7.8. The property owner, association or appointed security agency shall remain responsible for implementing appropriate physical security measures.",
          "7.9. Users shall not misuse visitor information, photographs or contact details for personal, commercial or unauthorised purposes.",
          "7.10. Visitor records shall be maintained and retained in accordance with the applicable Privacy Policy, lawful purposes and retention requirements.",
          "7.11. STAYO shall not be considered a substitute for security personnel, CCTV systems, access-control equipment or emergency response arrangements.",
          "7.12. The use of the visitor management facility does not constitute a guarantee against theft, trespassing, unauthorised entry or other security incidents.",
        ],
      ),
      _sectionCard(
        number: "08",
        title: "DELIVERY AND COURIER MANAGEMENT",
        paragraphs: [
          "8.1. STAYO may provide a digital delivery management facility to record and monitor parcels, courier items, food deliveries and other deliveries received at registered properties or communities.",
          "8.2. Security personnel or authorised staff may record delivery details and notify the concerned resident through the application.",
          "8.3. Delivery information may include the recipient’s name, apartment or unit number, delivery company, parcel reference and time of receipt.",
          "8.4. Residents shall be responsible for collecting their deliveries within a reasonable period.",
          "8.5. Where the property permits security personnel or other staff to temporarily receive deliveries, the applicable property-level procedures shall govern the physical handling and storage of such items.",
          "8.6. STAYO does not automatically assume physical custody of any parcel or delivery merely because delivery details are recorded in the application.",
          "8.7. The person or agency physically receiving a delivery shall remain responsible for handling it in accordance with their applicable duties and agreements.",
          "8.8. STAYO shall not be responsible for the delay, damage, theft, loss or incorrect delivery of parcels arising from the independent acts or omissions of courier companies, residents or physical custodians, except where liability arises under applicable law.",
          "8.9. Residents must ensure that delivery instructions and contact information are accurate.",
          "8.10. Prohibited, dangerous or unlawful items shall not be accepted or stored contrary to applicable laws or property rules.",
        ],
      ),
      _sectionCard(
        number: "09",
        title: "MONTHLY MAINTENANCE CHARGES (MMC) & COLLECTION",
        paragraphs: [
          "9.1. STAYO may provide digital facilities for generating monthly maintenance demands, recording payments, monitoring outstanding dues and maintaining maintenance collection records.",
          "9.2. Maintenance charges shall be determined by the concerned property owner, association or authorised management body in accordance with applicable agreements, resolutions, bye-laws and laws.",
          "9.3. STAYO does not independently determine the amount of maintenance payable by individual residents or property owners.",
          "9.4. The association or authorised management shall determine the applicable rates, payment frequency, due dates, penalties, interest and other collection conditions.",
          "9.5. Residents and property owners shall be responsible for paying the applicable maintenance charges within the prescribed timelines.",
          "9.6. Users are advised to review their maintenance statements and raise discrepancies with the concerned administrator without undue delay.",
          "9.7. Where payment facilities are enabled, payments must be made through the authorised channels displayed in the application.",
          "9.8. Digital receipts and transaction records generated by STAYO shall reflect the information recorded in the system and may be subject to reconciliation and verification.",
          "9.9. Any dispute concerning the calculation, allocation or recovery of maintenance charges shall be addressed by the concerned association or authorised management body.",
          "9.10. STAYO may provide reports identifying outstanding dues, payment histories and defaulters based on information available in the system.",
          "9.11. The association or authorised management shall verify the accuracy of such reports before taking recovery action or communicating outstanding dues.",
          "9.12. STAYO shall not independently initiate legal recovery proceedings against residents or property owners merely because maintenance charges remain outstanding.",
          "9.13. Any penalties or additional charges must be authorised by the appropriate property management authority and comply with applicable law.",
          "9.14. Users shall not manipulate, falsify or alter maintenance payment records.",
        ],
      ),
      _sectionCard(
        number: "10",
        title: "DIGITAL ACCOUNTING AND FINANCIAL MANAGEMENT",
        paragraphs: [
          "10.1. STAYO may provide digital accounting facilities for recording property-related income, maintenance collections, expenses, purchases, vendor payments and other financial transactions.",
          "10.2. The accounting facility is intended to improve transparency, financial monitoring and record-keeping.",
          "10.3. Financial entries may include maintenance collections, sinking fund contributions, common-area expenses, utility expenses, staff payments, contractor bills, repair costs, purchases and other authorised transactions.",
          "10.4. Administrators and authorised financial users shall ensure that entries are accurate and supported by relevant invoices, receipts, vouchers or other documents.",
          "10.5. The application may generate income statements, expenditure statements, outstanding dues reports, collection reports and other financial summaries.",
          "10.6. The association or property management body shall remain responsible for approving expenditure, authorising payments and ensuring financial discipline.",
          "10.7. STAYO shall not independently verify the authenticity of every invoice, receipt, financial entry or transaction uploaded by users.",
          "10.8. Digital accounting reports generated by the application are management records and shall not automatically constitute audited financial statements or statutory accounts.",
          "10.9. Users shall not make unauthorised financial entries, manipulate records or misuse the accounting facilities.",
          "10.10. Any suspected financial irregularity, unauthorised transaction or accounting discrepancy shall be reported immediately to the concerned administrator.",
          "10.11. The responsibility for the physical custody, banking arrangements and authorised operation of property funds shall remain with the association, property owner or designated financial authority.",
          "10.12. STAYO shall not be treated as a bank, deposit-taking institution or financial custodian merely because it provides accounting or payment-recording facilities.",
          "10.13. Where payment processing is facilitated through third-party payment gateways, the applicable payment service provider terms shall also apply.",
        ],
      ),
      _sectionCard(
        number: "11",
        title: "COMPLAINT AND MAINTENANCE REQUEST MANAGEMENT",
        paragraphs: [
          "11.1. STAYO may provide facilities for residents, owners and authorised users to register complaints and maintenance requests.",
          "11.2. Complaints may relate to electrical issues, plumbing, water supply, lifts, common-area cleaning, security, housekeeping, equipment breakdowns, civil maintenance and other property-related concerns.",
          "11.3. The application may classify complaints based on emergency, urgency, priority, nature of the issue and operational requirements.",
          "11.4. The system may generate unique complaint reference numbers or tracking tokens for monitoring the progress of each issue.",
          "11.5. The administrator or property manager may assign complaints to authorised staff, contractors or service providers.",
          "11.6. Users shall provide accurate descriptions and relevant photographs or supporting information wherever possible.",
          "11.7. The concerned property management team or assigned service provider shall be responsible for inspecting and resolving the physical issue.",
          "11.8. STAYO facilitates complaint recording, tracking and coordination but does not independently perform physical repairs unless separately contracted to do so.",
          "11.9. Emergency situations involving gas leakage, fire, electrical hazards, structural damage, medical emergencies or threats to life must be immediately reported to appropriate emergency services and responsible property personnel.",
          "11.10. Users must not rely exclusively on application notifications for emergency response.",
          "11.11. STAYO shall not guarantee resolution within a particular timeframe unless such commitment is expressly agreed under a separate service-level agreement.",
        ],
      ),
      _sectionCard(
        number: "12",
        title: "STAFF AND SERVICE PROVIDER MANAGEMENT",
        paragraphs: [
          "12.1. STAYO may provide facilities for recording and monitoring activities performed by security personnel, housekeeping staff, caretakers, technicians and other service providers.",
          "12.2. Such facilities may include attendance records, duty allocation, task assignments, inspection checklists, performance reports and completion records.",
          "12.3. Administrators may use the application to monitor service performance and maintain operational records.",
          "12.4. The appointment, employment, remuneration, supervision, disciplinary action and termination of personnel shall remain the responsibility of the concerned employer, association or authorised management organisation.",
          "12.5. The use of STAYO does not automatically create an employer-employee relationship between STAYO and personnel whose activities are recorded through the application.",
          "12.6. Contractors and service providers shall remain responsible for performing their contractual obligations and complying with applicable laws.",
          "12.7. Any dispute relating to staff employment, wages, attendance, misconduct or service-provider contracts shall be addressed by the concerned contracting or employing party.",
        ],
      ),
      _sectionCard(
        number: "13",
        title: "ASSET AND INVENTORY MANAGEMENT",
        paragraphs: [
          "13.1. STAYO may provide facilities for recording, monitoring and maintaining registers of property assets, equipment, consumables, tools, spare parts and other inventory items.",
          "13.2. Authorised users may record stock inward, stock outward, purchases, transfers, returns, consumption, adjustments and disposals.",
          "13.3. Administrators may generate inventory reports, asset registers, purchase requests and stock alerts.",
          "13.4. The property owner or association shall remain responsible for the physical verification, safekeeping, utilisation and maintenance of assets and inventory.",
          "13.5. Digital inventory records shall be based on information entered by authorised users and should be periodically verified.",
          "13.6. STAYO shall not be responsible for physical loss, theft, shortage or misuse of assets merely because the inventory is recorded in the application.",
        ],
      ),
      _sectionCard(
        number: "14",
        title: "NOTICES, ANNOUNCEMENTS AND COMMUNICATION",
        paragraphs: [
          "14.1. STAYO may provide digital communication facilities for property-related notices, announcements, maintenance updates, emergency alerts, payment reminders and other relevant information.",
          "14.2. Administrators and authorised representatives may publish notices and announcements to designated users.",
          "14.3. Users may receive notifications through the application, SMS, email or other supported communication channels.",
          "14.4. Users shall ensure that their contact details are accurate and updated.",
          "14.5. STAYO shall not guarantee immediate delivery or receipt of notifications due to network interruptions, device settings or third-party communication service failures.",
          "14.6. Official notices and decisions issued by an association shall remain subject to applicable association bye-laws, resolutions and governing documents.",
          "14.7. Users shall not misuse communication facilities for harassment, defamatory content, spam, threats or unlawful activities.",
        ],
      ),
      _sectionCard(
        number: "15",
        title: "PROPERTY OWNER AND ASSOCIATION RESPONSIBILITIES",
        paragraphs: [
          "15.1. Property owners and associations shall ensure that STAYO is used only by duly authorised individuals.",
          "15.2. They shall ensure that property, resident, financial and operational information uploaded to the application is accurate and lawfully obtained.",
          "15.3. They shall obtain the necessary approvals and permissions before activating relevant application features.",
          "15.4. They shall establish appropriate procedures for visitor management, delivery handling, financial administration, maintenance operations and emergency response.",
          "15.5. They shall ensure that financial transactions are properly authorised and recorded.",
          "15.6. They shall periodically review user permissions and deactivate accounts of persons who are no longer authorised.",
          "15.7. They shall ensure that the use of the application does not violate the legal rights or privacy of residents, tenants, employees or visitors.",
          "15.8. They shall remain responsible for decisions taken by their office-bearers, employees and authorised representatives.",
          "15.9. The association or property owner shall be responsible for ensuring that the use of the platform is consistent with applicable laws, association bye-laws and relevant contractual arrangements.",
        ],
      ),
      _sectionCard(
        number: "16",
        title: "RESPONSIBILITIES OF RESIDENTS AND TENANTS",
        paragraphs: [
          "16.1. Residents and tenants shall provide accurate personal and occupancy information.",
          "16.2. They shall use the application responsibly and comply with the applicable property rules.",
          "16.3. They shall not share application credentials or confidential property information with unauthorised persons.",
          "16.4. They shall respond to visitor approval requests and other property-related notifications where necessary.",
          "16.5. They shall make applicable maintenance payments in accordance with the rules and agreements governing their occupancy.",
          "16.6. They shall report maintenance issues, security concerns and other property-related problems through the appropriate channels.",
          "16.7. They shall not misuse visitor management, delivery management, complaint management or communication facilities.",
          "16.8. Residents and tenants shall respect the privacy and rights of other occupants.",
        ],
      ),
      _sectionCard(
        number: "17",
        title: "ROLE AND RESPONSIBILITIES OF STAYO",
        paragraphs: [
          "17.1. STAYO is primarily a technology platform designed to facilitate digital property management, operational coordination, communication and financial record-keeping.",
          "17.2. The Company shall make reasonable efforts to maintain the functionality, availability and security of the application.",
          "17.3. The Company may provide technical assistance, software updates, application support and user guidance.",
          "17.4. Unless expressly agreed under a separate written property management agreement, STAYO shall not automatically assume responsibility for the physical management or administration of a property merely because the property is registered on the application.",
          "17.5. STAYO does not independently determine maintenance charges, association policies, expenditure approvals, resident obligations or property management decisions.",
          "17.6. STAYO does not independently assume responsibility for physical security, employment of property staff, performance of contractors, custody of parcels or maintenance of physical assets merely by providing the corresponding digital facilities.",
          "17.7. Where STAYO or an affiliated organisation separately undertakes physical property management services, such responsibilities shall be governed by the applicable service agreement.",
          "17.8. The Company shall remain responsible for fulfilling its own contractual obligations and liabilities under applicable law.",
        ],
      ),
      _sectionCard(
        number: "18",
        title: "SUBSCRIPTION, FEES AND PAYMENT TERMS",
        paragraphs: [
          "18.1. STAYO may offer free and paid subscription plans depending on the features and services made available.",
          "18.2. Subscription charges, renewal conditions, applicable taxes and additional service fees shall be communicated before subscription or renewal.",
          "18.3. The subscription may be obtained by an individual property owner, association or authorised property management organisation.",
          "18.4. The subscribing party shall be responsible for paying the applicable subscription charges within the prescribed timelines.",
          "18.5. Non-payment may result in suspension or restriction of paid features after appropriate notice, subject to the applicable agreement.",
          "18.6. Changes to subscription fees shall be communicated in advance.",
          "18.7. Subscription fees shall be governed by the applicable subscription and refund policy.",
          "18.8. Subscription payments made to STAYO shall be separate from maintenance charges collected by an association unless expressly agreed otherwise.",
        ],
      ),
      _sectionCard(
        number: "19",
        title: "DATA ACCURACY AND DIGITAL RECORDS",
        paragraphs: [
          "19.1. STAYO provides a digital platform for recording and maintaining property management information.",
          "19.2. The accuracy of records depends on the information submitted, entered, verified and updated by authorised users.",
          "19.3. Administrators and users shall be responsible for reviewing financial entries, visitor records, delivery information, inventory records and maintenance reports.",
          "19.4. The Company shall not be responsible for inaccuracies arising from false, incomplete or incorrect information entered by users.",
          "19.5. Users shall not intentionally manipulate, falsify or delete digital records without appropriate authority.",
          "19.6. STAYO may maintain system logs, transaction histories and backup records for security, operational and compliance purposes.",
          "19.7. The Company shall make reasonable efforts to preserve digital records but cannot guarantee uninterrupted access to historical information in every circumstance.",
          "19.8. Where records are used for financial reconciliation, audits or legal proceedings, users and administrators should retain appropriate supporting documents.",
        ],
      ),
      _sectionCard(
        number: "20",
        title: "PRIVACY AND PERSONAL DATA PROTECTION",
        paragraphs: [
          "20.1. STAYO may collect and process personal information necessary for providing property management services.",
          "20.2. Such information may include names, contact details, email addresses, property details, unit numbers, occupancy information, vehicle registration details, visitor information, delivery records, payment references and maintenance complaints.",
          "20.3. Personal information shall be processed for legitimate purposes connected with property management, security, accounting, communication, technical support and service delivery.",
          "20.4. Users and property administrators shall ensure that they have the necessary authority and lawful basis to submit personal information belonging to residents, tenants, visitors, employees and other individuals.",
          "20.5. The Company shall adopt reasonable technical and organisational safeguards to protect personal information against unauthorised access, disclosure, alteration or destruction.",
          "20.6. Users shall not download, share, copy or disclose personal information, financial records, visitor photographs or other confidential information without proper authority.",
          "20.7. Personal information shall be retained in accordance with applicable legal requirements and the STAYO Privacy Policy.",
          "20.8. Users may submit requests concerning access, correction, deletion or other data-related rights through the designated support channels, subject to applicable laws.",
          "20.9. The processing of personal data shall be governed by the separate STAYO Privacy Policy and applicable Indian data protection legislation.",
        ],
      ),
      _sectionCard(
        number: "21",
        title: "INFORMATION SECURITY AND USER RESPONSIBILITY",
        paragraphs: [
          "21.1. Users shall take reasonable precautions to safeguard their accounts and devices.",
          "21.2. Users shall not share passwords, verification codes or authentication credentials.",
          "21.3. Users shall immediately report suspected security breaches or unauthorised access.",
          "21.4. Users shall not attempt to access the underlying database, software infrastructure or confidential information without permission.",
          "21.5. STAYO may implement authentication, access controls, monitoring systems and other security measures to protect the application.",
          "21.6. No digital system can guarantee absolute protection against every possible cyber threat. The Company shall make reasonable efforts to identify and address security vulnerabilities.",
        ],
      ),
      _sectionCard(
        number: "22",
        title: "INTELLECTUAL PROPERTY RIGHTS",
        paragraphs: [
          "22.1. All rights relating to the STAYO name, logo, trademarks, software, application design, interface, graphics, content, databases and other proprietary materials shall belong to the Company or its respective licensors.",
          "22.2. Users are granted a limited, non-exclusive, non-transferable right to access and use the application for its intended property management purposes.",
          "22.3. Users shall not reproduce, copy, modify, distribute, reverse engineer or commercially exploit any part of the application without prior written permission.",
          "22.4. Unauthorised use of the Company’s intellectual property may result in appropriate legal action.",
        ],
      ),
      _sectionCard(
        number: "23",
        title: "PROHIBITED ACTIVITIES",
        paragraphs: [
          "Users shall not:",
          "a. Use STAYO for unlawful or fraudulent purposes.",
          "b. Provide false or misleading property or personal information.",
          "c. Access another user’s account without permission.",
          "d. Manipulate maintenance collection or financial records.",
          "e. Falsify visitor entry or exit records.",
          "f. Misuse residents’ personal information or visitor photographs.",
          "g. Disclose confidential financial or administrative information without authority.",
          "h. Introduce malware or harmful software.",
          "i. Attempt to compromise the security or functioning of the application.",
          "j. Use the platform to harass, threaten or defraud other users.",
          "k. Circumvent subscription, payment or access restrictions.",
          "l. Misuse any application feature for personal gain or unauthorised commercial purposes.",
          "Any violation may result in suspension of access and appropriate legal action.",
        ],
      ),
      _sectionCard(
        number: "24",
        title: "APPLICATION AVAILABILITY & TECHNICAL INTERRUPTIONS",
        paragraphs: [
          "24.1. STAYO shall make reasonable efforts to ensure the application remains accessible and functional.",
          "24.2. The application may occasionally be unavailable due to maintenance, upgrades, server interruptions, network failures, cyber incidents or other technical circumstances.",
          "24.3. The Company does not guarantee uninterrupted or error-free operation at all times.",
          "24.4. The Company reserves the right to perform maintenance, security updates and software improvements.",
          "24.5. Users are responsible for maintaining compatible devices, operating systems and internet connectivity.",
          "24.6. The Company shall make reasonable efforts to restore interrupted services as soon as practicable.",
        ],
      ),
      _sectionCard(
        number: "25",
        title: "THIRD-PARTY SERVICES AND INTEGRATIONS",
        paragraphs: [
          "25.1. STAYO may integrate with third-party service providers, including payment gateways, messaging platforms, cloud hosting providers and other technology services.",
          "25.2. Such third-party services may be subject to separate terms, conditions and privacy policies.",
          "25.3. The Company shall not be responsible for independent failures or interruptions caused by third-party services, except to the extent of its own legal responsibilities.",
          "25.4. Users are advised to review the applicable third-party terms wherever necessary.",
        ],
      ),
      _sectionCard(
        number: "26",
        title: "LIMITATION OF LIABILITY",
        paragraphs: [
          "26.1. STAYO shall make reasonable efforts to provide reliable digital property management services.",
          "26.2. The Company shall not be liable for indirect or consequential losses arising from the use of the application, to the extent permitted by applicable law.",
          "26.3. The Company shall not be responsible for service interruptions arising from circumstances beyond its reasonable control.",
          "26.4. STAYO shall not be responsible for physical incidents, theft, accidents, disputes, financial misconduct or unauthorised activities merely because the relevant property uses the application.",
          "26.5. The Company shall not be responsible for independent decisions, actions or omissions of property owners, associations, residents, employees, contractors or other service providers.",
          "26.6. Nothing in these Terms shall exclude liability for fraud, wilful misconduct, negligence or any other liability that cannot legally be excluded or restricted.",
        ],
      ),
      _sectionCard(
        number: "27",
        title: "INDEMNIFICATION",
        paragraphs: [
          "27.1. Users shall be responsible for losses, damages, claims or expenses arising directly from their unlawful actions, fraudulent conduct, intentional misconduct or material violation of these Terms.",
          "27.2. Users shall not misuse the application in a manner that infringes the legal rights, privacy or interests of other users or third parties.",
          "27.3. Where a user causes loss or damage through unauthorised access, manipulation of records, fraudulent activities or unlawful disclosure of information, the Company may take appropriate legal action in accordance with applicable law.",
          "27.4. Any indemnification obligation shall be subject to applicable law and shall not restrict statutory consumer rights.",
        ],
      ),
      _sectionCard(
        number: "28",
        title: "SUSPENSION AND TERMINATION",
        paragraphs: [
          "28.1. STAYO reserves the right to suspend, restrict or terminate user access where there is fraudulent activity, misuse, unauthorised access or violation of these Terms.",
          "28.2. The Company may temporarily suspend services for maintenance, security updates or technical reasons.",
          "28.3. Property owners and associations may discontinue the use of STAYO in accordance with their applicable subscription or service agreement.",
          "28.4. Users may request account deactivation through the available application settings or authorised support channels.",
          "28.5. Account termination shall not automatically extinguish outstanding payment obligations, contractual responsibilities or unresolved legal claims.",
          "28.6. Information required to be retained under applicable laws may be preserved for the legally prescribed period.",
        ],
      ),
      _sectionCard(
        number: "29",
        title: "FORCE MAJEURE",
        paragraphs: [
          "29.1. The Company shall not be held responsible for delay or interruption in performing its obligations to the extent caused by circumstances beyond its reasonable control.",
          "29.2. Such circumstances may include natural disasters, floods, fire, pandemics, government restrictions, civil disturbances, strikes, power failures, internet outages, cyber incidents or major infrastructure failures.",
          "29.3. The Company shall make reasonable efforts to restore affected services and communicate material disruptions wherever practicable.",
        ],
      ),
      _sectionCard(
        number: "30",
        title: "AMENDMENTS TO TERMS AND CONDITIONS",
        paragraphs: [
          "30.1. STAYO reserves the right to update or modify these Terms and Conditions from time to time.",
          "30.2. Updated terms shall be published through the application or official website.",
          "30.3. Material changes shall be communicated to registered users through appropriate notification channels wherever reasonably practicable.",
          "30.4. Revised terms shall become effective from the stated effective date, subject to applicable law.",
          "30.5. Continued use of the application after the revised terms become effective shall be subject to the updated terms to the extent permitted by law.",
        ],
      ),
      _sectionCard(
        number: "31",
        title: "GOVERNING LAW AND DISPUTE RESOLUTION",
        paragraphs: [
          "31.1. These Terms and Conditions shall be governed by and interpreted in accordance with the laws of India.",
          "31.2. Any dispute arising from the use of the STAYO application should initially be brought to the attention of the Company’s customer support or grievance redressal team.",
          "31.3. The parties shall make reasonable efforts to resolve disputes amicably.",
          "31.4. Where an amicable resolution is not possible, disputes may be referred to the competent courts or authorities in accordance with applicable Indian law.",
          "31.5. Nothing in this clause shall restrict the statutory rights of consumers to approach the appropriate consumer dispute redressal commission or other competent authority.",
        ],
      ),
      _contactCard(
        title: "32. GRIEVANCE REDRESSAL & CUSTOMER SUPPORT",
        phone: "9567345740",
        email: "ascentpmscare@gmail.com",
        website: "www.ascentpms.care",
        office:
            "First floor, Krishnapriya, Ganapathy Kovil road, Vazhuthacaud, Trivandrum-14",
        grievanceOfficer: "Ascent PMS Grievance Officer",
      ),
      _sectionCard(
        number: "33",
        title: "SEVERABILITY",
        paragraphs: [
          "If any provision of these Terms and Conditions is held to be invalid, unlawful or unenforceable by a competent authority, such provision shall be modified or severed to the extent necessary, without affecting the validity and enforceability of the remaining provisions.",
        ],
      ),
      _sectionCard(
        number: "34",
        title: "ENTIRE AGREEMENT",
        paragraphs: [
          "These Terms and Conditions, together with the applicable Privacy Policy, subscription terms and other policies published by STAYO, constitute the terms governing the use of the application.",
          "Where a separate written agreement exists between STAYO and a property owner, association or management organisation, the specific terms of that agreement shall govern the services expressly covered by it in the event of an inconsistency.",
        ],
      ),
      _sectionCard(
        number: "35",
        title: "FINAL ACCEPTANCE AND USER CONSENT",
        paragraphs: [
          "By registering, accessing or using the STAYO mobile application, the user confirms and acknowledges that:",
          "1. They have read and understood these Terms and Conditions.",
          "2. They agree to comply with the rules and policies applicable to their use of the application.",
          "3. They shall provide accurate and authorised information.",
          "4. They shall use the application responsibly and lawfully.",
          "5. They understand the respective responsibilities of STAYO, property owners, associations, administrators and other authorised users.",
          "6. They understand that STAYO is a digital property management platform and does not automatically assume responsibility for the physical, financial or administrative management of every property using the application.",
          "7. They consent to the processing of their personal information in accordance with the STAYO Privacy Policy and applicable law.",
        ],
      ),
    ];
  }

  // ----------------------------------------------------
  // PRIVACY POLICY DATA
  // ----------------------------------------------------
  List<Widget> _buildPrivacyContent() {
    return [
      _metaCard(
        title: "STAYO PRIVACY POLICY",
        subtitle:
            "Protection, Collection, Storage and Use of Personal Information",
        meta: {
          "Application Name": "STAYO",
          "Owner / Operator": "Ascent PMS Care Private Limited",
          "Website": "www.ascentpms.care",
          "Email": "ascentpmscare@gmail.com",
          "Phone": "9567345740",
          "Effective Date": "November 2026",
        },
      ),
      _sectionCard(
        number: "01",
        title: "INTRODUCTION",
        paragraphs: [
          "STAYO is a digital property management application designed to facilitate the systematic and transparent management of independent residential properties and multi-unit residential communities.",
          "The application provides digital facilities for property owners, residents, tenants, associations, property managers, security personnel, administrators, contractors and other authorised users.",
          "STAYO recognises the importance of protecting the privacy and personal information of individuals using the application.",
          "This Privacy Policy explains how STAYO collects, receives, processes, stores, uses, shares and protects personal information through its mobile application, website and associated services.",
          "This policy applies to all individuals accessing or using STAYO, including property owners, residents, tenants, visitors, employees, security personnel, contractors and other authorised users.",
          "By accessing or using the application, users acknowledge that they have been provided access to this Privacy Policy. Where consent is required under applicable law, STAYO shall obtain such consent through the appropriate mechanism.",
          "Users are advised to read this policy carefully before registering or using the application.",
        ],
      ),
      _sectionCard(
        number: "02",
        title: "SCOPE OF THIS PRIVACY POLICY",
        paragraphs: [
          "This Privacy Policy applies to personal information collected or processed through:",
          "• STAYO mobile application.",
          "• STAYO website and web dashboard.",
          "• Property and community registration modules.",
          "• Resident and tenant management modules.",
          "• Visitor management facilities.",
          "• Delivery and courier management facilities.",
          "• Maintenance collection and accounting modules.",
          "• Complaint and maintenance request modules.",
          "• Staff and service provider management modules.",
          "• Asset and inventory management modules.",
          "• Customer support and communication channels.",
          "• Other services and features made available through STAYO.",
          "This policy also explains the responsibilities of property owners, associations and administrators who upload, manage or access personal information through the platform.",
        ],
      ),
      _sectionCard(
        number: "03",
        title: "INFORMATION WE COLLECT",
        paragraphs: [
          "Depending on the features used and the permissions granted, STAYO may collect or process the following categories of information:",
          "3.1 Personal Identification Information: Full name, mobile number, email address, residential address, property or apartment number, profile photograph, user identification details, and other information required for account registration and verification.",
          "3.2 Property and Occupancy Information: Property name and address, apartment/villa/unit number, ownership details, resident and tenant information, occupancy details, emergency contact details, and property-related documents uploaded by authorised users.",
          "3.3 Visitor Management Information: Visitor’s name, contact number, photograph (where lawfully collected), vehicle registration number, purpose of visit, unit number visited, check-in and check-out time, approval/rejection records.",
          "3.4 Delivery and Courier Information: Recipient name, apartment number, delivery company name, parcel reference details, delivery date/time, and collection status.",
          "3.5 Financial and Payment Information: Monthly maintenance charges, payment amounts, dates, transaction reference numbers, outstanding dues, receipts, invoices, and accounting records. STAYO does not store full card numbers, CVV, or payment passwords; credentials are handled by authorised third-party payment gateways.",
          "3.6 Maintenance and Complaint Information: Complaint descriptions, unit details, photographs, date/time, category, assigned service provider, status, and communication history.",
          "3.7 Staff and Service Provider Information: Name, contact details, assigned role, attendance records, duty allocation, performance records, and work photographs.",
          "3.8 Device and Technical Information: Device model, operating system, application version, IP address, device identifiers, login timestamps, error logs, and security authentication logs.",
        ],
      ),
      _sectionCard(
        number: "04",
        title: "PURPOSE OF COLLECTING INFORMATION",
        paragraphs: [
          "STAYO collects and processes personal information only for legitimate purposes connected with the operation and delivery of property management services:",
          "4.1. Creating and managing user accounts.",
          "4.2. Registering independent properties and residential communities.",
          "4.3. Maintaining resident, tenant and property records.",
          "4.4. Facilitating visitor registration, approval and entry monitoring.",
          "4.5. Recording and communicating delivery information.",
          "4.6. Generating and maintaining monthly maintenance demands.",
          "4.7. Recording payments and maintaining financial transaction histories.",
          "4.8. Generating accounting statements and collection reports.",
          "4.9. Identifying outstanding maintenance dues for authorised administrators.",
          "4.10. Registering, assigning and tracking maintenance complaints.",
          "4.11. Coordinating contractors, suppliers and service providers.",
          "4.12. Monitoring staff attendance and assigned duties.",
          "4.13. Maintaining asset and inventory records.",
          "4.14. Sending notices, announcements, payment reminders and service notifications.",
          "4.15. Providing technical support and responding to customer queries.",
          "4.16. Detecting unauthorised access, fraudulent activities and security threats.",
          "4.17. Complying with applicable legal and regulatory obligations.",
          "4.18. Improving the functionality, reliability and security of the application.",
        ],
      ),
      _sectionCard(
        number: "05",
        title: "ACCESS TO DEVICE PERMISSIONS",
        paragraphs: [
          "STAYO may request access to certain device features depending on the functionality being used:",
          "5.1 Camera Permission: To capture visitor photographs, maintenance issue photos, inspection images, inventory conditions, or supporting documents.",
          "5.2 Gallery and Photo Access: To upload profile pictures, property photos, complaint pictures, and inspection reports.",
          "5.3 Location Permission: Where necessary for location-dependent features such as recording staff attendance.",
          "5.4 Notification Permission: To send visitor arrival alerts, delivery updates, maintenance status, payment reminders, and emergency announcements.",
          "5.5 Storage and File Access: To download or upload invoices, receipts, inspection reports, and property documents.",
        ],
      ),
      _sectionCard(
        number: "06",
        title: "VISITOR INFORMATION & THIRD-PARTY PERSONAL DATA",
        paragraphs: [
          "6.1. STAYO may process information relating to visitors who enter registered properties or residential communities.",
          "6.2. Such information may be entered by residents, security personnel, administrators or other authorised users.",
          "6.3. Property owners, associations and administrators are responsible for ensuring that visitor information is collected and processed in accordance with applicable laws and legitimate security requirements.",
          "6.4. Visitors should be informed about the collection and use of their information through appropriate notices or other legally compliant mechanisms.",
          "6.5. Visitor photographs, contact details, vehicle numbers and entry records shall be accessed only by authorised individuals for legitimate property management and security purposes.",
          "6.6. Visitor information shall not be used for unrelated commercial purposes or disclosed to unauthorised individuals.",
          "6.7. STAYO may provide digital records of visitor movements to authorised property administrators in accordance with the applicable access permissions and retention policy.",
          "6.8. The physical security and verification of visitors shall remain the responsibility of the concerned property administration and authorised security personnel.",
        ],
      ),
      _sectionCard(
        number: "07",
        title: "SHARING OF PERSONAL INFORMATION",
        paragraphs: [
          "STAYO does not sell personal information to third parties for commercial use. Information may be shared with authorised parties only for legitimate operational or legal purposes:",
          "7.1. Property Owners and Administrators: For official property management, billing, and communication.",
          "7.2. Security Personnel: To coordinate entry gates and visitor logs.",
          "7.3. Payment Gateway Providers: For secure payment processing.",
          "7.4. Contractors and Service Providers: For maintenance issue resolution.",
          "7.5. Technology and Cloud Providers: For hosting, database storage, and messaging under strict confidentiality.",
          "7.6. Legal and Regulatory Authorities: When required by law or valid court order.",
          "7.7. Business Transfers: In the event of a merger, acquisition, or restructuring.",
        ],
      ),
      _sectionCard(
        number: "08",
        title: "ACCESS CONTROL AND CONFIDENTIALITY",
        paragraphs: [
          "8.1. STAYO provides role-based access permissions so users access only information relevant to their assigned responsibilities.",
          "8.2. Residents do not have access to confidential personal or financial data of other residents.",
          "8.3. Security personnel access only visitor and entry-related records necessary for their duties.",
          "8.4. Financial information is accessible only to authorised association office-bearers.",
          "8.5. Administrators are responsible for managing and revoking permissions.",
          "8.6. Users must not disclose, copy or distribute confidential records without authority.",
          "8.7. System audit logs are maintained to trace administrative actions and prevent unauthorized access.",
        ],
      ),
      _sectionCard(
        number: "09",
        title: "DATA STORAGE AND SECURITY",
        paragraphs: [
          "9.1. STAYO implements reasonable technical and organizational measures to safeguard personal information:",
          "• Authentication and role-based access control.",
          "• Secure encrypted data transmission (HTTPS / SSL).",
          "• Password hashing and token security.",
          "• Periodic system backups and vulnerability monitoring.",
          "• Strict infrastructure controls.",
          "9.2. Access is restricted to personnel on a strict need-to-know basis.",
          "9.3. In the event of a data incident, prompt steps will be taken to contain the issue and inform affected parties/authorities as per applicable Indian law.",
        ],
      ),
      _sectionCard(
        number: "10",
        title: "DATA RETENTION AND DELETION",
        paragraphs: [
          "10.1. Personal data is retained only for as long as needed to fulfill operational purposes or legal requirements.",
          "10.2. Account information is retained for the active account duration plus any statutory retention periods.",
          "10.3. Visitor records are retained per property security policies and applicable schedules.",
          "10.4. Financial records are retained according to statutory tax and auditing timelines.",
          "10.5. Users may request deletion of their personal information via designated support channels, subject to statutory retention obligations.",
        ],
      ),
      _sectionCard(
        number: "11",
        title: "USER RIGHTS AND CONTROL OVER PERSONAL INFORMATION",
        paragraphs: [
          "Subject to applicable Indian laws, users have the right to:",
          "11.1. Inquire about the processing of their personal data.",
          "11.2. Request correction of inaccurate or incomplete information.",
          "11.3. Request completion or updating of records.",
          "11.4. Request erasure of personal data where legally permissible.",
          "11.5. Withdraw consent where consent is the basis of processing.",
          "11.6. Register grievances regarding personal data processing.",
          "11.7. Nominate representatives to exercise data protection rights where permissible.",
          "Users may submit requests through the STAYO Grievance Officer.",
        ],
      ),
      _sectionCard(
        number: "12",
        title: "CHILDREN'S PERSONAL INFORMATION",
        paragraphs: [
          "12.1. STAYO is intended for adult users (property owners, residents, tenants, administrators, staff).",
          "12.2. Minors are not registered as independent users.",
          "12.3. Any necessary family/dependent details must be managed directly by an authorized parent or legal guardian.",
        ],
      ),
      _sectionCard(
        number: "13",
        title: "THIRD-PARTY SERVICES AND EXTERNAL PLATFORMS",
        paragraphs: [
          "13.1. The application may integrate with external third parties such as payment gateways, SMS gateways, and cloud infrastructure.",
          "13.2. These service providers handle data under their respective privacy policies.",
          "13.3. STAYO takes appropriate steps to partner only with trustworthy and compliant providers.",
        ],
      ),
      _sectionCard(
        number: "14",
        title: "COMMUNICATIONS AND NOTIFICATIONS",
        paragraphs: [
          "14.1. Contact information is used for essential service updates: account verification, gate arrival alerts, delivery notices, maintenance tickets, and payment receipts.",
          "14.2. Essential operational notifications cannot be disabled without impairing application features.",
          "14.3. Marketing messages (if any) require opt-in and can be unsubscribed anytime.",
        ],
      ),
      _sectionCard(
        number: "15",
        title: "FINANCIAL AND ACCOUNTING INFORMATION",
        paragraphs: [
          "15.1. Maintenance collections, dues, and expense records are processed strictly for property management.",
          "15.2. Individual resident payment history is private and visible only to that resident and authorized association treasurers/administrators.",
        ],
      ),
      _sectionCard(
        number: "16",
        title: "PROPERTY OWNER & ASSOCIATION RESPONSIBILITIES",
        paragraphs: [
          "16.1. Associations and owners uploading data must ensure lawful collection, proper notice, and valid authority.",
          "16.2. They must ensure role permissions are reviewed periodically and deactivated when personnel or tenants move out.",
          "16.3. Associations are independently responsible for compliance under Indian data protection laws for data they control.",
        ],
      ),
      _sectionCard(
        number: "17",
        title: "LOCATION INFORMATION",
        paragraphs: [
          "17.1. Location access may be requested solely for features that demand location verification (e.g. staff attendance on-premise).",
          "17.2. Location is not tracked continuously in the background.",
        ],
      ),
      _sectionCard(
        number: "18",
        title: "COOKIES AND APPLICATION ANALYTICS",
        paragraphs: [
          "18.1. STAYO digital interfaces may use cookies or analytics tools to enhance stability, detect crashes, and monitor performance.",
        ],
      ),
      _sectionCard(
        number: "19",
        title: "INTERNATIONAL DATA PROCESSING",
        paragraphs: [
          "19.1. Secure cloud infrastructure used by STAYO may process or store data in compliance with applicable Indian data protection laws and government regulations.",
        ],
      ),
      _sectionCard(
        number: "20",
        title: "DATA BREACH AND SECURITY INCIDENTS",
        paragraphs: [
          "20.1. STAYO maintains active incident response procedures to contain any vulnerability and notify affected users as mandated by Indian cybersecurity regulations.",
        ],
      ),
      _sectionCard(
        number: "21",
        title: "CHANGES TO THIS PRIVACY POLICY",
        paragraphs: [
          "21.1. STAYO may update this policy periodically. Updated policies will be published in-app with notice of material revisions.",
        ],
      ),
      _contactCard(
        title: "22. GRIEVANCE REDRESSAL & DATA PROTECTION CONTACT",
        phone: "9567345740",
        email: "ascentpmscare@gmail.com",
        website: "www.ascentpms.care",
        office:
            "First floor, Krishnapriya, Ganapathy Kovil road, Vazhuthacaud, Trivandrum-14",
        grievanceOfficer: "Ascent PMS Grievance Officer",
      ),
      _sectionCard(
        number: "23",
        title: "CONSENT AND ACKNOWLEDGEMENT",
        paragraphs: [
          "By registering or using the STAYO application, users acknowledge that they have been provided access to this Privacy Policy and understand the manner in which their personal information may be processed.",
          "Users acknowledge that:",
          "1. Their information may be collected for property management and application-related purposes.",
          "2. Relevant information may be shared with authorised property administrators and service providers where necessary.",
          "3. Visitor, delivery and maintenance information may be processed to facilitate property operations.",
          "4. Financial information may be processed to maintain maintenance collection and accounting records.",
          "5. Their applicable privacy rights may be exercised through the designated grievance channels.",
          "6. Their information shall be handled in accordance with this Privacy Policy and applicable Indian data protection laws.",
        ],
      ),
    ];
  }
}
