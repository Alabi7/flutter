import 'package:flutter/material.dart';
import 'dart:math';
import '../models/alarm_model.dart';

class DismissChallengeWidget extends StatefulWidget {
  final AlarmDismissMode mode;
  final VoidCallback onSuccess;

  const DismissChallengeWidget({
    Key? key,
    required this.mode,
    required this.onSuccess,
  }) : super(key: key);

  @override
  _DismissChallengeWidgetState createState() => _DismissChallengeWidgetState();
}

class _DismissChallengeWidgetState extends State<DismissChallengeWidget> {
  final TextEditingController _controller = TextEditingController();
  String _question = '';
  int _answer = 0;
  int _shakeCount = 0;

  @override
  void initState() {
    super.initState();
    _generateMathProblem();
  }

  void _generateMathProblem() {
    final random = Random();
    final a = random.nextInt(50) + 10;
    final b = random.nextInt(30) + 5;
    final operation = random.nextInt(3);
    
    switch (operation) {
      case 0: // Addition
        _question = '$a + $b = ?';
        _answer = a + b;
        break;
      case 1: // Soustraction
        _question = '$a - $b = ?';
        _answer = a - b;
        break;
      case 2: // Multiplication
        final smallA = random.nextInt(12) + 2;
        final smallB = random.nextInt(8) + 2;
        _question = '$smallA × $smallB = ?';
        _answer = smallA * smallB;
        break;
    }
  }

  void _checkAnswer() {
    final userAnswer = int.tryParse(_controller.text);
    if (userAnswer == _answer) {
      widget.onSuccess();
    } else {
      _controller.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mauvaise réponse ! Essayez encore.'),
          backgroundColor: Colors.red,
        ),
      );
      _generateMathProblem(); // Nouvelle question
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.mode) {
      case AlarmDismissMode.math:
        return _buildMathChallenge();
      case AlarmDismissMode.shake:
        return _buildShakeChallenge();
      case AlarmDismissMode.qrCode:
        return _buildQRCodeChallenge();
      case AlarmDismissMode.photo:
        return _buildPhotoChallenge();
      default:
        return _buildMathChallenge();
    }
  }

  Widget _buildMathChallenge() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Text(
            'Résolvez ce calcul pour arrêter l\'alarme :',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            _question,
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: 'Votre réponse',
              hintStyle: TextStyle(color: Colors.white54),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onSubmitted: (_) => _checkAnswer(),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _checkAnswer,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(
              'VALIDER',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShakeChallenge() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Text(
            'Secouez votre téléphone 10 fois pour arrêter l\'alarme',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.vibration,
                    size: 50,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    '$_shakeCount / 10',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
          LinearProgressIndicator(
            value: _shakeCount / 10,
            backgroundColor: Colors.white30,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildQRCodeChallenge() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Text(
            'Scannez le QR code configuré pour arrêter l\'alarme',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.qr_code_scanner,
              size: 100,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              // Ouvrir le scanner QR
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(
              'SCANNER',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoChallenge() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Text(
            'Prenez une photo de l\'objet configuré pour arrêter l\'alarme',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Container(
            width: 200,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.camera_alt,
              size: 80,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              // Ouvrir la caméra
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(
              'PRENDRE PHOTO',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}