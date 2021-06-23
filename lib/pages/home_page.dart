import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:geolocator/geolocator.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:walk_alone/actions/maps.dart';
import 'package:walk_alone/actions/welcome.dart';
import 'package:walk_alone/api/google_maps_api.dart';
import 'package:walk_alone/model/Destination.dart';
import 'package:walk_alone/model/Trip.dart';
import '../api/speech_api.dart';
import '../actions/subject.dart';
import '../actions/welcome.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<HomePage> {
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  // double _confidence = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text('Walk alone'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _textToSpeech,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
          reverse: true,
          child: Container(
            padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
            child: Text(_text),
          )),
    );
  }

  Future toggleRecording() => SpeechApi.toggleRecording(
        onResult: (text) => setState(() => this._text = text),
        onListening: (isListening) {
          setState(() => this._isListening = isListening);
          if (!isListening) {
            Future.delayed(Duration(seconds: 1), () {
              if (Subject.SUBJECT == Subject.NONE_SUBJECT) {
                Subject.findSubject(
                    rawText: this._text,
                    onResult: (value) => {toggleRecording()});
              } else if (Subject.SUBJECT == Subject.MAPS_SUBJECT) {
                Maps.mapsSubject(
                    text: this._text, onResult: (value) => {toggleRecording()});
              }
            });
          }
        },
      );

  void _textToSpeech()async {

     GoogleMapsApi.findDestinations("marrakech");
/* 
     if (!_isListening) {
      Welcome.index(onResult: (value) => {toggleRecording()});
    }
    
    Position position = await Utils.determinePosition();
      print(position);
      Trip trip = await GoogleMapsApi.startWalking(
          destination:
              "Centre Jaber de la FSSM, Avenue Prince Moulay Abdullah, 46060 Marrakech, Maroc",
          position: position);
      print(trip.id);
      SpeechApi.textTospeech(
          text: Answer.distaneToFinish + trip.distanceValue.toString() + "métre", 
          onResult: (value) => {});

      trip.streamPosition();*/

   //   Utils.connectToBte(address: "00:21:13:00:43:90");
     
     /* List<Destiantion> desc = await GoogleMapsApi.findDestinations("marrakech");
      print(desc[0].adr);*/
      
      /*Position position = await Utils.determinePosition();
      String r = await GoogleMapsApi.whereAmI(position);
      print(r);*/

  }

  // _getUserApi() async {
  //   var httpClient = new HttpClient();
  //   var uri =
  //       new Uri.https('placesmapsapp.herokuapp.com ', '/api/places/fst');
  //   var request = await httpClient.getUrl(uri);
  //   var response = await request.close();
  //   var responseBody = await response.transform(Utf8Decoder.decoder).join();
  //   return responseBody;
  // }
}
