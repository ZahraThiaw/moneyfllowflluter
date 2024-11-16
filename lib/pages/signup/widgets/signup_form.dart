import 'package:flutter/material.dart';
import 'package:moneyflow/utils/constants/dimensions.dart';

class SignupForm extends StatefulWidget {
  final Function(String, String, String, String, String) onSignup;

  const SignupForm({super.key, required this.onSignup});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  String _nom = '';
  String _prenom = '';
  String _telephone = '';
  String _email = '';
  String _password = '';

  void _handleSignup() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSignup(_nom, _prenom, _telephone, _email, _password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Nom',
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Veuillez entrer votre nom';
              }
              return null;
            },
            onChanged: (value) {
              _nom = value;
            },
          ),
          const SizedBox(height: AppDimensions.padding16),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Prénom',
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Veuillez entrer votre prénom';
              }
              return null;
            },
            onChanged: (value) {
              _prenom = value;
            },
          ),
          const SizedBox(height: AppDimensions.padding16),
          TextFormField(
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              hintText: 'Numéro de téléphone',
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Veuillez entrer votre numéro de téléphone';
              }
              return null;
            },
            onChanged: (value) {
              _telephone = value;
            },
          ),
          const SizedBox(height: AppDimensions.padding16),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Email',
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Veuillez entrer votre email';
              }
              return null;
            },
            onChanged: (value) {
              _email = value;
            },
          ),
          const SizedBox(height: AppDimensions.padding16),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Mot de passe',
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Veuillez entrer votre mot de passe';
              }
              return null;
            },
            onChanged: (value) {
              _password = value;
            },
          ),
          const SizedBox(height: AppDimensions.padding16),
          ElevatedButton(
            onPressed: _handleSignup,
            child: const Text('S\'inscrire'),
          ),
        ],
      ),
    );
  }
}