import 'package:breathing_connection/models/technique.dart';
import 'package:breathing_connection/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TechniqueCard extends StatefulWidget {
  final Technique technique;
  final Function(String, Technique) changeTechnique;
  final Function(Technique) viewTechniqueDetails;
  final Color disabledCardBgColor;
  final Color disabledCardBgAccentColor;
  final Color disabledCardTextColor;
  final Color disabledCardBorderColor;
  final Color cardBorderColor;
  final Color cardTitleColor;
  final Color cardSubtitleColor;
  final Color cardBgColor;
  final Color cardActionColor;
  TechniqueCard({this.technique, this.changeTechnique, this.viewTechniqueDetails,
  this.disabledCardTextColor, this.disabledCardBorderColor, this.disabledCardBgColor,
  this.disabledCardBgAccentColor, this.cardTitleColor, this.cardSubtitleColor,
  this.cardBorderColor, this.cardBgColor, this.cardActionColor});

  @override
  _TechniqueCardState createState() => _TechniqueCardState();
}

class _TechniqueCardState extends State<TechniqueCard> {
  User curUser;
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
    curUser = Provider.of<User>(context);
    shouldBeEnabled = curUser.hasFullAccess || (!curUser.hasFullAccess && !widget.technique.isPaidVersionOnly);
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
      ),
      child: Card(
        margin: EdgeInsets.zero,
        child: ListTile(
          enabled: shouldBeEnabled,
          contentPadding: EdgeInsets.all(20),
          onTap: (){},
          leading: shouldBeEnabled ? PopupMenuButton(
            child: IconButton(
              icon: Icon(
                Icons.more_vert,
                size: 32,
                color: widget.cardActionColor,
              ),
              tooltip: widget.technique.title + ' Technique Options',
            ),
            itemBuilder: (context) => techniqueMenuOptions,
            onSelected: (op){
              widget.changeTechnique(op, widget.technique);
            },
          ) : null,
          tileColor: listTileBg,
          title: Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
                widget.technique.title,
                style: TextStyle(
                    fontSize: 22,
                    color: titleColor
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
                    fontSize: 15,
                    color: subtitleColor
                ),
              ),
              Text(
                'Breathing Rhythm: ${widget.technique.inhaleDuration}-${widget.technique.firstHoldDuration}-${widget.technique.exhaleDuration}-${widget.technique.secondHoldDuration}',
                style: TextStyle(
                    fontSize: 15,
                    color: subtitleColor
                ),
              )
            ],
          ),
          trailing: shouldBeEnabled ? IconButton(
            icon: Icon(
              Icons.help,
              size: 32,
              color: widget.cardActionColor,
            ),
            onPressed: (){
              widget.viewTechniqueDetails(widget.technique);
            },
          ) : Container(
            width: 60,
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
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
