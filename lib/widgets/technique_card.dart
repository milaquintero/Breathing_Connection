import 'package:breathing_connection/models/technique.dart';
import 'package:flutter/material.dart';

class TechniqueCard extends StatefulWidget {
  final bool userHasFullAccess;
  final Technique technique;
  final Function(String, Technique) changePersonalTechnique;
  final Function(Technique) viewTechniqueDetails;
  final Function(Technique) editCustomTechnique;
  final Color disabledCardBgColor;
  final Color disabledCardBgAccentColor;
  final Color disabledCardTextColor;
  final Color disabledCardBorderColor;
  final Color cardBorderColor;
  final Color cardTitleColor;
  final Color cardSubtitleColor;
  final Color cardBgColor;
  final Color cardActionColor;
  final Function(Technique) deleteCustomTechnique;
  final Function(Technique) beginTechniqueInEnvironment;
  TechniqueCard({this.technique, this.changePersonalTechnique, this.viewTechniqueDetails,
  this.disabledCardTextColor, this.disabledCardBorderColor, this.disabledCardBgColor,
  this.disabledCardBgAccentColor, this.cardTitleColor, this.cardSubtitleColor,
  this.cardBorderColor, this.cardBgColor, this.cardActionColor, this.userHasFullAccess,
  this.deleteCustomTechnique, this.editCustomTechnique, this.beginTechniqueInEnvironment});

  @override
  _TechniqueCardState createState() => _TechniqueCardState();
}

class _TechniqueCardState extends State<TechniqueCard> {
  bool shouldBeEnabled;
  Color listTileBg;
  Color titleColor;
  Color subtitleColor;
  Color borderColor;
  //dynamic display for popup menu options based on category dependencies for technique
  List<PopupMenuItem<String>> techniqueMenuOptions = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    shouldBeEnabled = widget.userHasFullAccess || (!widget.userHasFullAccess && !widget.technique.isPaidVersionOnly);
    listTileBg = shouldBeEnabled ? widget.cardBgColor : widget.disabledCardBgColor;
    titleColor = shouldBeEnabled ? widget.cardTitleColor : widget.disabledCardTextColor;
    subtitleColor = shouldBeEnabled ? widget.cardSubtitleColor : widget.disabledCardTextColor;
    borderColor = shouldBeEnabled ? widget.cardBorderColor : widget.disabledCardBorderColor;
    if(widget.technique.categoryDependencies.contains('AM')){
      techniqueMenuOptions.add(PopupMenuItem<String>(
          child: Text('Set as Morning Technique'), value: 'Morning'));
    }
    if(widget.technique.categoryDependencies.contains('PM')){
      techniqueMenuOptions.add(PopupMenuItem<String>(
          child: Text('Set as Evening Technique'), value: 'Evening'));
    }
    if(widget.technique.categoryDependencies.contains('Emergency')){
      techniqueMenuOptions.add(PopupMenuItem<String>(
          child: Text('Set as Emergency Technique'), value: 'Emergency'));
    }
    if(widget.technique.categoryDependencies.contains('Challenge')){
      techniqueMenuOptions.add(PopupMenuItem<String>(
          child: Text('Set as Challenge Technique'), value: 'Challenge'));
    }
    //add option to permanently delete and edit technique if technique has associated user id (custom technique)
    if(widget.technique.associatedUserID != null){
      techniqueMenuOptions.add(PopupMenuItem(
        child: Text('Edit Technique'), value: 'Edit',));
      techniqueMenuOptions.add(PopupMenuItem(
          child: Text('Permanently delete'), value: 'Delete',));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(
              color: borderColor,
              width: 1.5
            )
        ),
        gradient: RadialGradient(
          colors: [Colors.blueGrey, Color.lerp(listTileBg, Colors.blueGrey, 0.25), listTileBg],
          center: Alignment(0.6, -0.3),
          focal: Alignment(0.3, -0.1),
          focalRadius: 12.5,
        )
      ),
      child: Container(
        margin: EdgeInsets.zero,
        child: ListTile(
          enabled: shouldBeEnabled,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          onTap: (){
            if(widget.beginTechniqueInEnvironment != null){
              widget.beginTechniqueInEnvironment(widget.technique);
            }
          },
          leading: shouldBeEnabled ? PopupMenuButton(
            child: IconButton(
              icon: Icon(
                Icons.more_vert,
                size: 36,
                color: widget.cardActionColor,
              ),
              tooltip: widget.technique.title + ' Technique Options',
            ),
            itemBuilder: (context) => techniqueMenuOptions,
            onSelected: (op){
              if(op != 'Delete' && op != 'Edit'){
                widget.changePersonalTechnique(op, widget.technique);
              }
              else if(op == 'Edit'){
                widget.editCustomTechnique(widget.technique);
              }
              else{
                widget.deleteCustomTechnique(widget.technique);
              }
            },
          ) : null,
          title: Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
                widget.technique.title,
                style: TextStyle(
                    fontSize: 26,
                    color: titleColor,
                ),
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.technique.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 22,
                    color: subtitleColor
                ),
              )
            ],
          ),
          trailing: shouldBeEnabled ? IconButton(
            icon: Icon(
              Icons.help,
              size: 36,
              color: widget.cardActionColor,
            ),
            onPressed: (){
              widget.viewTechniqueDetails(widget.technique);
            },
          ) : Container(
            width: 70,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
                color: widget.disabledCardBgAccentColor,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    color: Colors.blueGrey
                )
            ),
            child: Text(
              'PRO',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
