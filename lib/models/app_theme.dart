import 'dart:collection';
import 'dart:ui';

class AppTheme{
  int themeID;
  String themeName;
  Color brandPrimaryColor;
  Color brandSecondaryColor;
  Color brandAccentColor;
  Color bgPrimaryColor;
  Color bgSecondaryColor;
  Color bgAccentColor;
  Color textPrimaryColor;
  Color textSecondaryColor;
  Color textAccentColor;
  Color decorationPrimaryColor;
  Color decorationSecondaryColor;
  Color errorColor;
  Color amTechniqueSectionColor;
  Color amTechniqueTextColor;
  Color pmTechniqueSectionColor;
  Color pmTechniqueTextColor;
  Color emergencyTechniqueSectionColor;
  Color emergencyTechniqueTextColor;
  Color challengeTechniqueSectionColor;
  Color challengeTechniqueTextColor;
  Color customTechniqueSectionColor;
  Color customTechniqueTextColor;
  Color bulletListIconColor;
  Color disabledCardBgColor;
  Color disabledCardBgAccentColor;
  Color disabledCardTextColor;
  Color disabledCardBorderColor;
  Color cardBorderColor;
  Color cardTitleColor;
  Color cardSubtitleColor;
  Color cardBgColor;
  Color cardActionColor;
  Color bottomNavBgColor;
  AppTheme({this.themeID, this.themeName, this.amTechniqueSectionColor, this.bgPrimaryColor,
  this.bgSecondaryColor, this.brandPrimaryColor, this.brandSecondaryColor,
  this.challengeTechniqueSectionColor, this.customTechniqueSectionColor,
  this.decorationPrimaryColor, this.decorationSecondaryColor,
  this.emergencyTechniqueSectionColor, this.errorColor, this.pmTechniqueSectionColor,
  this.textPrimaryColor, this.textSecondaryColor,
  this.amTechniqueTextColor, this.challengeTechniqueTextColor, this.customTechniqueTextColor,
  this.emergencyTechniqueTextColor, this.pmTechniqueTextColor, this.bgAccentColor,
  this.brandAccentColor, this.textAccentColor, this.bulletListIconColor,
  this.cardBgColor, this.cardBorderColor, this.cardSubtitleColor, this.cardTitleColor,
  this.disabledCardBgAccentColor, this.disabledCardBgColor, this.disabledCardBorderColor,
  this.disabledCardTextColor, this.cardActionColor, this.bottomNavBgColor});
  factory AppTheme.fromSnapshot(LinkedHashMap json){
    return AppTheme(
      themeID: json['themeID'],
      themeName: json['themeName'],
      brandPrimaryColor: toColor(json['brandPrimaryColor']),
      brandSecondaryColor: toColor(json['brandSecondaryColor']),
      brandAccentColor: toColor(json['brandAccentColor']),
      bgPrimaryColor: toColor(json['bgPrimaryColor']),
      bgSecondaryColor: toColor(json['bgSecondaryColor']),
      bgAccentColor: toColor(json['bgAccentColor']),
      textPrimaryColor: toColor(json['textPrimaryColor']),
      textSecondaryColor: toColor(json['textSecondaryColor']),
      textAccentColor: toColor(json['textAccentColor']),
      decorationPrimaryColor: toColor(json['decorationPrimaryColor']),
      decorationSecondaryColor: toColor(json['decorationSecondaryColor']),
      errorColor: toColor(json['errorColor']),
      amTechniqueSectionColor: toColor(json['amTechniqueSectionColor']),
      amTechniqueTextColor: toColor(json['amTechniqueTextColor']),
      pmTechniqueSectionColor: toColor(json['pmTechniqueSectionColor']),
      pmTechniqueTextColor: toColor(json['pmTechniqueTextColor']),
      emergencyTechniqueSectionColor: toColor(json['emergencyTechniqueSectionColor']),
      emergencyTechniqueTextColor: toColor(json['emergencyTechniqueTextColor']),
      challengeTechniqueSectionColor: toColor(json['challengeTechniqueSectionColor']),
      challengeTechniqueTextColor: toColor(json['challengeTechniqueTextColor']),
      customTechniqueSectionColor: toColor(json['customTechniqueSectionColor']),
      customTechniqueTextColor: toColor(json['customTechniqueTextColor']),
      bulletListIconColor: toColor(json['bulletListIconColor']),
      disabledCardBgAccentColor: toColor(json['disabledCardBgAccentColor']),
      disabledCardBgColor: toColor(json['disabledCardBgColor']),
      disabledCardBorderColor: toColor(json['disabledCardBorderColor']),
      disabledCardTextColor: toColor(json['disabledCardTextColor']),
      cardBgColor: toColor(json['cardBgColor']),
      cardBorderColor: toColor(json['cardBorderColor']),
      cardSubtitleColor: toColor(json['cardSubtitleColor']),
      cardTitleColor: toColor(json['cardTitleColor']),
      cardActionColor: toColor(json['cardActionColor']),
      bottomNavBgColor: toColor(json['bottomNavBgColor'])
    );
  }
  static Color toColor(String color){
    String formattedColor = color.substring(2);
    return Color(int.parse(formattedColor, radix: 16));
  }
}