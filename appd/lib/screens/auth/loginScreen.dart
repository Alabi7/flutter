import 'package:appd/screens/auth/signupScreen.dart';
import 'package:appd/screens/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _supabase = Supabase.instance.client;
  final _email = TextEditingController();
  final _password = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    // Pour rafraîchir l'état du bouton Login quand l'email/mdp changent
    _email.addListener(_onFieldsChanged);
    _password.addListener(_onFieldsChanged);
  }

  @override
  void dispose() {
    _email.removeListener(_onFieldsChanged);
    _password.removeListener(_onFieldsChanged);
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _onFieldsChanged() => setState(() {});

  bool get _canSubmit {
    final emailOk = _email.text.trim().contains('@');
    final pwOk = _password.text.length >= 6;
    return emailOk && pwOk && !_isLoading;
  }

  Future<void> _signIn() async {
    if (!_canSubmit) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final res = await _supabase.auth.signInWithPassword(
        email: _email.text.trim(),
        password: _password.text,
      );

      if (res.user != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged in successfully!')),
        );

        if (res.user != null && mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => MainScreen()),
            (route) => false, // Supprime TOUTES les routes
          );
        }
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _forgotPassword() async {
    if (_email.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your email first.')),
      );
      return;
    }
    try {
      await _supabase.auth.resetPasswordForEmail(_email.text.trim());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reset link sent to your email.')),
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        // Pour mobile, assure-toi d’avoir configuré l’URI scheme & redirect.
        // redirectTo: 'io.supabase.flutter://login-callback/', // ex.
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final fill = Colors.blueGrey.withOpacity(0.12);
    final radius = BorderRadius.circular(28);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Barre supérieure avec le "X" (close)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).maybePop();
                    },
                  ),
                ],
              ),
            ),

            // Petite illustration minimaliste (subtile)
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              child: SizedBox(
                height: 140,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: 0.25,
                        child: Icon(Icons.graphic_eq, size: 140, color: Colors.blueGrey.shade200),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueGrey.shade700, width: 3),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        width: 120,
                        height: 200,
                        child: const Icon(Icons.play_circle_fill, size: 48, color: Colors.indigo),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Formulaire
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Email
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          final t = v?.trim() ?? '';
                          if (t.isEmpty) return 'Email is required';
                          if (!t.contains('@')) return 'Invalid email';
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Email Address',
                          prefixIcon: const Icon(Icons.mail_outline),
                          filled: true,
                          fillColor: fill,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                          border: OutlineInputBorder(
                            borderRadius: radius,
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Password
                      TextFormField(
                        controller: _password,
                        obscureText: _obscure,
                        validator: (v) {
                          final t = v ?? '';
                          if (t.isEmpty) return 'Password is required';
                          if (t.length < 6) return 'Min 6 characters';
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          ),
                          filled: true,
                          fillColor: fill,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                          border: OutlineInputBorder(
                            borderRadius: radius,
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _forgotPassword,
                          child: const Text('Forgot Password?'),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Séparateur "or"
                      Row(
                        children: [
                          const Expanded(child: Divider(thickness: 1)),
                          const SizedBox(width: 12),
                          Text('or', style: TextStyle(color: Colors.grey.shade600)),
                          const SizedBox(width: 12),
                          const Expanded(child: Divider(thickness: 1)),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Bouton Google (Outlined + icône)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _signInWithGoogle,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(borderRadius: radius),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Remplace par ton asset si tu as le logo Google
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.white,
                                child: Text('G', style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.w600)),
                              ),
                              const SizedBox(width: 8),
                              const Text('Continue with Google'),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Bouton Login (plein, arrondi, large)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _canSubmit ? _signIn : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: radius),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Text('Login'),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Lien Sign Up
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
