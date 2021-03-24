import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/models/terms_conditions.dart';

class TermsAndConditionsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    List<TermsConditions> tcEnglish = [];

    tcEnglish.addAll([
        TermsConditions(
            header: 'Chapter 1 Total Code',
            data: [
            TermsConditionsData(
              title: 'Article 1 (Purpose)',
              contents: [
                'The purpose of this Agreement (hereinafter referred to as the "Terms and Conditions") is to prescribe basic matters, such as rights, duties, responsibilities, conditions and procedures between the members and the company in using the services provided by the company (hereinafter referred to as the "service") between LET\'S BEE (hereinafter referred to as the "company").'
              ]
            ),
            TermsConditionsData(
              title: 'Article 2 (Definitions of Terms)',
              contents: [
                'The terms used in these Terms and Conditions are defined as follows:',
                '(1) "Service" means an online platform service for reservation, purchase, information provision, and recommendation of related products, services, services, etc. (hereinafter referred to as "product lights") provided by the company (not limited to accommodation, leisure, ticket, class, etc.). Service means various services, such as LET\'S BEE and LET\'S BEE related web (Web) and app (App), regardless of the devices or terminals (including and not limited to various wired and wireless devices such as PCs, TVs, or portable terminals) that are implemented, and includes cases where services are provided to users through programs or services developed or implemented by third parties using APIs disclosed by the company. As leisure culture changes and technology develops, services continue to change and grow together.',
                '(2) "Member" : refers to a customer who enters into a service, enters into a service contract with the company under this Agreement, uses the services provided by the company, and includes a general customer (also known as a non-member customer) who has not generated a member account (ID/PW).',
                '(3) "Seller" means a person who sells his/her products, services, services, etc. using the services provided by the company, and refers to a person who receives reservations, sales agencies, advertising services, etc. from the company.',
                '(4) "Publishing materials": Signs (including URLs), letters, voice, sounds, videos (including videos), images (including photos), files, etc. posted by members and customers.',
                '(5) "Coupon": refers to discount coupons, preferential tickets, etc. (whether online, mobile, or offline, etc.) in which a member can receive discounts on the amount or ratio indicated when using the service. The type and content of the coupon may vary depending on the company\'s policy.',
                '(6) "Point": The company provides the member with the benefit of using the service or for the convenience of the service use. It refers to the digitized virtual data that can be used for payment, such as products in the service. Specific usage methods, their names (e.g., mileage, etc.) and their availability for cash refund may vary depending on the company\'s policy.',
              ]
            ),
            TermsConditionsData(
              title: 'Article 3 (Activity and Change of Terms and Conditions)',
              contents: [
                '(1) This Agreement shall be effective for all members who wish to use the service. However, in the case of \'Air Service\', the terms and conditions of the operator (Ex: Kayak, etc.) that provide ticket information to the company other than these terms apply (detailed information is indicated separately in the Air Service Area).',
                '(2) This Agreement can be viewed when a member subscribes to the service, and the company posts it on the company\'s website or app so that the member can access the agreement whenever he or she wants.',
                '(3) The company may amend this Agreement to the extent that it does not violate the relevant laws, such as the Act on the Regulation of Terms, the Act on the Protection of Consumers in Electronic Commerce, etc., the Promotion of Information and Communications Network Utilization and Information Protection (hereinafter referred to as the "Information and Communications Network Act"), the Framework Act on Consumers, and the Framework Act on Electronic Documents and Electronic Trade.',
                '(4) If the company changes the terms and conditions, it will announce the date of application and the reason for the change 7 days before the date of application. However, if the terms and conditions are changed unfavorable to the members, the members shall be notified 30 days prior to the date of application in the same way, and the members shall be notified individually by e-mail, etc. However, if individual notification is difficult due to the member\'s non-existing of contact information or non-modification after change, the notice shall be regarded as individual notification.',
                '(5) If the company notifies or notifies the revised terms and conditions pursuant to paragraph (4), and notifies the members that it has agreed to the terms and conditions if the company does not express its refusal by the date of application of the terms and conditions, the members shall be deemed to have agreed to the amended terms and conditions.',
                '(6) If the member does not agree to the changed terms and conditions, he/she may discontinue the service and terminate the service contract',
                '(7) A member shall fulfill his/her duty of care for the modification of the terms and conditions, and the company shall not be responsible for the damage caused by the site of the changed agreement.',
              ]
            ),
            TermsConditionsData(
              title: 'Article 4 (Relationship with regulations and related statutes other than the terms and conditions)',
              contents: [
                '(1) The provisions of the relevant laws, such as the Telecommunications Business Act, the Framework Act on Electronic Documents and Electronic Transactions, the Act on Promotion of Information and Communications Network Utilization and Information Protection, the Act on the Protection of Consumers in Electronic Commerce, and the Personal Information Protection Act, are in accordance with the provisions of the relevant laws and detailed guidelines for the use of services. In addition, the Company\'s liability restrictions set forth in these Terms shall apply to the maximum extent permitted by applicable laws.',
                '(2) The company may, if necessary, set individual terms and conditions or operating principles for individual items in the service, and if the contents of the individual terms and conditions or operating principles conflict with these terms and conditions, the details of the individual terms and conditions or operating principles shall be applied first.'
              ]
            ),
          ],
        ),
        TermsConditions(
          header: 'Chapter 2 Signing a Service Agreement',
          data: [
            TermsConditionsData(
              title: 'Article 5 (Enforcement of a contract for use)',
              contents: [
                'The service contract is concluded when the person who intends to become a member (hereinafter referred to as "applicant") agrees to the terms and conditions, fills in the membership information in accordance with the subscription form set by the company, and the company approves such application.'
              ]
            ),
            TermsConditionsData(
              title: 'Article 6 (Preservation and Rejection of Use Contracts)',
              contents: [
                '1 The company may not approve the following applications or terminate the service contract afterwards:',
                '(1) In the case of false entries or omission or error in the application form,',
                '(2) In the case of using another person\'s name, e-mail, contact information, etc.;',
                '(3) In the case of an application for the purpose of violating the relevant statutes or undermining the order or customs of society;',
                '(4) Exceptions shall not apply where an applicant has lost his or her membership in accordance with these terms and conditions, or if he or she has obtained prior consent from the company.',
                '(5) Where approval is impossible due to reasons attributable to the member;',
                '(6) If the telephone number or E-mail information is the same as the member who has already joined.',
                '(7) Where he/she intends to use this service for the purpose of pursuing fraudulent use or profit;',
                '(8) Other cases where it is confirmed that an application for illegal or unjust use is in violation of these terms and conditions, and the company deems it necessary by reasonable judgment;',
                '(9) Where a child under the age of 14 applies;',
                '2 In applying under paragraph (1), the company can request self-certification by verifying the mobile phone number or real name through a specialized institution.',
                '3 The company may withhold its acceptance of membership registration in the following cases:',
                '(1) Where there is no realistic margin for service facilities;',
                '(2) Where it is deemed that there is a technical problem in providing the service;',
                '(3) Where the company deems it necessary financially and technically;',
                '(4) Where the real name verification and self-certification procedures are in progress under paragraph (2);',
                '4 If the company fails to accept or withholds the application for membership pursuant to paragraphs (1) and (3), the company shall notify the applicant of the refusal or reservation of approval in accordance with the method determined by the company.',
                '5 The time of establishment of the service contract shall be the time when the company marks the completion of the subscription in the application procedure or notifies the company separately.',
              ]
            ),
            TermsConditionsData(
              title: 'Article 7 (Management of Member Information)',
              contents: [
                '1 The members can view, change, and modify personal information through the information modification function or customer center provided in the website or app.',
                '2 If the registered E-mail address or contact information is changed, the member shall change it in accordance with paragraph (1) in order to maintain the current status of the member information, and any disadvantages that may arise from not changing such information shall be borne by the member.'
              ]
            ),
            TermsConditionsData(
              title: 'Article 8 (Management responsibility of account information)',
              contents: [
                '1 The member is responsible for managing the account information, such as ID and password, and the member cannot transfer or lend the account information to another person.',
                '2 The company shall not be held liable for any loss or damage caused by leakage, transfer, loan, or sharing of account information except for reasons attributable to the company.',
                '3 If a third party recognizes that his/her account is being used (including a loan), the member shall immediately take measures such as modifying the password and notify the company. The member shall be responsible for all disadvantages caused by the member\'s failure to give notice under this paragraph.'
              ]
            ),
            TermsConditionsData(
              title: 'Article 9 (collection and protection of member information)',
              contents: [
                '1 In providing services, the company complies with the statutes related to personal information and collects, uses, stores, and provides member information accordingly.',
                '2 In addition to the information directly provided by the members in the service use process, the company can collect and use other information or provide it to third parties in accordance with the procedures prescribed by the relevant statutes, such as personal information protection. In this case, the company obtains the necessary consent from the members in accordance with the relevant statutes or complies with the procedures prescribed by the relevant statutes.',
                '3 The company strives to protect the members\' personal information as stipulated by the laws and regulations related to the protection of personal information, and details of the company\'s handling of personal information can be checked at any time through the Privacy Policy.',
                '4 The company\'s Privacy Policy does not apply to linked sites other than the company\'s official site or app. The member shall be responsible for checking the personal information processing policies of the website and third party for the handling of the personal information of the third party that provides the linked site and service, and the company shall not be held liable for such processing.'
              ]
            ),
          ],
        ),
        TermsConditions(
          header: 'Chapter 3 Using the Service',
          data: [
            TermsConditionsData(
              title: 'Article 10 (Starting the use of services)',
              contents: [
                'The members can use the service from the time the company approves the application, and the company provides the service according to the main terms and conditions from the time the company approves the application.'              ]
            ),
            TermsConditionsData(
              title: 'Article 11 (right of a person liable for protection of children, etc. under the age of eight)',
              contents: [
                '1. The company shall consider that if the person liable for protection (hereinafter referred to as "child under 8 years of age") agrees to use or provide personal location information for the protection of the life or body of children under 8 years of age, etc., he/she shall have the consent of himself/herself.',
                '1) Children under 8 years of age',
                '2) An incompetent person',
                '3) Persons with mental disabilities under Article 2(2)2 of the Act on Welfare of Persons with Disabilities, who are severely disabled under Article 2(2) of the Employment Promotion and Vocational Rehabilitation of Persons with Disabilities Act (limited to those who have registered as persons with disabilities under Article 29 of the Act on Welfare of Persons with Disabilities)',
                '2. A person liable for protection who intends to consent to the use or provision of personal location information for the protection of the life or body of a child under 8 years of age shall submit a written consent to the company along with a letter proving that he/she is responsible for protection.',
                '3. A person liable for protection may exercise all of his/her right to personal location information if he/she agrees to use or provide personal location information, such as children under the age of 8.'
              ]
            ),
            TermsConditionsData(
              title: 'Article 12 (Restrictions on Goods)',
              contents: [
                '1. Some of the Goods we offer on our Platforms are subject to restrictions for purchase ("Restricted Goods"), depending on the applicable laws of the country you purchase the Restricted Goods from.',
                'These restrictions inchude minimum age requirements for alcohol/alcoholic products and any other goods that we reserve the right not to deliver to you based on the relebant statutory requirements of the time being in force.',
                '2. Alcohol / Alcoholic Products ("Alcohol")',
                'To purchase Alcohol, you must be of the statutory legal age. "Let\'s Bee", the Vendor and their delivery riders, as the case may be, reserve the right in their sole discretion:',
                '2-1 to ask for valid proof of age (e.g. ID card) to any persons before deliver Alcochol;',
                '2-2 to refuse delivery if you are unable to probe you are of legal age; and/or',
                '2-3 to refuse delivery to any persons for any reason whatsover.',
                '3. Cigarettes/ Tobacco Products ("Tobacco")',
                'We may offer Tobacco on some of our Platforms where the laws allow. By offerring Tobacco for sale on our Platforms, we do not purport to abvertise, promote or encourage the purchase or use of Tobacco in any way.',
                '3-1 To Purchase Tobacco, you must be of the statutory legal age.',
                '3-2 "Let\'s Bee", the Vendor and their delivery riders, as the case may be, resrve the right in yheir sole discretion:',
                '3-3 to ask for valid proof of age (e.g. ID card) to any persons before they deliver Tobacco;',
                '3-4 to refuse delivery if you are unable to prove you are of legal age ; and/or',
                '3-5 to refuse delivery to any persons for any reason whatsover.',
                '4. Any offer for any Alcohol and Tobacco made on the Platforms is void when it is prohidited by law.',
              ]
            ),
            TermsConditionsData(
              title: 'Article 13 (Designated by the Director of Location Information Management)',
              contents: [
                '1. The company designates and operates a person in a position who can take actual responsibility for proper management and protection of location information and smoothly handle complaints from the person in charge of personal location information.',
                '2. The person in charge of location information management is the head of the department that provides location-based services, and the details are in accordance with the provisions of this Agreement.'
              ]
            ),
            TermsConditionsData(
              title: 'Article 14 (Scope of Damage Compensation)',
              contents: [
                '1. In the event that a member suffers damage due to an act in violation of the provisions of Articles 15 through 26 of the Act on the Protection and Use of Location Information, the member may claim damages from the company. In this case, the company cannot escape responsibility unless it proves that there is no intention or negligence.',
                '2. If a member violates the provisions of this Agreement and damages the company, the company may claim damages against the member. In this case, the member shall not be exempted from responsibility unless he/she proves that there is no intention or'
              ]
            ),
            TermsConditionsData(
              title: 'Article 15 (Excuse)',
              contents: [
                '1. If the company is unable to provide the service in any of the following cases, the company shall not be held liable for any damages caused to the member.',
                '1) In the event of a natural disaster or an equivalent force majeure.',
                '2) In the event that a third party that has entered into a service partnership agreement with the company intentionally interferes with the service.',
                '3) In the case of a member having difficulty in using the service due to reasons attributable to the member;',
                '4) In the case of a company other than those referred to in subparagraphs 1 through 3 due to a reason that is not intentional or culpable;',
                '2. The company does not guarantee the reliability, accuracy, etc. of information, data, and facts posted on the service and shall not be held liable for damages caused by the service.'
              ]
            ),
            TermsConditionsData(
              title: 'Article 16 (Enforcement of Regulations)',
              contents: [
                '1. These Terms and Conditions are prescribed and implemented by the laws of the Republic of Korea.',
                '2. Matters not specified in these Terms and Conditions shall be governed by relevant statutes and customs.'
              ]
            ),
            TermsConditionsData(
              title: 'Article 17 (Adjustment of Disputes and Other)',
              contents: [
                '1. The company may apply for financial support to the Korea Communications Commission under Article 28 of the Act on the Protection and Utilization of Location Information if the parties cannot consult or discuss disputes related to location information.'
                '2. If there is no consultation between the parties regarding disputes related to location information or it is not possible to discuss them, the Personal Information Dispute Mediation Committee under Article 43 of the Personal Information Protection Act may apply for mediation.'
              ]
            ),
            TermsConditionsData(
              title: 'Article 18 (Contact of Company) The company\'s name and address are as follows.',
              contents: [
                '1. Business Name : Let\'s Bee',
                '2. Address: Block5 Lot4, Yukon St, Riverside Subdivision ,Anunas,Angels City Pampanga 2009',
                '3. Representative Contact Number : 09451076000',
                '4. Email address: letsbeedelivery2019@gmail.com',
              ]
            ),
          ],
        ),
        TermsConditions(
          header: 'A minor rule',
          data: [
            TermsConditionsData(
              title: 'Article 1 (Enforcement Date) This Agreement shall enter into force on October 1, 2019.',
              contents: []
            ),
            TermsConditionsData(
              title: 'Article 2 As of October 1, 2019, the Personal Location Manager shall designate as follows:',
              contents: [
                'Personal Location Information Officer',
                'Name : You Hyun Sang',
                'Contact:09451076000'
              ]
            )
          ]
        )
      ],
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.chevron_left), onPressed: () => Get.back()),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(tr('termsConditions'), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: PreferredSize(
          child: Container(height: 1, color: Colors.grey.shade200),
          preferredSize: Size.fromHeight(4.0)
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerTitle(),
              Column(
                children: tcEnglish.map((list) => _buildExpandable(list)).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandable(TermsConditions list) {
    return Theme(
      data: Theme.of(Get.context).copyWith(dividerColor: Colors.transparent, accentColor: Colors.black),
      child: ExpansionTile(
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.circle, size: 5),
              Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
              Expanded(
                child: Text(
                  list.header, 
                  style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500), 
                  textAlign: TextAlign.start
                ),
              ),
            ],
          ),
        ),
        expandedAlignment: Alignment.centerLeft,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        childrenPadding: EdgeInsets.zero,
        tilePadding: EdgeInsets.zero,
        children: list.data.isNotEmpty ? list.data?.map((data) => _buildExpandableList(data))?.toList() : [],
      )
    );
  }

  Widget _buildExpandableList(TermsConditionsData data) {
    return ExpansionTile(
      title: Expanded(
        child: Text(
          data.title, 
          style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500), 
          textAlign: TextAlign.start
        ),
      ),
      expandedAlignment: Alignment.centerLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      childrenPadding: EdgeInsets.zero,
      tilePadding: EdgeInsets.only(left: 15, right: 15),
      children: data.contents.map((data) => _buildContent(data)).toList(),
    );
  }
  
  Widget _buildContent(String content) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      child: Text(
        content, 
        style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w500), 
        textAlign: TextAlign.start
      ),
    );
  }

  Widget _headerTitle() {
    return Text(
      'The terms and conditions of this Agreement include the consent to receive commercial information for profit.', 
      style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w500), 
      textAlign: TextAlign.justify
    );
  }
}