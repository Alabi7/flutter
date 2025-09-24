import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';




class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _supabase = Supabase.instance.client;
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    setState(() => _isLoading = true);
    
    try {
      final response = await _supabase.auth.signUp(
        email: _email.text.trim(),
        password: _password.text,
      );
      
      if (response.user != null) {
        print("User registered successfully!");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Compte créé avec succès !')),
          );
        }
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${e.message}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          "Create Account",
          style: TextStyle(fontFamily: "Roboto", fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                fillColor: Colors.blueGrey.withOpacity(0.2),
                filled: true,
                hintText: "Email",
                border: const OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
            
            const SizedBox(height: 20),
            
            TextField(
              controller: _password,
              obscureText: true,
              decoration: InputDecoration(
                fillColor: Colors.blueGrey.withOpacity(0.2),
                filled: true,
                hintText: "Password",
                border: const OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
            
            const SizedBox(height: 40),
            
            _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _signUp,
                  child: const Text("Create Account"),
                ),
          ],
        ),
        
      ),
    );
  }
}