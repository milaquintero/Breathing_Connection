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
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  //track user selected session length in minutes (default to 5 min)
  int sessionLengthInMinutes = 5;
  //track user selected session length in seconds (default to 5 min)
  int sessionLengthInSeconds = 300;
  //nav links for available bottom nav pages
  List<NavLink> navLinks;
  //stores match for nav link home page
  NavLink homePage;
  //timer to track session time
  Timer _sessionTimer;
  //timer for countdown before session begins
  Timer _countdownTimer;
  //seconds elapsed during session
  int secondsElapsedDuringSession = 0;
  //track three second countdown
  int countdown = 3;
  //path for music source after downloading
  String musicSourcePath;
  //CDN asset handler
  AssetHandler assetHandler;
  //track if dependencies are loaded
  bool dependenciesAreLoaded = false;
  //breathing rhythm counter (custom technique)
  int breathingRhythmCounter = 0;
  //current breathing rhythm section display (custom technique)
  String breathingRhythmSectionDisplay = "";
  //list of seconds that match inhale (custom technique)
  List<int> inhaleMatches;
  //list of seconds that match inhale (custom technique)
  List<int> firstHoldMatches;
  //list of seconds that match inhale (custom technique)
  List<int> exhaleMatches;
  //list of seconds that match inhale (custom technique)
  List<int> secondHoldMatches;
  //total breathing rhythm duration (custom technique)
  int breathingRhythmLength;
  //count for each individual breathing rhythm section (custom technique)
  int breathingRhythmSectionCounter = 0;
  void sendToHomePage(){
    Provider.of<CurrentPageHandler>(context, listen: false).setPageIndex(0);
    Navigator.pushReplacementNamed(context, '/root');
  }
  void pauseContent(){
    _sessionTimer?.cancel();
    if(secondsElapsedDuringSession != sessionLengthInSeconds){
      _videoController?.pause();
    }
  }
  void playContent(){
    initializeSessionTimer();
    if(secondsElapsedDuringSession != sessionLengthInSeconds){
      _videoController?.play();
    }
  }
  void initializeSessionTimer(){
    if(_sessionTimer != null){
      _sessionTimer?.cancel();
      _sessionTimer = null;
    }
    //set up timer
    _sessionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (secondsElapsedDuringSession < sessionLengthInSeconds) {
          ++secondsElapsedDuringSession;
          //handle custom technique display
          if(techniqueToDisplay.associatedUserID != null){
            ++breathingRhythmCounter;
            //handle resetting
            if(breathingRhythmCounter == (breathingRhythmLength + 1)){
              breathingRhythmCounter = 1;
            }
            //handle inhale duration
            if(inhaleMatches.contains(breathingRhythmCounter)) {
              breathingRhythmSectionDisplay = "Breathe In";
            }
            //handle first hold duration
            else if(firstHoldMatches.contains(breathingRhythmCounter)){
              breathingRhythmSectionDisplay = "Hold";
            }
            //handle exhale duration
            else if(exhaleMatches.contains(breathingRhythmCounter)){
              breathingRhythmSectionDisplay = "Breathe Out";
            }
            //handle second hold duration
            else if(secondHoldMatches.contains(breathingRhythmCounter)){
              breathingRhythmSectionDisplay = "Hold";
            }
            //handle beginning of each section
            if(
            breathingRhythmCounter == inhaleMatches[0] ||
            breathingRhythmCounter == firstHoldMatches[0] ||
            breathingRhythmCounter == exhaleMatches[0] ||
            breathingRhythmCounter == secondHoldMatches[0]
            ){
              breathingRhythmSectionCounter = 0;
            }
            ++breathingRhythmSectionCounter;
          }
        } else {
          if(_videoController != null){
            _videoController?.dispose();
          }
          _sessionTimer?.cancel();
        }
      });
    });
  }
  void initializeCountdownTimer(){
    if(_countdownTimer != null){
      _countdownTimer?.cancel();
      _countdownTimer = null;
    }
    //set up timer
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (countdown > 0) {
          --countdown;
        } else {
          _countdownTimer?.cancel();
        }
      });
    });
  }
  @override
  void dispose() {
    super.dispose();
    if(secondsElapsedDuringSession != sessionLengthInSeconds && _videoController != null){
      // Ensure disposing of the VideoPlayerController to free up resources.
      _videoController?.dispose();
    }
    _sessionTimer?.cancel();
    _countdownTimer?.cancel();
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
      //only use video if technique isn't custom
      if(techniqueToDisplay.associatedUserID == null){
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
      }
      else{
        //list of seconds that match inhale
        inhaleMatches = List<int>.generate(techniqueToDisplay.inhaleDuration, (i) => i + 1);
        //list of seconds that match first hold
        firstHoldMatches = List<int>.generate(techniqueToDisplay.firstHoldDuration,
                (i) => (i + 1) + techniqueToDisplay.inhaleDuration);
        //list of seconds that match exhale
        exhaleMatches = List<int>.generate(techniqueToDisplay.exhaleDuration,
                (i) => (i + 1) + techniqueToDisplay.inhaleDuration + techniqueToDisplay.firstHoldDuration);
        //list of seconds that match second hold
        secondHoldMatches = List<int>.generate(techniqueToDisplay.secondHoldDuration,
                (i) => (i + 1) + techniqueToDisplay.inhaleDuration + techniqueToDisplay.firstHoldDuration + techniqueToDisplay.exhaleDuration);
        //total breathing rhythm duration
        breathingRhythmLength = techniqueToDisplay.inhaleDuration +
                                techniqueToDisplay.firstHoldDuration +
                                techniqueToDisplay.exhaleDuration +
                                techniqueToDisplay.secondHoldDuration;
      }
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
                            //show display once video is ready
                            //or show if technique is custom
                            if (snapshot.connectionState == ConnectionState.done ||
                            techniqueToDisplay.associatedUserID != null) {
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
                                                      sessionLengthInSeconds = sessionLengthInMinutes * 60;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          if(secondsElapsedDuringSession < sessionLengthInSeconds) Text(
                                            'Rotate your device to landscape mode to begin the session.',
                                            style: TextStyle(
                                                fontSize: 28,
                                                color: appTheme.textSecondaryColor
                                            ),
                                          ),
                                          if(secondsElapsedDuringSession == sessionLengthInSeconds) Column(
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
                                  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
                                  //show countdown timer if session hasn't started
                                  if(countdown > 0){
                                      //start countdown timer
                                      initializeCountdownTimer();
                                      return Stack(
                                        alignment: Alignment.topCenter,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 68),
                                            child: Text(
                                              'Starting Session',
                                              style: TextStyle(
                                                  color: appTheme.textSecondaryColor,
                                                  fontSize: 64
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 104),
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Positioned(
                                                  top: 92,
                                                  child: Text(
                                                    countdown.toString(),
                                                    style: TextStyle(
                                                        color: appTheme.textSecondaryColor,
                                                        fontSize: 72
                                                    ),
                                                  ),
                                                ),
                                                SpinKitDualRing(
                                                  size: 120,
                                                  color: appTheme.brandPrimaryColor,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      );
                                    }
                                    else{
                                      //start/resume timer if technique isn't custom
                                      if(secondsElapsedDuringSession < sessionLengthInSeconds &&
                                      techniqueToDisplay.associatedUserID == null){
                                        playContent();
                                      }
                                      else if(techniqueToDisplay.associatedUserID != null){
                                        initializeSessionTimer();
                                      }
                                      return Stack(
                                        alignment: Alignment.topCenter,
                                        children: [
                                          SizedBox.expand(
                                            child: FittedBox(
                                              fit: BoxFit.cover,
                                              child: SizedBox(
                                                width: _videoController?.value?.size?.width ?? MediaQuery.of(context).size.width,
                                                height: _videoController?.value?.size?.height ?? MediaQuery.of(context).size.height,
                                                child:
                                                //handle display if session isn't over
                                                secondsElapsedDuringSession < sessionLengthInSeconds ?
                                                //check if technique is custom
                                                techniqueToDisplay.associatedUserID != null ?
                                                //custom technique display
                                                Container(
                                                  decoration: BoxDecoration(
                                                    gradient: RadialGradient(
                                                      colors: [Colors.blueGrey[400], Color.lerp(appTheme.brandPrimaryColor, Colors.blueGrey[400], 0.1), appTheme.brandPrimaryColor],
                                                      center: Alignment(-10.5, 0.8),
                                                      focal: Alignment(0.3, -0.1),
                                                      focalRadius: 3.5,
                                                    ),
                                                  ),
                                                  child: breathingRhythmCounter == 0 ?
                                                  //initial display for custom technique
                                                  Center(
                                                    child: Text(
                                                      'Begin',
                                                      style: TextStyle(
                                                          color: appTheme.textPrimaryColor,
                                                          fontSize: 72
                                                      ),
                                                    ),
                                                  ) :
                                                  //display for when counting begins
                                                  Stack(
                                                    alignment: Alignment.topCenter,
                                                    children: [
                                                      //decoration animation
                                                      Positioned(
                                                        left: -120,
                                                        top: 172,
                                                        child: SpinKitFadingFour(
                                                          size: 2048,
                                                          color: appTheme.textPrimaryColor.withOpacity(0.03),
                                                        ),
                                                      ),
                                                      //decoration animation
                                                      Positioned(
                                                        right: -120,
                                                        top: -272,
                                                        child: SpinKitFadingGrid(
                                                          size: 2048,
                                                          color: appTheme.textPrimaryColor.withOpacity(0.03),
                                                        ),
                                                      ),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            breathingRhythmSectionDisplay,
                                                            style: TextStyle(
                                                                color: appTheme.textPrimaryColor,
                                                                fontSize: 64
                                                            ),
                                                          ),
                                                          SizedBox(height: 24,),
                                                          CircleAvatar(
                                                            backgroundColor: appTheme.brandAccentColor,
                                                            foregroundColor: appTheme.textPrimaryColor,
                                                            radius: 84,
                                                            child: Stack(
                                                              alignment: Alignment.center,
                                                              children: [
                                                                Positioned(
                                                                  top: 28,
                                                                  child: Text(
                                                                    breathingRhythmSectionCounter.toString(),
                                                                    style: TextStyle(
                                                                        color: appTheme.textPrimaryColor,
                                                                        fontSize: 80
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ) :
                                                //standard technique display
                                                VideoPlayer(_videoController) :
                                                //session end display
                                                Center(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          'Session Complete',
                                                          style: TextStyle(
                                                              color: appTheme.textSecondaryColor,
                                                              fontSize: 72
                                                          ),
                                                        ),
                                                        SizedBox(height: 32,),
                                                        Text(
                                                          'Rotate your device back to portrait mode.',
                                                          style: TextStyle(
                                                            fontSize: 36,
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
