import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/models/terms_conditions.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';

class TermsAndConditionsPage extends GetView<DashboardController> {

  @override
  Widget build(BuildContext context) {

    List<TermsConditions> tcEnglish = [];
    List<TermsConditions> tcKorean = [];

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

    tcKorean.addAll([
        TermsConditions(
            header: '제1장 총 칙',
            data: [
            TermsConditionsData(
              title: '제1조 (목적)',
              contents: [
                '이 약관(이하 “약관”이라 합니다)은 레츠비(이하 “회사”라 합니다)와 이용 고객(이하 “회원”이라 합니다)간에 회사가 제공하는 서비스(이하 “서비스”라 합니다)를 이용함에 있어 회원과 회사간의 권리, 의무 및 책임사항, 이용조건 및 절차 등 기본적인 사항을 규정함을 목적으로 합니다.'
              ]
            ),
            TermsConditionsData(
              title: '제2조 (용어의 정의)',
              contents: [
                '본 약관에서 사용되는 용어의 정의는 다음과 같습니다',
                '(1) “서비스” : 회사가 제공하는 여가(숙박∙레저∙티켓∙클래스 등으로 이에 한정되지 않음) 관련 상품∙용역∙서비스 등(이하 “상품등”이라 합니다)에 대한 예약∙구매∙정보제공∙추천 등을 위한 온라인 플랫폼 서비스를 의미합니다. 서비스는 구현되는 장치나 단말기(PC, TV, 휴대형 단말기 등의 각종 유무선 장치를 포함하며 이에 한정되지 않음)와 상관 없이 레츠비및 레츠비관련 웹(Web)∙앱(App) 등의 제반 서비스를 의미하며, 회사가 공개한 API를 이용하여 제3자가 개발 또는 구축한 프로그램이나 서비스를 통하여 이용자에게 제공되는 경우를 포함합니다. 서비스는 여가 문화가 변하고 기술이 발전함에 따라 지속적으로 함께 변화∙성장해 나갑니다.'
                '(2) “회원” : 서비스에 접속하여 본 약관에 따라 회사와 이용계약을 체결하고 회사가 제공하는 서비스를 이용하는 고객을 말하며, 회원계정(ID/PW)을 생성하지 않은 일반 고객(일명 비회원 고객)도 포함됩니다.',
                '(3) “판매자” : 회사가 제공하는 서비스를 이용하여 자신의 상품∙용역∙서비스 등을 판매하는 자를 의미하며, 회사로부터 예약∙판매 대행, 광고 서비스 등을 제공받는 자를 말합니다.',
                '(4) “게시물” : 회원 및 이용 고객이 서비스에 게시 또는 등록하는 부호(URL 포함), 문자, 음성, 음향, 영상(동영상 포함), 이미지(사진 포함), 파일 등을 말합니다.',
                '(5) “쿠폰” : 회원이 서비스를 이용할 때 표시된 금액 또는 비율만큼 이용 금액을 할인 받을 수 있는 할인권∙우대권 등(온라인∙모바일∙오프라인 등 형태를 불문)를 말합니다. 쿠폰의 종류 및 내용은 회사의 정책에 따라 달라질 수 있습니다.',
                '(6) “포인트” : 회사가 회원의 서비스 이용에 따른 혜택 또는 서비스 이용상 편의를 위해 회원에게 제공하는 것으로서 서비스 내 상품 등 결제시 활용할 수 있는 수치화 된 가상의 데이터를 말합니다. 구체적인 이용 방법, 그 명칭(예: 마일리지 등) 및 현금 환급가능성 등은 회사의 정책에 따라 달라질 수 있습니다.'
              ]
            ),
            TermsConditionsData(
              title: '제3조 (약관의 효력 및 변경)',
              contents: [
                '① 본 약관은 서비스를 이용하고자 하는 모든 회원에 대하여 그 효력을 발생합니다. 단, \'항공 서비스\'의 경우 본 약관이 아닌 회사에 항공권 정보를 제공하는 사업자(Ex: Kayak 등)의 약관이 적용됩니다(자세한 안내는 항공 서비스 영역에 별도 표시).',
                '② 본 약관은 회원이 서비스 가입 시 열람 할 수 있으며, 회사는 회원이 원할 때 언제든지 약관을 열람 할 수 있도록 회사 홈페이지 또는 앱 내에 게시합니다.',
                '③ 회사는 『약관의 규제에 관한 법률』, 『전자상거래 등에서의 소비자보호에 관한 법률』, 『정보통신망 이용촉진 및 정보보호(이하 “정보통신망법”이라 합니다)』, , 『소비자기본법』, 『전자문서 및 전자거래 기본법』 등 관련법에 위배되지 않는 범위 내에서 본 약관을 개정할 수 있습니다.',
                '④ 회사가 약관을 변경할 경우에는 적용일자, 변경사유를 명시하여 적용일로부터 7일 이전부터 공지합니다. 다만, 회원에게 불리한 약관 변경인 경우에는 그 적용일로부터 30일전부터 위와 같은 방법으로 공지하고, E-mail 등으로 회원에게 개별 통지합니다. 단, 회원의 연락처 미기재, 변경 후 미수정 등으로 인하여 개별 통지가 어려운 경우 공지를 개별 통지로 간주합니다.',
                '⑤ 회사가 제4항에 따라 개정약관을 공지 또는 통지하면서, 회원에게 약관 변경 적용일 까지 거부의사를 표시하지 않으면 약관의 변경에 동의한 것으로 간주한다는 내용을 공지 또는 통지하였음에도 회원이 명시적으로 약관 변경에 대한 거부의사를 표시하지 아니하는 경우 회원이 개정약관에 동의한 것으로 간주합니다.',
                '⑥ 회원은 변경된 약관에 동의하지 아니하는 경우 서비스의 이용을 중단하고 이용계약을 해지할 수 있습니다.',
                '⑦ 회원은 약관 변경에 대하여 주의의무를 다하여야 하며, 변경된 약관의 부지로 인한 회원의 피해는 회사가 책임지지 않습니다.'
              ]
            ),
            TermsConditionsData(
              title: '제4조 (약관 외 준칙 및 관련법령과의 관계)',
              contents: [
                '① 본 약관 또는 개별약관에서 정하지 않은 사항은 『전기통신사업법』, 『전자문서 및 전자거래 기본법』, 『정보통신망 이용촉진 및 정보보호 등에 관한 법률』, 『전자상거래 등에서의 소비자보호에 관한 법률』, 『개인정보보호법』 등 관련 법의 규정 및 회사가 정한 서비스의 세부이용지침 등의 규정에 따릅니다. 또한 본 약관에서 정한 회사의 책임 제한 규정은 관련 법령이 허용하는 최대한도의 범위 내에서 적용됩니다.',
                '② 회사는 필요한 경우 서비스 내의 개별항목에 대하여 개별약관 또는 운영원칙을 정할 수 있으며, 본 약관과 개별약관 또는 운영원칙의 내용이 상충되는 경우에는 개별약관 또는 운영원칙을 의 내용이 우선 적용됩니다.'
              ]
            ),
          ],
        ),
        TermsConditions(
          header: '제2장 이용계약의 체결',
          data: [
            TermsConditionsData(
              title: '제5조 (이용계약의 성립)',
              contents: [
                '이용계약은 회원이 되고자 하는 자(이하 “가입신청자”)가 약관의 내용에 동의를 하고, 회사가 정한 가입 양식에 따라 회원정보를 기입하여 회원가입신청을 하고 회사가 이러한 신청에 대하여 승인함으로써 체결됩니다.'
              ]
            ),
            TermsConditionsData(
              title: '제6조 (이용계약의 유보 및 거절)',
              contents: [
                '① 회사는 다음 각 호에 해당하는 신청에 대하여는 승인 하지 않거나 사후에 이용계약을 해지할 수 있습니다.',
                '(1) 가입신청서의 내용을 허위로 기재하거나 기재누락∙오기가 있는 경우',
                '(2) 다른 사람의 명의, E-mail, 연락처 등을 이용한 경우',
                '(3) 관계법령에 위배되거나 사회의 안녕질서 또는 미풍양속을 저해할 목적으로 신청한 경우',
                '(4) 가입신청자가 본 약관에 의하여 이전에 회원자격을 상실한 적이 있는 경우, 단 회사의 사전재가입 승낙을 얻은 경우에는 예외로 함',
                '(5) 회원의 귀책사유로 인하여 승인이 불가능한 경우',
                '(6) 이미 가입된 회원과 전화번호나 E-mail 정보가 동일한 경우',
                '(7) 부정한 용도 또는 영리를 추구할 목적으로 본 서비스를 이용하고자 하는 경우',
                '(8) 기타 본 약관에 위배되거나 위법 또는 부당한 이용신청임이 확인된 경우 및 회사가 합리적인 판단에 의하여 필요하다고 인정하는 경우',
                '(9) 만 14세 미만의 아동이 신청할 경우',
                '② 제1항에 따른 신청에 있어 회사는 전문기관을 통한 휴대전화번호 인증 내지 실명확인을 통한 본인인증을 요청할 수 있습니다.',
                '③ 회사는 아래 각 호에 해당하는 경우에는 회원등록의 승낙을 유보할 수 있습니다.',
                '(1) 제공서비스 설비용량에 현실적인 여유가 없는 경우',
                '(2) 서비스를 제공하기에는 기술적으로 문제가 있다고 판단되는 경우',
                '(3) 회사가 재정적, 기술적으로 필요하다고 인정하는 경우',
                '(4) 제2항에 따른 실명확인 및 본인인증 절차를 진행 중인 경우',
                '④ 제1항과 제3항에 따라 회원가입신청의 승낙을 하지 아니하거나 유보한 경우, 회사는 승낙거절 또는 유보 사실을 가입신청자에게 회사가 정하는 방법에 따라 통지합니다.',
                '⑤ 이용계약의 성립 시기는 회사가 ‘가입완료’ 사실을 신청절차 상에 표시하거나 별도로 통지한 시점으로 합니다.'
              ]
            ),
            TermsConditionsData(
              title: '제7조 (회원 정보의 관리)',
              contents: [
                '① 회원은 웹사이트 또는 앱 내에 구비된 정보수정 기능 내지 고객센터 등을 통해 개인정보를 열람∙변경∙수정 할 수 있습니다.',
                '② 회원은 등록한 E-mail 주소 또는 연락처가 변경된 경우 회원정보의 최신성 유지를 위해 제1항에 따라 변경해야 하며 이를 변경하지 않아 발생 할 수 있는 모든 불이익은 회원이 부담합니다.'
              ]
            ),
            TermsConditionsData(
              title: '제8조 (계정정보의 관리책임)',
              contents: [
                '① 아이디, 비밀번호 등 계정정보의 관리책임은 회원에게 있으며, 회원은 계정정보를 타인에게 양도 내지 대여할 수 없습니다.',
                '② 회사는 회사의 귀책사유로 인한 경우를 제외하고 계정정보의 유출, 양도, 대여, 공유 등으로 인한 손실이나 손해에 대하여 아무런 책임을 지지 않습니다.',
                '③ 회원은 제3자가 본인의 계정을 사용하고 있음(대여 포함)을 인지한 경우에는 즉시 비밀번호를 수정하는 등의 조치를 취하고 이를 회사에 통보하여야 합니다. 회원이 본항에 따른 통지를 하지 아니하여 발생하는 모든 불이익에 대한 책임은 회원에게 있습니다.'
              ]
            ),
            TermsConditionsData(
              title: '제9조 (회원정보의 수집과 보호)',
              contents: [
                '① 회사는 서비스를 제공함에 있어 개인정보 관련 법령을 준수하고 그에 따라 회원 정보를 수집∙이용∙보관∙제공합니다.',
                '② 회사는 회원이 서비스 이용 과정에서 직접 제공한 정보 외에도 개인정보 보호 등 관련 법령에서 정한 절차에 따라 그밖의 정보를 수집 및 이용 또는 제3자에게 제공할 수 있습니다. 이 경우 회사는 관련 법령에 따라 회원으로부터 필요한 동의를 받거나 관련 법령에서 정한 절차를 준수합니다.',
                '③ 회사는 개인정보 보호 관련 법령이 정하는 바에 따라 회원의 개인정보를 보호하기 위해 노력하며, 회사의 개인정보 처리에 관한 자세한 사항은 개인정보처리방침을 통해 언제든지 확인할 수 있습니다.',
                '④ 회사의 공식 사이트 또는 앱 이외에 링크된 사이트에서는 회사의 개인정보처리방침이 적용되지 않습니다. 링크된 사이트 및 서비스를 제공하는 제3자의 개인정보 처리에 대해서는 해당 사이트 및 제3자의 개인정보처리방침을 확인할 책임이 회원에게 있으며, 회사는 이에 대하여 책임을 부담하지 않습니다.'
              ]
            ),
          ],
        ),
        TermsConditions(
          header: '제3장 서비스 이용',
          data: [
            TermsConditionsData(
              title: '제10조 (서비스의 이용 개시)',
              contents: [
                '회원은 회사가 이용신청을 승낙한 때부터 서비스를 사용할 수 있고 회사는 위 승낙한 때부터 본약관에 따라 서비스를 제공합니다.'
              ]
            ),
            TermsConditionsData(
              title: '제11조 (서비스의 이용시간)',
              contents: [
                '① 서비스는 회사의 업무상 또는 기술상 특별한 사유가 없는 한 연중무휴 1일 24시간 제공함을 원칙으로 합니다. 회사는 서비스를 일정범위로 분할하여 각 범위 별로 이용가능시간을 별도로 지정할 수 있습니다.',
                '② 회사는 서비스의 제공에 필요한 경우 정기점검 내지 수시점검을 실시할 수 있으며, 정기점검 내지 수시점검 시간은 서비스제공화면에 공지한 바에 따릅니다.'
              ]
            ),
            TermsConditionsData(
              title: '제12조 (서비스의 내용)',
              contents: [
                '① 서비스는 제2조 제1호에서 정의한 바에 따라 회사가 회원에게 제공하는 여가 관련 온라인 플랫폼 서비스를 말합니다. 서비스는 현재 제공되는 상품등에 한정되지 않으며, 향후 추가로 개발되거나 다른 회사와의 제휴 등을 통해 추가∙변경∙수정될 수 있습니다.',
                '② 회사는 회원 감소 등으로 인한 원활한 서비스 제공의 곤란 및 수익성 악화, 기술 진보에 따른 차세대 서비스로의 전환 필요성, 서비스 제공과 관련한 회사 정책의 변경 등 기타 상당한 이유가 있는 경우에 운영상, 기술상의 필요에 따라 제공하고 있는 전부 또는 일부 서비스를 변경 또는 중단할 수 있습니다.',
                '③ 서비스의 내용, 이용방법, 이용시간에 대하여 변경 또는 서비스 중단이 있는 경우에는 변경 또는 중단될 서비스의 내용 및 사유와 일자 등은 그 변경 또는 중단 전에 회사 홈페이지 또는 서비스 내 "공지사항" 화면 등 회원이 충분히 인지할 수 있는 방법으로 30일의 기간을 두고 사전에 공지합니다.',
                '④ 무료로 제공되는 서비스의 특성상 본조에 따른 서비스의 전부 또는 일부 종료 시 관련법령에서 특별히 정하지 않는 한 회원에게 별도의 보상을 하지 않습니다.',
                '⑤ 서비스 이용에 관한 개별 안내, 상품등에 대한 정보, 예약시 유의사항, 취소∙환불정책 등은 개별 서비스 이용안내∙소개 등을 통해 제공하고 있습니다.',
                '⑥ 회원은 전항의 안내∙소개 등을 충분히 숙지하고 서비스를 이용하여야 합니다. 회사는 통신판매중개자로서 통신판매의 당사자가 아니고, 판매자가 상품등 이용에 관한 이용정책이나 예약에 관한 취소∙환불정책을 별도로 운영하는 경우가 있을 수 있으므로, 회원은 상품등 이용 또는 예약시 반드시 그 내용을 확인해야 합니다. 회원이 이 내용을 제대로 숙지하지 못해 발생한 피해에 대해서는 회사가 책임을 부담하지 않습니다.'
              ]
            ),
            TermsConditionsData(
              title: '제13조 (서비스의 변경 및 중지)',
              contents: [
                '① 회사는 변경될 서비스의 내용 및 제공일자를 본 약관 제19조에서 정한 방법으로 회원에게 고지하고 서비스를 변경하여 제공할 수 있습니다.',
                '② 회사는 다음 각 호에 해당하는 경우 서비스의 전부 또는 일부를 제한하거나 중지할 수 있습니다.',
                '(1) 회원이 회사의 영업활동을 방해하는 경우',
                '(2) 시스템 정기점검, 서버의 증설 및 교체, 네트워크의 불안정 등의 시스템 운영상 필요한 경우',
                '(3) 정전, 서비스 설비의 장애, 서비스 이용폭주, 기간통신사업자의 설비 보수 또는 점검∙중지 등으로 인하여 정상적인 서비스 제공이 불가능한 경우',
                '(4) 기타 중대한 사유로 인하여 회사가 서비스 제공을 지속하는 것이 부적당하다고 인정하는 경우',
                '(5) 기타 천재지변, 국가비상사태 등 불가항력적 사유가 있는 경우',
                '③ 제2항에 의한 서비스 중단의 경우 회사는 제21조에서 정한 방법으로 회원에게 통지합니다. 다만, 회사가 통제할 수 없는 사유로 인한 서비스의 중단(운영자의 고의∙과실이 없는 장애, 시스템다운 등)으로 인하여 사전 통지가 불가능한 경우에는 그러하지 아니합니다.',
                '④ 회사는 제2항에 따른 서비스의 변경, 중지로 발생하는 문제에 대해서 어떠한 책임도 지지 않습니다.'
              ]
            ),
            TermsConditionsData(
              title: '제14조 (정보 제공 및 광고의 게재)',
              contents: [
                '① 회사가 회원에게 서비스를 제공할 수 있는 서비스 투자기반의 일부는 광고 게재를 통한 수익으로부터 나옵니다. 이에 회원은 서비스 이용 시 서비스 화면 상 노출되는 광고 게재에 대해 동의합니다.'
                '② 회사는 회원의 게시물 내용, 검색 내용 뿐만 아니라 언어, 쿠키 및 기기정보, IP 주소, 브라우저 유형, 운영체제 및 요청 일시와 같은 표준 로그 정보 등을 활용한 맞춤광고를 제공합니다. 이에 대한 자세한 사항은 "개인정보처리방침"을 참고하시기 바랍니다.'
                '③ 회원이 서비스상에 게재되어 있는 광고를 이용하거나 서비스를 통한 광고주의 판촉활동에 다른 상품등을 이용하는 경우, 이는 전적으로 회원과 광고주 간의 법률관계이므로, 그로 인해 발생한 회원과 광고주간 분쟁 등 제반 문제는 회원과 광고주간에 직접 해결하여야 하며, 이와 관련하여 회사는 어떠한 책임도 지지 않습니다.'
                '④ 회사는 회원으로부터 수집한 개인정보를 통해 회원의 서비스 이용 중 필요하다고 판단되는 다양한 마케팅 정보를 SMS(LMS), 스마트폰 알림 (Push 알림), E-mail 등을 활용하여 발송할 수 있으며, 회원은 이에 동의합니다. 다만, 회원은 거래관련정보 및 고객문의 등에 대한 답변을 제외하고 관련법에 따라 언제든지 마케팅 수신 동의를 철회하실 수 있으며, 이 경우 회사는 전단의 마케팅 정보 등을 제공하는 행위를 중단합니다(단, 시스템 반영에 시차가 있을 수 있음).'
              ]
            ),
            TermsConditionsData(
              title: '제15조 (게시물에 대한 권리)',
              contents: [
                '① 게시물의 저작권은 회원에게 있습니다. 다만 회사는 게시∙전달∙공유 목적으로 회원이 작성한 게시물을 이용∙편집∙수정하여 이용할 수 있고, 회사의 다른 서비스 또는 연동채널∙판매채널에 이를 게재하거나 활용할 수 있습니다.',
                '② 회사가 서비스 내 게재 이외의 목적으로 게시물을 사용할 경우 게시물에 대한 게시자를 반드시 명시해야 합니다. 단, 게시자를 알 수 없는 익명 게시물이나 비영리적인 경우에는 그러하지 아니합니다.',
                '③ 회원은 게시물을 작성할 때 타인의 저작권 등 지식재산권을 포함하여 여타 권리를 침해하지 않아야 하고, 회사는 그에 대한 어떠한 책임도 부담하지 않습니다. 만일 회원이 타인의 권리 등을 침해하였음을 이유로 타인이 회사를 상대로 이의신청, 손해배상청구, 삭제요청 등을 제기한 경우 회사는 그에 필요한 조치를 취할 수 있으며, 그에 따른 모든 비용이나 손해배상책임은 회원이 부담합니다.',
                '④ 회사는 회원이 이용계약을 해지하고 사이트를 탈퇴하거나 적법한 사유로 해지된 경우 해당 회원이 게시하였던 게시물을 삭제할 수 있습니다.',
                '⑤ 회원이 작성한 게시물에 대한 모든 권리 및 책임은 이를 게시한 회원에게 있으며, 회사는 회원이 게시하거나 등록한 게시물이 다음 각 호에 해당한다고 판단되는 경우에 사전통지 없이 삭제 또는 임시조치할 수 있고, 이에 대하여 회사는 어떠한 책임도 지지 않습니다.',
                '(1) 다른 회원 또는 제3자를 비방하거나 명예를 손상시키는 내용인 경우',
                '(2) 공공질서 및 미풍양속에 위반되는 내용을 유포하거나 링크시키는 경우',
                '(3) 불법복제 또는 해킹을 조장하는 내용인 경우',
                '(4) 회사로부터 사전 승인 받지 않고 상업광고, 판촉 내용을 게시하는 경우',
                '(5) 개인 간 금전거래를 요하는 경우',
                '(6) 범죄적 행위에 결부된다고 인정되는 경우',
                '(7) 회사의 저작권, 제3자의 저작권 등 기타 권리를 침해하는 내용인 경우',
                '(8) 타인의 계정정보, 성명 등을 무단으로 도용하여 작성한 내용이거나, 타인이 입력한 정보를 무단으로 위변조한 내용인 경우',
                '(9) 사적인 정치적 판단이나 종교적 견해의 내용으로 회사가 서비스 성격에 부합하지 않는다고 판단하는 경우',
                '(10) 동일한 내용을 중복하여 다수 게시하는 등 게시의 목적에 어긋나는 경우',
                '(11) 회사에서 규정한 게시물 원칙에 어긋나거나, 게시물을 작성하는 위치에 부여된 성격에 부합하지 않는 경우',
                '(12) 사업주 변경 또는 인테리어 공사 등에 따른 권리자(사업주)의 게시물 중단 또는 삭제 요청이 있는 경우',
                '(13) 기타 관계법령에 위배된다고 판단되는 경우',
                '⑥ 회원의 게시물이 정보통신망법 및 저작권법 등 관련법에 위반되는 내용을 포함하는 경우, 권리자는 관련법이 정한 절차에 따라 해당 게시물의 게시중단 및 삭제 등을 요청할 수 있으며, 회사는 관련법에 따라 조치를 취하여야 합니다.',
                '⑦ 회사는 본조 제2항에 따른 권리자의 요청이 없는 경우라도 권리침해가 인정될 만한 사유가 있거나 기타 회사 정책 및 관련법에 위반되는 경우에는 관련법에 따라 해당 "게시물"에 대해 임시조치 등을 취할 수 있습니다.',
                '⑧ 본 조에 따른 세부절차는 정보통신망법 및 저작권법이 규정한 범위 내에서 회사가 정한 게시중단요청서비스에 따릅니다.'
              ]
            ),
            TermsConditionsData(
              title: '제16조 (권리의 귀속)',
              contents: [
                '① 서비스에 대한 저작권 및 지식재산권은 회사에 귀속됩니다. 단, 게시물 및 제휴계약에 따라 제공된 저작물 등은 제외합니다.'
                '③ 회원은 본 이용약관으로 인하여 서비스를 소유하거나 서비스에 관한 저작권을 보유하게 되는 것이 아니라, 회사로부터 서비스의 이용을 허락 받게 되는바, 서비스는 정보취득 또는 개인용도로만 제공되는 형태로 회원이 이용할 수 있습니다.',
                '② 회사가 제공하는 서비스의 디자인, 회사가 만든 텍스트, 스크립트(script), 그래픽, 회원 상호간 전송 기능 등 회사가 제공하는 서비스에 관련된 모든 상표, 서비스 마크, 로고 등에 관한 저작권 기타 지적재산권은 대한민국 및 외국의 법령에 기하여 회사가 보유하고 있거나 회사에게 소유권 또는 사용권이 있습니다.',
                '④ 회원은 명시적으로 허락된 내용을 제외하고는 서비스를 통해 얻어지는 회원 상태정보를 영리 목적으로 사용, 복사, 유통하는 것을 포함하여 회사가 만든 텍스트, 스크립트, 그래픽의 회원 상호간 전송기능 등을 복사하거나 유통할 수 없습니다.',
                '⑤ 회사는 서비스와 관련하여 회원에게 회사가 정한 이용조건에 따라 계정, ID, 콘텐츠 등을 이용할 수 있는 이용권만을 부여하며, 회원은 이를 양도, 판매, 담보제공 등의 처분행위를 할 수 없습니다.',
                '⑥ 회원은 서비스를 이용하는 과정에서 얻은 정보를 회사의 사전 승낙 없이 복제, 송신, 출판, 배포, 방송, 편집, 재가공 등 기타 방법에 의하여 영리 목적으로 이용하거나 제3자에게 이용하게 하여서는 안됩니다.',
              ]
            ),
            TermsConditionsData(
              title: '제17조 (상품제한 (주류 및 담배))',
              contents: [
                '① 회사가 제공하는 서비스의 일부 물품을 구매하는 국가의 해당 법률에 따른 구매가 제한된다. 이러한 제한사항에는 알코올(주류) / 담배 제품에 대한 최소 연령 조건 및 현재 시행중인 해당 시점의 관한 법적 요건에 근거하여 배달 및 인도하지 않을 권리를 가진다.',
                '② 알코올(주류) / 알코올 제품',
                '②-1 알코올(주류) 이하 주류제품을 구매하려면 국가(필리핀)의 법적 성인 나이가 되어야 한다. 회사 "Let\'s Bee", 주류 공급업체, 배달원은 다음과 같은 권리를 가진다',
                '②-2 주류를 전달하기 전에 고객에게 유호한 법적 연령 증명 (신분증 등)을 요청 할 수 있다.',
                '②-3 법정 연령 증명을 증명할 수 없는 경우 인도를 거부할 수 있다.',
                '②-4 어떠한 이유로든 본 회사는 배달을 거부할 수 있다.',
                '③ 담배 / 담배 제품',
                '③-1 국가(필리핀)의 법률이 허용되는 서비스 내에서 담배를 제공할 수 있다. 본 서비스를 제공함으로써, 본 회사는 어떠한 식으로든 담배의 구매나 사용을 광고 또는 홍보 등 장려하는 것을 의도하지 않는다.',
                '③-2 담배(담배제품) 이하 담배를 구매하려면 국가(필리핀)의 법적 성인 나이가 되어야 한다. 회사 "Let\'s Bee", 담배 공급업체, 배달원은 다음과 같은 권리를 가진다.',
                '③-3 담배를 전달하기 전에 고객에게 유호한 법적 연령 증명 (신분증 등)을 요청할 수 있다.',
                '③-4 법적 연령 증명을 할 수 없는 경우 배달 및 인도를 거부할 수 있다.',
                '③-5 어떠한 이유로든 본 회사는 배달을 거부할 수 있다.',
                '④ 본 회사는 서비스 상에서 이루어지는 모든 주류 및 담배에 대한 제공 / 배달은 국가(필리핀)의 법률에 의해 금지되거나 무효가 될 수 있다.',
              ]
            ),
            TermsConditionsData(
              title: '제18조 (포인트)',
              contents: [
                '① 포인트는 회사의 정책에 따라 회원에게 부여되며, 포인트별 적립기준, 사용방법, 사용기한 및 제한에 관한 사항은 별도로 공지하거나 통지합니다. 단, 포인트 사용기한에 대해 별도로 안내하지 않은 경우에는 1년으로 봅니다.',
                '② 포인트는 사용기한 동안 사용되지 않거나 회원 탈퇴 또는 자격상실 사유가 발생한 경우 자동으로 소멸됩니다. 회원 탈퇴 내지 자격상실로 포인트가 소멸된 경우 재가입하더라도 소멸된 포인트는 복구되지 않습니다.',
                '③ 회원은 회사가 별도로 명시한 경우를 제외하고는 포인트를 제3자에게 양도 할 수 없습니다. 만일 회원이 회사가 승인하지 않은 방법으로 포인트 획득/이용한 사실이 확인될 경우 회사는 포인트를 사용한 예약 신청을 취소하거나 회원 자격을 정지 또는 해지할 수 있습니다.',
                '④ 포인트 관련 회사의 정책은 회사의 영업정책에 따라 변동될 수 있습니다. 회원에게 불리한 변경인 경우에는 제3조의 규정에 따라 공지 또는 통지하며 서비스 계속 이용시 동의한 것으로 간주됩니다.',
              ]
            ),
            TermsConditionsData(
              title: '제19조 (쿠폰)',
              contents: [
                '① 쿠폰은 회사가 유상 또는 무상으로 발행하는 쿠폰으로 발행대상, 발행경로, 사용대상 등에 따라 구분될 수 있으며, 쿠폰의 세부구분, 할인금액(할인율), 사용방법, 사용기간 및 제한에 대한 사항은 쿠폰 또는 서비스 화면에 표시됩니다. 쿠폰의 종류 및 내용과 발급여부에 관하여는 회사의 영업정책에 따라 달라질 수 있습니다.',
                '② 쿠폰은 현금으로 출금될 수 없으며, 쿠폰에 표시된 사용기간이 만료되거나 이용계약이 종료되면 소멸합니다.',
                '③ 예약거래가 취소될 경우 예약에 이용된 쿠폰은 회사의 정책에 따라 환원 여부가 결정되며 자세한 사항은 유선 고지 내지 예약서비스 화면을 통해 안내됩니다.',
                '④ 회원은 회사가 별도로 명시한 경우를 제외하고는 쿠폰을 제3자에게 또는 다른 아이디로 양도 할 수 없으며 유상으로 거래하거나 현금으로 전환 할 수 없습니다. 만일 회원이 회사가 승인하지 않은 방법으로 부정한 방법으로 쿠폰을 획득/이용한 사실이 확인될 경우 회사는 회원의 쿠폰을 사용한 예약 신청을 취소하거나 회원 자격을 정지 또는 해지할 수 있습니다.',
                '⑤ 쿠폰 관련 회사의 정책은 회사의 영업정책에 따라 변동될 수 있습니다. 회원에게 불리한 변경인 경우에는 제3조의 규정에 따라 공지 또는 통지하며 서비스 계속 이용시 동의한 것으로 간주됩니다.',
              ]
            ),
          ],
        ),
        TermsConditions(
          header: '제4장 계약당사자의 의무',
          data: [
            TermsConditionsData(
              title: '제20조 (회사의 의무)',
              contents: [
                '① 회사는 관련법과 본 약관이 금지하거나 미풍양속에 반하는 행위를 하지 않으며, 계속적이고 안정적으로 서비스를 제공하기 위하여 최선을 다하여 노력합니다.',
                '② 회사는 회원이 안전하게 서비스를 이용할 수 있도록 개인정보보호를 위해 보안시스템을 갖추어야 하며 개인정보처리방침을 공시하고 준수하며, 회원의 개인정보를 본인의 승낙 없이 제3자에게 누설, 배포하지 않고, 이를 보호하기 위하여 노력합니다.',
                '③ 회사는 서비스이용과 관련하여 회원으로부터 제기된 의견이나 불만이 정당하다고 인정할 경우에는 그에 필요한 조치를 취하여야 합니다.',
                '④ 회사가 제공하는 서비스로 인하여 회원에게 손해가 발생한 경우 그러한 손해가 회사의 고의나 과실에 의해 발생한 경우에 한하여 회사에서 책임을 부담하며, 그 책임의 범위는 통상손해에 한합니다.',
              ]
            ),
            TermsConditionsData(
              title: '제21조 (회원의 의무)',
              contents: [
                '① 회원은 기타 관계 법령, 본 약관의 규정, 이용안내 및 서비스상에 공지한 주의사항, 회사가 통지하는 사항 등을 준수하여야 하며, 기타 회사의 업무에 방해되는 행위를 하여서는 아니 됩니다.',
                '② 회원은 서비스의 이용권한, 기타 서비스 이용계약상의 지위를 타인에게 양도, 증여할 수 없으며 이를 담보로 제공할 수 없습니다.',
                '③ 회원은 서비스 이용과 관련하여 다음 각 호의 행위를 하여서는 안됩니다.',
                '(1) 서비스 신청 또는 변경 시 허위내용을 등록하는 행위',
                '(2) 다른 회원의 아이디 및 비밀번호를 도용하여 부당하게 서비스를 이용하거나, 정보를 도용하는 행위',
                '(3) 타인의 계좌번호 및 신용카드번호 등 타인의 허락 없이 타인의 결제정보를 이용하여 회사의 유료서비스를 이용하는 행위',
                '(4) 정당한 사유 없이 당사의 영업을 방해하는 내용을 기재하는 행위',
                '(5) 회사가 게시한 정보를 변경하는 행위',
                '(6) 회사가 정한 정보 이외의 정보(컴퓨터 프로그램 등) 등을 송신 또는 게시하는 행위',
                '(7) 회사와 기타 제3자의 저작권 등 지적재산권을 침해하는 행위',
                '(8) 회사 및 기타 제3자의 명예를 손상시키거나 업무를 방해하는 행위',
                '(9) 외설 또는 폭력적인 메시지, 화상, 음성 기타 공공질서 미풍양속에 반하는 정보를 공개 또는 게시하는 행위',
                '(10) 회사의 동의 없이 영리를 목적으로 서비스를 사용하는 행위',
                '(11) 회사의 직원이나 서비스의 관리자를 가장하거나 사칭하여 또는 타인의 명의를 도용하여 글을 게시하거나 메일을 발송하는 행위',
                '(12) 서비스와 관련된 설비의 오동작이나 정보 등의 파괴 및 혼란을 유발시키는 컴퓨터 바이러스, 기타 다른 컴퓨터 코드, 파일, 프로그램 자료를 등록 또는 유포하는 행위',
                '(13) 회사가 제공하는 소프트웨어 등을 개작하거나 리버스 엔지니어링, 디컴파일, 디스어셈블 및 기타 일체의 가공행위를 통하여 서비스를 복제, 분해 또는 모방 기타 변형하는 행위',
                '(14) 자동 접속 프로그램 등을 사용하는 등 정상적인 용법과 다른 방법으로 서비스를 이용하여 회사의 서버에 부하를 일으켜 회사의 정상적인 서비스를 방해하는 행위',
                '(15) 다른 회원의 개인정보를 그 동의 없이 수집, 저장, 공개하는 행위',
                '(16) 기타 불법적이거나 회사에서 정한 규정을 위반하는 행위',
                '④ 회사는 회원이 제1항의 행위를 하는 경우 해당 게시물 등을 삭제 또는 임시 삭제할 수 있으며 서비스의 이용을 제한하거나 일방적으로 본 계약을 해지할 수 있습니다.',
                '⑤ 회원은 회원정보, 계정정보에 변경이 있는 경우 제7조에 따라 이를 즉시 변경하여야 하며, 더불어 비밀번호를 철저히 관리하여야 합니다. 회원의 귀책으로 말미암은 관리소홀, 부정사용 등에 의하여 발생하는 모든 결과에 대한 책임은 회원 본인이 부담하며, 회사는 이에 대한 어떠한 책임도 부담하지 않습니다.',
                '⑥ 민법상 미성년자인 회원이 유료 서비스를 이용 할 경우 미성년자인 회원은 결제 전 법정대리인의 동의를 얻어야 하며, 만 14세 미만 아동의 경우 본 서비스를 이용할 수 없습니다.',
                '⑦ 회원은 회사에서 공식적으로 인정한 경우를 제외하고는 서비스를 이용하여 상품을 판매하는 영업 활동을 할 수 없으며, 특히 해킹, 광고를 통한 수익, 음란사이트를 통한 상업행위, 상용소프트웨어 불법배포 등을 할 수 없습니다. 이를 위반하여 발생한 영업 활동의 결과 및 손실, 관계기관에 의한 구속 등 법적 조치 등에 관해서는 회사가 책임을 지지 않으며, 회원은 이와 같은 행위와 관련하여 회사에 대하여 손해배상 의무를 집니다.',
              ]
            ),
            TermsConditionsData(
              title: '제22조 (회원에 대한 통지)',
              contents: [
                '① 회사가 회원에 대한 통지를 하는 경우 본 약관에 별도 규정이 없는 한 회원이 기재한 E-mail로 할 수 있습니다.',
                '② 회사는 불특정 다수 회원에 대한 통지의 경우 서비스 게시판 등에 게시함으로써 개별 통지에 갈음할 수 있습니다.',
              ]
            ),
            TermsConditionsData(
              title: '제23조 (서비스 이용 해지)',
              contents: [
                '① 회원이 이용계약을 해지하고자 하는 때에는 사이트 또는 앱을 통해 안내된 해지방법에 따라 해지를 신청할 수 있습니다.',
                '② 회사는 등록 해지신청이 접수되면 회원이 원하는 시점에 해당 회원의 서비스 이용을 해지하여야 합니다.',
                '③ 회원이 계약을 해지할 경우, 관련법 및 개인정보처리방침에 따라 회사가 회원정보를 보유할 수 있는 경우를 제외하고 회원의 개인정보는 해지 즉시 삭제됩니다.',
              ]
            ),
            TermsConditionsData(
              title: '제24조 (서비스 이용 제한)',
              contents: [
                '① 회사는 이용제한정책에서 정하는 바에 따라 회원이 본 약관상 의무를 위반하거나 서비스의 정상적인 운영을 방해한 경우, 경고∙일시적 이용정지∙영구적 이용정지 등의 단계로 서비스 이용을 제한하거나 이용계약을 해지할 수 있습니다. 단, 회원에게 제6조 제1항의 사유가 있음이 확인되거나 회원이 서비스 이용과 관련하여 불법행위를 하거나 조장∙방조한 경우에는 즉시 영구적 이용정지 조치 또는 이용계약 해지를 할 수 있습니다.',
                '② 회사는 회원이 계속해서 1년 이상 서비스를 이용하지 않은 경우에는, 정보통신망법에 따라 필요한 조치를 취할 수 있고, 회원정보의 보호 및 운영의 효율성을 위해 이용을 제한할 수 있습니다.',
                '③ 본 조에 따라 서비스 이용을 제한하거나 계약을 해지하는 경우에는 회사는 제19조에 따라 회원에게 통지합니다.',
                '④ 회원은 본조에 따른 서비스 이용정지 기타 서비스 이용과 관련된 이용제한에 대해 회사가 정한 절차에 따라 이의신청을 할 수 있으며, 회사는 회원의 이의신청이 정당하다고 판단되는 경우 즉시 서비스 이용을 재개합니다.',
              ]
            ),
          ]
        ),
         TermsConditions(
          header: '제5장 기타',
          data: [
            TermsConditionsData(
              title: '제25조 (손해 배상)',
              contents: [
                '① 회원이 본 약관의 규정을 위반함으로 인하여 회사에 손해가 발생하게 되는 경우, 본 약관을 위반한 회원은 회사에 발생하는 모든 손해를 배상하여야 합니다.',
                '② 회원이 서비스를 이용하는 과정에서 행한 불법행위나 본 약관 위반행위로 인하여 회사가 당해 회원 이외의 제3자로부터 손해배상 청구 또는 소송을 비롯한 각종 이의제기를 받는 경우 당해 회원은 자신의 책임과 비용으로 회사를 면책 시켜야 하며, 회사가 면책되지 못한 경우 당해 회원은 그로 인하여 회사에 발생한 모든 손해를 배상하여야 합니다.',
              ]
            ),
            TermsConditionsData(
              title: '제26조 (면책사항)',
              contents: [
                '① 회사는 천재지변 또는 이에 준하는 불가항력으로 인하여 서비스를 제공할 수 없는 경우에는 서비스 제공에 관한 책임이 면책됩니다.',
                '② 회사는 회원의 귀책사유로 인한 서비스의 이용장애에 대하여 책임을 지지 않습니다.',
                '③ 회사는 회원이 서비스를 이용하여 기대하는 수익을 상실한 것에 대하여 책임을 지지 않으며 그 밖에 서비스를 통하여 얻은 자료로 인한 손해 등에 대하여도 책임을 지지 않습니다. 회사는 회원이 게재한 게시물(이용후기, 숙소평가 등 포함)의 정확성 등 내용에 대하여는 책임을 지지 않습니다.',
                '④ 회사는 회원 상호간 또는 회원과 제3자 상호간에 서비스를 매개로 발생한 분쟁에 대해서는 개입할 의무가 없으며 이로 인한 손해를 배상할 책임도 없습니다.',
                '⑤ 상품등은 판매자의 책임 하에 관리∙운영되고, 회사는 통신판매중개자로서 서비스 운영 상의 문제를 제외한 상품등의 하자∙부실 등으로 인한 책임은 판매자에게 귀속되며 회사는 어떠한 책임도 부담하지 않습니다.',
                '⑥ 회사는 제3자가 서비스 내 화면 또는 링크된 웹사이트를 통하여 광고한 제품 또는 서비스의 내용과 품질에 대하여 감시할 의무가 없으며 그로 인한 어떠한 책임도 지지 아니합니다.',
                '⑦ 회사는 회사 및 회사의 임직원 그리고 회사 대리인의 고의 또는 중대한 과실이 없는 한 다음 각 호의 사항으로부터 발생하는 손해에 대해 책임을 지지 아니합니다.',
                '(1) 회원정보 등의 허위 또는 부정확성에 기인하는 손해',
                '(2) 서비스에 대한 접속 및 서비스의 이용과정에서 발생하는 개인적인 손해',
                '(3) 서버에 대한 제3자의 모든 불법적인 접속 또는 서버의 불법적인 이용으로부터 발생하는 손해',
                '(4) 서버에 대한 전송 또는 서버로부터의 전송에 대한 제3자의 모든 불법적인 방해 또는 중단행위로부터 발생하는 손해',
                '(5) 제3자가 서비스를 이용하여 불법적으로 전송, 유포하거나 또는 전송, 유포되도록 한 모든 바이러스, 스파이웨어 및 기타 악성 프로그램으로 인한 손해',
                '(6) 전송된 데이터의 오류 및 생략, 누락, 파괴 등으로 발생되는 손해',
                '(7) 회원간의 회원 상태정보 등록 및 서비스 이용 과정에서 발생하는 명예훼손 기타 불법행위로 인한 각종 민∙형사상 책임',
              ]
            ),
             TermsConditionsData(
              title: '제27조 (분쟁 조정 및 관할법원)',
              contents: [
                '본 약관과 회사와 회원간에 발생한 분쟁 등에 관하여는 대한민국 법령이 적용되며, 회사의 주소지를 관할하는 법원을 관할법원으로 합니다.'
              ]
            )
          ]
        ),
        TermsConditions(
          header: '추가 이용약관',
          data: [
            TermsConditionsData(
              title: '제 1 조 (목적)',
              contents: [
                '본 약관은 레츠비(이하 "회사"라 합니다)가 운영, 제공하는 위치기반서비스(이하 “서비스”)를 이용함에 있어 회사와 고객 및 개인위치정보주체의 권리, 의무 및 책임사항에 따른 이용조건 및 절차 등 기본적인 사항을 규정함을 목적으로 합니다.'
              ]
            ),
            TermsConditionsData(
              title: '제 2 조 (이용약관의 효력 및 변경)',
              contents: [
                '1. 본 약관은 서비스를 신청한 고객 또는 개인위치정보주체가 본 약관에 동의하고 회사가 정한 소정의 절차에 따라 서비스의 이용자로 등록함으로써 효력이 발생합니다.',
                '2. 신청자가 모바일 단말기, PC 등에서 약관의 "동의하기" 버튼을 선택하였을 경우 본 약관의 내용을 모두 읽고 이를 충분히 이해하였으며, 그 적용에 동의한 것으로 봅니다.',
                '3. 회사는 위치정보의 보호 및 이용 등에 관한 법률, 콘텐츠산업 진흥법, 전자상거래 등에서의 소비자보호에 관한 법률, 소비자 기본법 약관의 규제에 관한 법률 등 관련 법령을 위배하지 않는 범위에서 본 약관을 변경할 수 있습니다.',
                '4. 회사가 약관을 변경할 경우에는 변경된 약관과 사유, 적용일자를 명시하여 그 적용일자 10일 전부터 적용일 이후 상당한 기간 동안 공지만을 하고, 개정 내용이 회원에게 불리한 경우에는 그 적용일자 30일 전부터 적용일 이후 상당한 기간 동안 각각 이를 서비스내 게시하거나 회원에게 전자적 형태(전자우편, SMS 등)로 약관 개정 사실을 발송하여 고지합니다.',
                '5. 회사가 전항에 따라 회원에게 통지하면서 공지일로부터 적용일 7일 후까지 거부의사를 표시하지 아니하면 개정 약관에 승인한 것으로 간주합니다. 회원이 개정 약관에 동의하지 않을 경우 회원은 이용계약을 해지할 수 있습니다.',
              ]
            ),
            TermsConditionsData(
              title: '제 3 조 (관계법령의 적용)',
              contents: [
                '본 약관은 신의성실의 원칙에 따라 공정하게 적용하며, 본 약관에 명시되지 아니한 사항에 대하여는 관계법령 또는 상관례에 따릅니다.'
              ]
            ),
            TermsConditionsData(
              title: '제 4 조 (서비스의 내용)',
              contents: [
                '회사는 위치정보사업자로부터 제공받은 위치정보수집대상의 위치정보 및 상태 정보를 이용하여 다음과 같은 내용으로 서비스한다.',
                '1. 위치정보수집대상의 실시간 위치확인',
                '2. 이용자의 위치에서 근접한 상가, 근린시설, 업소정보 제공',
              ]
            ),
            TermsConditionsData(
              title: '제 5 조 (서비스내용변경 통지)',
              contents: [
              '1. 회사가 서비스 내용을 변경하거나 종료하는 경우 회사는 등록된 전자우편 주소로 이메일을 통하여 서비스 내용의 변경 사항 또는 종료를 통지할 수 있습니다.',
              '2. 1항의 경우 불특정 다수인을 상대로 통지를 함에 있어서는 웹사이트 등 기타 회사의 공지사항을 통하여 회원에게 통지할 수 있습니다.',
              ]
            ),
            TermsConditionsData(
              title: '제 6 조 (서비스이용의 제한 및 중지)',
              contents: [
                '1. 회사는 이용자가 다음 각호에 해당하는 경우에는 회원의 서비스 이용을 제한하거나 중지시킬 수 있습니다.',
                '1) 회원이 회사 서비스의 운영을 고의 또는 중과실로 방해하는 경우',
                '2) 서비스용 설비 점검, 보수 또는 공사로 인하여 부득이한 경우',
                '3) 전기통신사업법에 규정된 기간통신사업자가 전기통신 서비스를 중지했을 경우',
                '4) 국가비상사태, 서비스 설비의 장애 또는 서비스 이용의 폭주 등으로 서비스 이용에 지장이 있는 때',
                '5) 기타 중대하 사유로 인하여 회사가 서비스 제공을 지속하는 것이 부적당하다고 인정하는 경우',
                '2. 회사는 전항의 규정에 의하여 서비스의 이용을 제한하거나 중지한 때에는 그 사유 및 제한기간 등을 회원에게 알려야 합니다.',
              ]
            ),
            TermsConditionsData(
              title: '제 7 조 (서비스 이용요금)',
              contents: [
                '고객은 본 서비스를 무료로 이용할 수 있습니다. 다만 위치정보를 확인하기 위하여 이동통신망에 접속할 때 발생하는 비용인 통신요금이 발생할 수 있습니다. 통신 요금은 고객의 데이터 사용량, 이동통신사 등에 따라 변동될 수 있습니다.'
              ]
            ),
            TermsConditionsData(
              title: '제 8 조 (개인위치정보의 이용 또는 제공)',
              contents: [
                '1. 회사는 개인위치정보를 이용하여 서비스를 제공하고자 하는 경우에는 미리 이용약관에 명시한 후 개인위치정보주체의 동의를 얻어야 합니다.',
                '2. 회원 및 법정대리인의 권리와 그 행사방법은 제소 당시의 이용자의 주소에 의하며, 주소가 없는 경우에는 거소를 관할하는 지방법원의 전속관할로 합니다. 다만, 제소 당시 이용자의 주소 또는 거소가 분명하지 않거나 외국 거주자의 경우에는 민사소송법상의 관할법원에 제기합니다.',
                '3. 회사는 타사업자 또는 이용 고객과의 요금정산 및 민원처리를 위해 위치정보 이용, 제공, 사실 확인자료를 자동 기록 및 보존하며, 해당 자료는 1년간 보관합니다.',
                '4. 회사는 개인위치정보를 회원이 지정하는 제 3자에게 제공하는 경우에는 개인위치정보를 수집한 당해 통신 단말장치로 매 회 회원에게 제공받는 자, 제공 일시 및 제공목적을 즉시 통보합니다. 단, 아래 각호의 1에 해당하는 경우에는 회원이 미리 특정하여 지정한 통신 단말장치 또는 전자우편주소로 통보합니다.',
                '1) 개인위치정보를 수집한 당해 통신단말장치가 문자, 음성 또는 영상의 수신기능을 갖추지 아니한 경우',
                '2) 개인위치정보주체가 온라인 게시 등의 방법으로 통보할 것을 미리 요청한 경우',
              ]
            ),
            TermsConditionsData(
              title: '제 9 조 (개인위치정보주체의 권리)',
              contents: [
                '1.회원은 회사에 대하여 언제든지 개인위치정보를 이용한 위치기반서비스 제공 및 개인위치정보의 제 3자 제공에 대한 동의의 전부 또는 일부를 철회할 수 있습니다. 이 경우 회사는 수집한 개인위치정보 및 위치정보 이용, 제공사실 확인자료를 파기합니다.',
                '2. 회원은 회사에 대하여 언제든지 개인위치정보의 이용 또는 제공의 일시적인 중지를 요구할 수 있습니다. 이 경우 회사는 요구를 거절하지 아니하며, 이를 위한 기술적 조치를 취합니다.',
                '3. 회사에 대해 아래 각 호의 자료에 대한 열람 또는 고지를 요구할 수 있고, 당해 자료에 오류가 있는 경우에는 그 정정을 요구할 수 있습니다. 이 경우 회사는 정당한 이유 없이 요구를 거절하지 아니합니다.',
                '1) 개인위치정보주체에 대한 위치정보 이용•제공사실 확인자료',
                '2) 개인위치정보주체의 개인위치정보가 위치정보의 보호 및 이용 등에 관한 법률 또는 다른 법률의 규정에 의해 제3자에게 제공된 이유 및 내용',
                '4. 회원은 제1항 내지 제3항의 권리행사를 위해 회사 소정의 절차를 통해 회사에 요구할 수 있습니다.',
              ]
            ),
            TermsConditionsData(
              title: '제 10 조 (법정대리인의 권리)',
              contents: [
                '1. 회사는 14세 미만 아동의 개인위치정보를 이용. 제공하고자 하는 경우(개인위치정보주체가 지정하는 제3자에게 제공하는 서비스를 하고자 하는 경우 포함)에는 14세 미만의 아동과 그 법정대리인의 동의를 받아야 합니다. 이 경우 법정대리인은 제9조에 의한 회원의 권리를 모두 가집니다.',
                '2. 회사는 14세 미만의 아동의 개인위치정보 또는 위치정보 이용, 제공사실 확인자료를 이용약관에 명시 또는 고지한 범위를 넘어 이용하거나 제3자에게 제공하고자 하는 경우에는 14세미만의 아동과 그 법정대리인의 동의를 받아야 합니다. 단, 아래의 경우는 제외합니다.',
                '1) 위치정보 및 위치기반서비스 제공에 따른 요금정산을 위하여 위치정보 이용, 제공사실 확인자료가 필요한 경우',
                '2) 통계작성, 학술연구 또는 시장조사를 위하여 특정 개인을 알아볼 수 없는 형태로 가공하여 제공하는 경우',
              ]
            ),
            TermsConditionsData(
              title: '제 11 조 (8세 이하의 아동 등의 보호의무자의 권리)',
              contents: [
                '1. 회사는 아래의 경우에 해당하는 자(이하 “8세 이하의 아동”등이라 한다)의 보호의무자가 8세 이하의 아동 등의 생명 또는 신체보호를 위하여 개인위치정보의 이용 또는 제공에 동의하는 경우에는 본인의 동의가 있는 것으로 봅니다.',
                '1) 8세 이하의 아동',
                '2) 금치산자',
                '3) 장애인복지법제2조제2항제2호의 규정에 의한 정신적 장애를 가진 자로서 장애인고용촉진및직업재활법 제2조제2호의 규정에 의한 중증장애인에 해당하는 자(장애인복지법 제29조의 규정에 의하여 장애인등록을 한 자에 한한다)',
                '2. 8세 이하의 아동 등의 생명 또는 신체의 보호를 위하여 개인위치정보의 이용 또는 제공에 동의를 하고자 하는 보호의무자는 서면동의서에 보호의무자임을 증명하는 서면을 첨부하여 회사에 제출하여야 합니다.',
                '3. 보호의무자는 8세 이하의 아동 등의 개인위치정보 이용 또는 제공에 동의하는 경우 개인위치 정보주체 권리의 전부를 행사할 수 있습니다.',
              ]
            ),
            TermsConditionsData(
              title: '제 12 조 (위치정보관리책임자의 지정)',
              contents: [
                '1. 회사는 위치정보를 적절히 관리, 보호하고 개인위치정보주체의 불만을 원활히 처리할 수 있도록 실질적인 책임을 질 수 있는 지위에 있는 자를 위치정보관리책임자로 지정해 운영합니다.',
                '2. 위치정보관리책임자는 위치기반서비스를 제공하는 부서의 부서장으로서 구체적인 사항은 본 약관의 부칙에 따릅니다.',
              ]
            ),
            TermsConditionsData(
              title: '제 13 조 (손해배상의 범위)',
                contents: [
                '1. 회사가 위치정보의보호및이용등에관한법률 15조 내지 26조의 규정의 위반한 행위로 회원에게 손해가 발생한경우회원은 회사에 대해 손해배상을 청구할 수 있습니다. 이 경우 회사는 고의 또는 과실이 없음을 입증하지 아니하면 책임을 면할 수 없습니다.',
                '2. 회원이 본 약관의 규정을 위반하여 회사에 손해가 발생한 경우 회사는 회원에 대해 손해배상을 청구할 수 있습니다. 이 경우 회원은 고의 또는 과실이 없음을 입증하지 아니하면 책임을 면할 수 없습니다.',
              ]
            ),
            TermsConditionsData(
              title: '제 14 조 (면책)',
              contents: [
                '1. 회사는 다음 각 호의 경우로 서비스를 제공할 수 없는 경우 이로 인하여 회원에게 발생한 손해에 대해서는 책임을 부담하지 않습니다.',
                '1) 천재지변 또는 이에 준하는 불가항력의 상태가 있는 경우',
                '2) 서비스 제공을 위하여 회사와 서비스 제휴계약을 체결한 제 3자의 고의적인 서비스 방해가 있는 경우',
                '3) 회원의 귀책사유로 서비스 이용에 장애가 있는 경우',
                '4) 제1호 내지 제3호를 제외한 기타 회사의 고의, 과실이 없는 사유로 인한 경우',
                '2. 회사는 서비스 및 서비스에 게재된 정보, 자료, 사실의 신뢰도, 정확성 등에 대해서는 보증을 하지 않으며 이로 인해 발생한 회원의 손해에 대하여는 책임을 부담하지 아니합니다.',
              ]
            ),
            TermsConditionsData(
              title: '제 15 조 (규정의 준용)',
              contents: [
                '1. 본 약관은 대한민국법령에 의하여 규정되고 이행됩니다.',
                '2. 본 약관에 규정되지 않은 사항에 대해서는 관계법령 및 상관습에 의합니다.',
              ]
            ),
            TermsConditionsData(
              title: '제 16 조 (분쟁의 조정 및 기타)',
              contents: [
                '1. 회사는 위치정보와 관련된 분쟁에 대해 당사자간 협의가 이루어지지 아니하거나 협의를 할 수 없는 경우에는 위치정보의 보호 및 이용 등에 관한 법률 제28조 규정에 의한 방송통신위원회에 재정을 신청할 수 있습니다.',
                '2. 위치정보와 관련된 분쟁에 대해 당사자간 협의가 이루어지지 아니하거나 협의를 할 수 없는 경우에는 개인정보보호법 제43조 규정에 의한 개인정보분쟁조정위원회에 조정을 신청할 수 있습니다.',
              ]
            ),
            TermsConditionsData(
              title: '제 17 조 (회사의 연락처) 회사의 상호 및 주소 등은 다음과 같습니다.',
              contents: [
                '1. 상호: 레츠비',
                '2. 주소: Block 5 Lot4, Yukon Street, Riverside Subdivision ,Anunas,Angeles City Pampanga 2009',
                '3. 대표전화: 09451076000',
                '4. 이메일 주소: letsbeedelivery2019@gmail.com',
              ]
            ),
            TermsConditionsData(
              title: '제 1 조 (시행일) 본 약관은 2019년 10월 1일부터 시행합니다.',
              contents: []
            ),
            TermsConditionsData(
              title: '제 2 조 개인 위치정보 책임자는 2019년 10월 1일을 기준으로 다음과 같이 지정합니다.',
              contents: [
                '개인위치정보 책임자',
                '성명: 유현상',
                '연락처: 09451076000'
              ]
            )
          ]
        ),
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
              Obx(() => controller.language.call() == 'EN' ? Column(
                  children: tcEnglish.map((list) => _buildExpandable(list)).toList(),
                ) : Column(
                  children: tcKorean.map((list) => _buildExpandable(list)).toList(),
                )
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
        tilePadding: EdgeInsets.only(top: 10),
        children: list.data.isNotEmpty ? list.data?.map((data) => _buildExpandableList(data))?.toList() : [],
      )
    );
  }

  Widget _buildExpandableList(TermsConditionsData data) {
    return data.contents.isEmpty ? Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
      child: Text(
          '- ${data.title}', 
          style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w500), 
          textAlign: TextAlign.start
        ),
    ) : ExpansionTile(
      title: Text(
        '- ${data.title}', 
        style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w500), 
        textAlign: TextAlign.start
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
        style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w300), 
        textAlign: TextAlign.start
      ),
    );
  }

  Widget _headerTitle() {
    return Obx(() => Text(
      controller.language.call() == 'EN' ? 'The terms and conditions of this Agreement include the consent to receive commercial information for profit.' 
      : '본 약관 내에는 영리목적 광고성 정보 수신동의에 관한 사항이 포함되어 있습니다.', 
      style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w500), 
      textAlign: TextAlign.justify
    ));
  }
}