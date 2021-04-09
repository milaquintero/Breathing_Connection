import 'package:breathing_connection/main.dart';
import 'package:breathing_connection/models/app_theme.dart';
import 'package:breathing_connection/models/inhale_exhale_type.dart';

import 'nav_link.dart';

class MainData{
  List<NavLink> pages;
  List<String> images;
  List<InhaleExhaleType> inhaleExhaleTypes;
  int popupWaitTime;
  List<AppTheme> themes;
  double appBarHeight;
  String homePageTitleText;
  String emailPopupHeaderText;
  String emailPopupBodyText;
  String emailPopupApproveBtnText;
  String emailPopupDenyBtnText;
  String emailSubSuccessText;
  String emailPageSubmitBtnText;
  String proPopupHeaderText;
  String proPopupBodyText;
  String proPopupApproveBtnText;
  String proPopupDenyBtnText;
  String proSubSuccessText;
  String proPageSubmitBtnText;
  String proPageHeaderText;
  String amSessionHeaderText;
  String pmSessionHeaderText;
  String emergencySessionHeaderText;
  String challengeSessionHeaderText;
  String customSessionHeaderText;
  String dailyReminderHeader;
  String dailyReminderFooter;
  String challengeReminderHeader;
  String challengeReminderFooter;
  MainData({this.pages, this.images, this.inhaleExhaleTypes,
    this.popupWaitTime, this.themes, this.appBarHeight, this.emailPageSubmitBtnText,
    this.emailPopupApproveBtnText, this.emailPopupBodyText, this.emailPopupDenyBtnText,
    this.emailPopupHeaderText, this.emailSubSuccessText, this.homePageTitleText,
    this.proPageHeaderText, this.proPageSubmitBtnText, this.proPopupApproveBtnText,
    this.proPopupBodyText, this.proPopupDenyBtnText, this.proPopupHeaderText,
    this.proSubSuccessText, this.amSessionHeaderText, this.challengeSessionHeaderText,
    this.customSessionHeaderText, this.emergencySessionHeaderText, this.pmSessionHeaderText,
    this.challengeReminderFooter, this.challengeReminderHeader, this.dailyReminderFooter,
    this.dailyReminderHeader});
  factory MainData.fromJson(Map<String, dynamic> json){
    Iterable jsonPages = json['pages'] ?? [];
    Iterable jsonImages = json['images'] ?? [];
    Iterable jsonInhaleExhaleTypes = json['inhaleExhaleTypes'] ?? [];
    Iterable jsonThemes = json['themes'] ?? [];
    return MainData(
      pages: jsonPages.map((jsonPage) => NavLink.fromJson(jsonPage)).toList(),
      images: jsonImages.map((jsonImage) => jsonImage.toString()).toList(),
      inhaleExhaleTypes: jsonInhaleExhaleTypes.map((jsonInhaleExhaleType) => InhaleExhaleType.fromJson(jsonInhaleExhaleType)).toList(),
      popupWaitTime: int.parse(json['popupWaitTime']),
      themes: jsonThemes.map((jsonTheme) => AppTheme.fromJson(jsonTheme)).toList(),
      appBarHeight: double.parse(json['appBarHeight']),
      homePageTitleText: json['homePageTitleText'],
      amSessionHeaderText: json['amSectionHeaderText'],
      pmSessionHeaderText: json['pmSectionHeaderText'],
      emergencySessionHeaderText: json['emergencySectionHeaderText'],
      challengeSessionHeaderText: json['challengeSectionHeaderText'],
      customSessionHeaderText: json['customSectionHeaderText'],
      emailPageSubmitBtnText: json['emailPageSubmitBtnText'],
      proPageHeaderText: json['proPageHeaderText'],
      proPageSubmitBtnText: json['proPageSubmitBtnText'],
      emailPopupHeaderText: json['emailPopupHeaderText'],
      emailPopupBodyText: json['emailPopupBodyText'],
      emailPopupApproveBtnText: json['emailPopupApproveBtnText'],
      emailPopupDenyBtnText: json['emailPopupDenyBtnText'],
      proPopupHeaderText: json['proPopupHeaderText'],
      proPopupBodyText: json['proPopupBodyText'],
      proPopupApproveBtnText: json['proPopupApproveBtnText'],
      proPopupDenyBtnText: json['proPopupDenyBtnText'],
      dailyReminderFooter: json['dailyReminderFooter'],
      dailyReminderHeader: json['dailyReminderHeader'],
      challengeReminderFooter: json['challengeReminderFooter'],
      challengeReminderHeader: json['challengeReminderHeader']

      /*proSubSuccessText: json['proSubSuccessText'],
      emailSubSuccessText: json['emailSubSuccessText'],*/
    );
  }
  setMainData(MainData mainData){
    this.pages = mainData.pages;
    this.images = mainData.images;
    this.inhaleExhaleTypes = mainData.inhaleExhaleTypes;
    this.popupWaitTime = mainData.popupWaitTime;
    this.themes = mainData.themes;
    this.appBarHeight = mainData.appBarHeight;
    this.homePageTitleText = mainData.homePageTitleText;
    this.amSessionHeaderText = mainData.amSessionHeaderText;
    this.pmSessionHeaderText = mainData.pmSessionHeaderText;
    this.emergencySessionHeaderText = mainData.emergencySessionHeaderText;
    this.challengeSessionHeaderText = mainData.emergencySessionHeaderText;
    this.customSessionHeaderText = mainData.customSessionHeaderText;
    this.emailPageSubmitBtnText = mainData.emailPageSubmitBtnText;
    this.proPageSubmitBtnText = mainData.proPageSubmitBtnText;
    this.proPageHeaderText = mainData.proPageHeaderText;
    this.emailPopupHeaderText = mainData.emailPopupHeaderText;
    this.emailPopupBodyText = mainData.emailPopupBodyText;
    this.emailPopupApproveBtnText = mainData.emailPopupApproveBtnText;
    this.emailPopupDenyBtnText = mainData.emailPopupDenyBtnText;
    this.proPopupHeaderText = mainData.proPopupHeaderText;
    this.proPopupBodyText = mainData.proPopupBodyText;
    this.proPopupApproveBtnText = mainData.proPopupApproveBtnText;
    this.proPopupDenyBtnText = mainData.proPopupDenyBtnText;
    this.dailyReminderHeader = mainData.dailyReminderHeader;
    this.dailyReminderFooter = mainData.dailyReminderFooter;
    this.challengeReminderHeader = mainData.challengeReminderHeader;
    this.challengeReminderFooter = mainData.challengeReminderFooter;

/*    this.proSubSuccessText = mainData.proSubSuccessText;
    this.emailSubSuccessText = mainData.emailSubSuccessText;*/
  }
}