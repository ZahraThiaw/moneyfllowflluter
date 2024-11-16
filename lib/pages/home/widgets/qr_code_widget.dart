import 'package:flutter/material.dart';

class QRCodeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Icon(Icons.qr_code, size: 100, color: Colors.black), // Icône QR code
          SizedBox(height: 8.0),
          Text("Scanner", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
