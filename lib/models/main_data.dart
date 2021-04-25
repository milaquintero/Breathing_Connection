import 'package:breathing_connection/main.dart';
import 'package:breathing_connection/models/app_theme.dart';
import 'package:breathing_connection/models/inhale_exhale_type.dart';

import 'nav_link.dart';

class MainData{
  List<NavLink> pages;
  List<String> images;
  List<String> music;
  List<String> sounds;
  List<InhaleExhaleType> inhaleExhaleTypes;
  int popupWaitTime;
  List<AppTheme> themes;
  double appBarHeight;
  String homePageTitleText;
  String emailPopupHeaderText;
  String emailPopupBodyText;
  String emailPopupApproveBtnText;
  String emailPopupDenyBtnText;
  String emailPageSubmitBtnText;
  String proPopupHeaderText;
  String proPopupBodyText;
  String proPopupApproveBtnText;
  String proPopupDenyBtnText;
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
  String customTechniqueSuccessHead;
  String customTechniqueSuccessBody;
  String proSubSuccessHead;
  String proSubSuccessBody;
  String emailSubSuccessHead;
  String emailSubSuccessBody;
  MainData({this.pages, this.images, this.inhaleExhaleTypes,
    this.popupWaitTime, this.themes, this.appBarHeight, this.emailPageSubmitBtnText,
    this.emailPopupApproveBtnText, this.emailPopupBodyText, this.emailPopupDenyBtnText,
    this.emailPopupHeaderText, this.homePageTitleText,
    this.proPageHeaderText, this.proPageSubmitBtnText, this.proPopupApproveBtnText,
    this.proPopupBodyText, this.proPopupDenyBtnText, this.proPopupHeaderText,
    this.amSessionHeaderText, this.challengeSessionHeaderText,
    this.customSessionHeaderText, this.emergencySessionHeaderText, this.pmSessionHeaderText,
    this.challengeReminderFooter, this.challengeReminderHeader, this.dailyReminderFooter,
    this.dailyReminderHeader, this.customTechniqueSuccessBody, this.customTechniqueSuccessHead,
    this.emailSubSuccessBody, this.emailSubSuccessHead, this.proSubSuccessBody,
    this.proSubSuccessHead, this.music, this.sounds});
  factory MainData.fromJson(Map<String, dynamic> json){
    Iterable jsonPages = json['pages'] ?? [];
    Iterable jsonImages = json['images'] ?? [];
    Iterable jsonMusic = json['music'] ?? [];
    Iterable jsonSounds = json['sounds'] ?? [];
    Iterable jsonInhaleExhaleTypes = json['inhaleExhaleTypes'] ?? [];
    Iterable jsonThemes = json['themes'] ?? [];
    return MainData(
      pages: jsonPages.map((jsonPage) => NavLink.fromJson(jsonPage)).toList(),
      images: jsonImages.map((jsonImageFile) => jsonImageFile.toString()).toList(),
      music: jsonMusic.map((jsonMusicFile) => jsonMusicFile.toString()).toList(),
      sounds: jsonSounds.map((jsonSoundFile) => jsonSoundFile.toString()).toList(),
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
      challengeReminderHeader: json['challengeReminderHeader'],
      customTechniqueSuccessHead: json['customTechniqueSuccessHead'],
      customTechniqueSuccessBody: json['customTechniqueSuccessBody'],
      proSubSuccessHead: json['proSubSuccessHead'],
      proSubSuccessBody: json['proSubSuccessBody'],
      emailSubSuccessHead: json['emailSubSuccessHead'],
      emailSubSuccessBody: json['emailSubSuccessBody']
    );
  }
  setMainData(MainData mainData){
    this.pages = mainData.pages;
    this.images = mainData.images;
    this.music = mainData.music;
    this.sounds = mainData.sounds;
    this.inhaleExhaleTypes = mainData.inhaleExhaleTypes;
    this.popupWaitTime = mainData.popupWaitTime;
    this.themes = mainData.themes;
    this.appBarHeight = mainData.appBarHeight;
    this.homePageTitleText = mainData.homePageTitleText;
    this.amSessionHeaderText = mainData.amSessionHeaderText;
    this.pmSessionHeaderText = mainData.pmSessionHeaderText;
    this.emergencySessionHeaderText = mainData.emergencySessionHeaderText;
    this.challengeSessionHeaderText = mainData.challengeSessionHeaderText;
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
    this.customTechniqueSuccessHead = mainData.customTechniqueSuccessHead;
    this.customTechniqueSuccessBody = mainData.customTechniqueSuccessBody;
    this.proSubSuccessHead = mainData.proSubSuccessHead;
    this.proSubSuccessBody = mainData.proSubSuccessBody;
    this.emailSubSuccessHead = mainData.emailSubSuccessHead;
    this.emailSubSuccessBody = mainData.emailSubSuccessBody;
  }
}