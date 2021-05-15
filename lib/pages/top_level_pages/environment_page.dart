import 'dart:async';

import 'package:breathing_connection/models/app_theme.dart';
import 'package:breathing_connection/models/asset_handler.dart';
import 'package:breathing_connection/models/current_page_handler.dart';
import 'package:breathing_connection/models/current_theme_handler.dart';
import 'package:breathing_connection/models/inhale_exhale_type.dart';
import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/models/nav_link.dart';
import 'package:breathing_connection/models/technique.dart';
import 'package:breathing_connection/models/user.dart';
import 'package:breathing_connection/models/view_technique_details_handler.dart';
import 'package:breathing_connection/pages/top_level_pages/loading_page.dart';
import 'package:breathing_connection/services/main_data_service.dart';
import 'package:breathing_connection/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class EnvironmentPage extends StatefulWidget {
  @override
  _EnvironmentPageState createState() => _EnvironmentPageState();
}

class _EnvironmentPageState extends State<EnvironmentPage> {
  //technique data to display
  Technique techniqueToDisplay;
  //app main data
  MainData mainData;
  //exhale type for selected technique
  InhaleExhaleType inhaleType;
  //inhale type for selected technique
  InhaleExhaleType exhaleType;
  //app theme data
  AppTheme appTheme;
  //screen height
  double screenHeight;
  //current user
  User curUser;
  //video player controller
  VideoPlayerController _videoController;
  //video player future
  Future<void> _initializeVideoPlayerFuture;
  //track user selected session length (default to 5 min)
  int sessionLengthInMinutes = 5;
  //nav links for available bottom nav pages
  List<NavLink> navLinks;
  //stores match for nav link home page
  NavLink homePage;
  //timer to track session time
  Timer _sessionTimer;
  //seconds elapsed during session
  int secondsElapsedDuringSession = 0;
  //path for music source after downloading
  String musicSourcePath;
  //CDN asset handler
  AssetHandler assetHandler;
  //track if dependencies are loaded
  bool dependenciesAreLoaded = false;
  void sendToHomePage(){
    Provider.of<CurrentPageHandler>(context, listen: false).setPageIndex(0);
    Navigator.pushReplacementNamed(context, '/root');
  }
  void pauseContent(){
    _sessionTimer?.cancel();
    if(secondsElapsedDuringSession != sessionLengthInMinutes){
      _videoController?.pause();
    }
  }
  void playContent(){
    initializeTimer();
    if(secondsElapsedDuringSession != sessionLengthInMinutes){
      _videoController?.play();
    }
  }
  void initializeTimer(){
    if(_sessionTimer != null){
      _sessionTimer?.cancel();
      _sessionTimer = null;
    }
    //set up timer
    _sessionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (secondsElapsedDuringSession < sessionLengthInMinutes) {
          ++secondsElapsedDuringSession;
        } else {
          _videoController.dispose();
          _sessionTimer.cancel();
        }
      });
    });
  }
  @override
  void dispose() {
    super.dispose();
    if(secondsElapsedDuringSession != sessionLengthInMinutes){
      // Ensure disposing of the VideoPlayerController to free up resources.
      _videoController?.dispose();
    }
    _sessionTimer?.cancel();
  }
  void initializeDependencies() async{
    if(!dependenciesAreLoaded){
      //available nav links from provider
      navLinks = mainData.pages;
      //find home page in main data page links
      homePage = navLinks.firstWhere((page) => page.pageRoute == '/home');
      //get technique data
      techniqueToDisplay = Provider.of<ViewTechniqueDetailsHandler>(context).techniqueBeingViewed;
      //selected theme data
      appTheme = Provider.of<CurrentThemeHandler>(context).currentTheme;
      //screen height
      screenHeight = MediaQuery.of(context).size.height;
      //get asset handler for CDN resources
      assetHandler = Provider.of<AssetHandler>(context, listen: false);
      //get inhale/exhale data from list in main data based on inhaleExhaleTypeID
      inhaleType = mainData.inhaleExhaleTypes.firstWhere((inhaleExhaleType) => inhaleExhaleType.inhaleExhaleTypeID == techniqueToDisplay.inhaleTypeID);
      exhaleType = mainData.inhaleExhaleTypes.firstWhere((inhaleExhaleType) => inhaleExhaleType.inhaleExhaleTypeID == techniqueToDisplay.exhaleTypeID);
      //determine the asset video based on user settings
      String videoSuffix = "";
      if(!curUser.userSettings.breathingSound && !curUser.userSettings.backgroundSound){
        videoSuffix = "_no_music_no_sound";
      }
      else if(curUser.userSettings.breathingSound && !curUser.userSettings.backgroundSound){
        videoSuffix = "_no_music_with_sound";
      }
      else if(!curUser.userSettings.breathingSound && curUser.userSettings.backgroundSound){
        videoSuffix = "_with_music_no_sound";
      }
      else if(curUser.userSettings.breathingSound && curUser.userSettings.backgroundSound){
        videoSuffix = "_with_music_with_sound";
      }
      //load appropriate video for technique
      _videoController = VideoPlayerController.network(
        '${assetHandler.videoAssetURL}/${techniqueToDisplay.associatedVideo}$videoSuffix.mp4',
      );
      //video will loop until session completes
      _videoController.setLooping(true);
      //initialize video player
      _initializeVideoPlayerFuture = _videoController.initialize();
      //update flag
      dependenciesAreLoaded = true;
    }
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: UserService().userWithData,
        builder: (context, userSnapshot){
          if(userSnapshot.hasData){
            curUser = userSnapshot.data;
            return StreamBuilder(
                stream: MainDataService().mainData,
                builder: (context, mainDataSnapshot){
                  if(mainDataSnapshot.hasData){
                    mainData = mainDataSnapshot.data;
                    initializeDependencies();
                    return Scaffold(
                      backgroundColor: appTheme.bgPrimaryColor,
                      body: SafeArea(
                        child: FutureBuilder(
                          future: _initializeVideoPlayerFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return OrientationBuilder(
                                builder: (context, orientation) {
                                  //handle portrait mode
                                  if(orientation == Orientation.portrait){
                                    //pause content if switched back to portrait mode
                                    if(_sessionTimer != null && secondsElapsedDuringSession != 0){
                                      pauseContent();
                                    }
                                    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
                                    return Container(
                                      padding: EdgeInsets.symmetric(horizontal: 46),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          if(secondsElapsedDuringSession == 0) Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(bottom: 24),
                                                child: Text(
                                                  'Session Duration',
                                                  style: TextStyle(
                                                      fontSize: 34,
                                                      color: appTheme.textSecondaryColor
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "$sessionLengthInMinutes minutes",
                                                style: TextStyle(
                                                    fontSize: 24,
                                                    color: appTheme.textSecondaryColor
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 16, bottom: 16),
                                                child: Slider(
                                                  activeColor: appTheme.textSecondaryColor,
                                                  value: double.parse(sessionLengthInMinutes.toString()),
                                                  min: double.parse(techniqueToDisplay.minSessionDurationInMinutes.toString()),
                                                  max: double.parse(mainData.maxSessionDurationInMinutes.toString()),
                                                  divisions: ((mainData.maxSessionDurationInMinutes - techniqueToDisplay.minSessionDurationInMinutes) / techniqueToDisplay.minSessionDurationInMinutes).round(),
                                                  label: sessionLengthInMinutes.round().toString(),
                                                  onChanged: (double value) {
                                                    setState(() {
                                                      sessionLengthInMinutes = value.round();
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          if(secondsElapsedDuringSession < sessionLengthInMinutes) Text(
                                            'Rotate your device to landscape mode to begin the session.',
                                            style: TextStyle(
                                                fontSize: 28,
                                                color: appTheme.textSecondaryColor
                                            ),
                                          ),
                                          if(secondsElapsedDuringSession == sessionLengthInMinutes) Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(bottom: 24),
                                                child: Text(
                                                  'Session Complete',
                                                  style: TextStyle(
                                                      fontSize: 34,
                                                      color: appTheme.textSecondaryColor
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                'Press the button below to return to the home page.',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  color: appTheme.textSecondaryColor,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                          if(secondsElapsedDuringSession == 0) Text(
                                            'Once the session begins you will not be able to change the session duration.',
                                            style: TextStyle(
                                                fontSize: 28,
                                                color: appTheme.textSecondaryColor
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 40, bottom: 28),
                                            child: TextButton(
                                              onPressed: (){
                                                sendToHomePage();
                                              },
                                              child: Text(
                                                'Back to Home',
                                                style: TextStyle(
                                                    fontSize: 24,
                                                    color: Colors.white
                                                ),
                                              ),
                                              style: TextButton.styleFrom(
                                                backgroundColor: Colors.deepOrange[600],
                                                padding: EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  //handle landscape mode
                                  else{
                                    //start/resume timer
                                    if(secondsElapsedDuringSession < sessionLengthInMinutes){
                                      playContent();
                                    }
                                    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
                                    return Stack(
                                      alignment: Alignment.topCenter,
                                      children: [
                                        SizedBox.expand(
                                          child: FittedBox(
                                            fit: BoxFit.cover,
                                            child: SizedBox(
                                              width: _videoController.value.size?.width ?? 0,
                                              height: _videoController.value.size?.height ?? 0,
                                              child: secondsElapsedDuringSession < sessionLengthInMinutes ?
                                              VideoPlayer(_videoController) : Center(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        'Session Complete',
                                                        style: TextStyle(
                                                            color: appTheme.textSecondaryColor,
                                                            fontSize: 84
                                                        ),
                                                      ),
                                                      SizedBox(height: 52,),
                                                      Text(
                                                        'Rotate your device back to portrait mode.',
                                                        style: TextStyle(
                                                          fontSize: 56,
                                                          color: appTheme.textSecondaryColor,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  )
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                },
                              );
                            } else {
                              return LoadingPage();
                            }
                          },
                        ),
                      ),
                    );
                  }
                  else{
                    return LoadingPage();
                  }
                }
            );
          }
          else{
            return LoadingPage();
          }
        }
    );
  }
}
