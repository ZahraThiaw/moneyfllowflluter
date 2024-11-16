// action_section.dart
import 'package:flutter/material.dart';

class ActionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionItem(Icons.send, "Transfert"),
        _buildActionItem(Icons.payment, "Paiement"),
        _buildActionItem(Icons.request_page, "Planifier transfert"),
        _buildActionItem(Icons.receipt, "Historique"),
      ],
    );
  }

  Widget _buildActionItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[800], size: 30.0),
        SizedBox(height: 4.0),
        Text(
          label,
          style: TextStyle(fontSize: 12.0, color: Colors.grey[800]),
        ),
      ],
    );
  }
}
