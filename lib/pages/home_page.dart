import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:walk_alone/actions/maps.dart';
import 'package:walk_alone/actions/welcome.dart';
import '../api/speech_api.dart';
import '../actions/subject.dart';
import '../actions/welcome.dart';

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

  void _textToSpeech() async {
    if (!_isListening) {
      Welcome.index(onResult: (value) => {toggleRecording()});
    }
  }
}
