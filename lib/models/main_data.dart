import 'package:breathing_connection/models/app_theme.dart';
import 'package:breathing_connection/models/inhale_exhale_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'nav_link.dart';

class MainData{
  List<NavLink> pages;
  List<String> images;
  List<String> music;
  List<String> sounds;
  List<String> emailSubscriptionTypes;
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
  List<String> disclaimerNotes;

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
    this.proSubSuccessHead, this.music, this.sounds, this.emailSubscriptionTypes,
    this.disclaimerNotes});

  factory MainData.fromSnapShot(MainData tempMainData, DocumentSnapshot snapshot, String op){
    if(op == 'constants'){
      tempMainData.popupWaitTime = int.parse(snapshot.data['popupWaitTime']) ?? 30;
      tempMainData.appBarHeight = double.parse(snapshot.data['appBarHeight']) ?? 96.0;
      tempMainData.homePageTitleText = snapshot.data['homePageTitleText'] ?? '';
      tempMainData.amSessionHeaderText = snapshot.data['amSectionHeaderText'] ?? '';
      tempMainData.pmSessionHeaderText = snapshot.data['pmSectionHeaderText'] ?? '';
      tempMainData.emergencySessionHeaderText = snapshot.data['emergencySectionHeaderText'] ?? '';
      tempMainData.challengeSessionHeaderText = snapshot.data['challengeSectionHeaderText'] ?? '';
      tempMainData.customSessionHeaderText = snapshot.data['customSectionHeaderText'] ?? '';
      tempMainData.emailPageSubmitBtnText = snapshot.data['emailPageSubmitBtnText'] ?? '';
      tempMainData.proPageHeaderText = snapshot.data['proPageHeaderText'] ?? '';
      tempMainData.proPageSubmitBtnText = snapshot.data['proPageSubmitBtnText'] ?? '';
      tempMainData.emailPopupHeaderText = snapshot.data['emailPopupHeaderText'] ?? '';
      tempMainData.emailPopupBodyText = snapshot.data['emailPopupBodyText'] ?? '';
      tempMainData.emailPopupApproveBtnText = snapshot.data['emailPopupApproveBtnText'] ?? '';
      tempMainData.emailPopupDenyBtnText = snapshot.data['emailPopupDenyBtnText'] ?? '';
      tempMainData.proPopupHeaderText = snapshot.data['proPopupHeaderText'] ?? '';
      tempMainData.proPopupBodyText = snapshot.data['proPopupBodyText'] ?? '';
      tempMainData.proPopupApproveBtnText = snapshot.data['proPopupApproveBtnText'] ?? '';
      tempMainData.proPopupDenyBtnText = snapshot.data['proPopupDenyBtnText'] ?? '';
      tempMainData.dailyReminderFooter = snapshot.data['dailyReminderFooter'] ?? '';
      tempMainData.dailyReminderHeader = snapshot.data['dailyReminderHeader'] ?? '';
      tempMainData.challengeReminderFooter = snapshot.data['challengeReminderFooter'] ?? '';
      tempMainData.challengeReminderHeader = snapshot.data['challengeReminderHeader'] ?? '';
      tempMainData.customTechniqueSuccessHead = snapshot.data['customTechniqueSuccessHead'] ?? '';
      tempMainData.customTechniqueSuccessBody = snapshot.data['customTechniqueSuccessBody'] ?? '';
      tempMainData.proSubSuccessHead = snapshot.data['proSubSuccessHead'] ?? '';
      tempMainData.proSubSuccessBody = snapshot.data['proSubSuccessBody'] ?? '';
      tempMainData.emailSubSuccessHead = snapshot.data['emailSubSuccessHead'] ?? '';
      tempMainData.emailSubSuccessBody = snapshot.data['emailSubSuccessBody'] ?? '';
      Iterable disclaimerNotes = snapshot['disclaimerNotes'] ?? [];
      tempMainData.disclaimerNotes = disclaimerNotes
          .map((disclaimerNote) => disclaimerNote.toString()).toList();
    }
    else if(op == 'meta'){
      Iterable pages = snapshot['pages'] ?? [];
      tempMainData.pages = pages
          .map((page){
        return NavLink.fromSnapshot(page);
      }).toList();
      Iterable inhaleExhaleTypes = snapshot['inhaleExhaleTypes'] ?? [];
      tempMainData.inhaleExhaleTypes = inhaleExhaleTypes
          .map((inhaleExhaleType){
        return InhaleExhaleType.fromSnapshot(inhaleExhaleType);
      }).toList();
      Iterable emailSubscriptionTypes = snapshot['emailSubscriptionTypes'] ?? [];
      tempMainData.emailSubscriptionTypes = emailSubscriptionTypes
          .map((emailSubscriptionType) => emailSubscriptionType.toString()).toList();
    }
    else if(op == 'assets'){
      Iterable images = snapshot['images'] ?? [];
      tempMainData.images = images
          .map((imageFile) => imageFile.toString()).toList();
      Iterable music = snapshot.data['music'] ?? [];
      tempMainData.music = music
          .map((musicFile) => musicFile.toString()).toList();
      Iterable sounds = snapshot.data['sounds'] ?? [];
      tempMainData.sounds = sounds
          .map((soundFile) => soundFile.toString()).toList();
    }
    else if(op == 'colors'){
      Iterable themes = snapshot.data['themes'] ?? [];
      tempMainData.themes = themes
          .map((theme){
        return AppTheme.fromSnapshot(theme);
      }).toList();
    }

    return tempMainData;
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
    this.emailSubscriptionTypes = mainData.emailSubscriptionTypes;
    this.disclaimerNotes = mainData.disclaimerNotes;
  }
}