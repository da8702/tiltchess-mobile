import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  bool loading = false;
  String? error;
  bool isSignUp = true; // default to sign up for first-time users

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (loading) return;

    setState(() {
      loading = true;
      error = null;
    });

    final supa = Supabase.instance.client;
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text;

    try {
      if (isSignUp) {
        final res = await supa.auth.signUp(email: email, password: pass);
        if (res.session == null) {
          // This happens if "Confirm email" is enabled
          setState(() => error =
              'Sign-up succeeded but no session. Check your email to confirm, then sign in.');
        }
      } else {
        await supa.auth.signInWithPassword(email: email, password: pass);
      }
    } on AuthException catch (e) {
      setState(() => error = e.message);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'TiltChess',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Text('Sign up'),
                      selected: isSignUp,
                      onSelected: loading ? null : (_) => setState(() => isSignUp = true),
                    ),
                    const SizedBox(width: 12),
                    ChoiceChip(
                      label: const Text('Sign in'),
                      selected: !isSignUp,
                      onSelected: loading ? null : (_) => setState(() => isSignUp = false),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                TextField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                const SizedBox(height: 16),

                if (error != null) ...[
                  Text(error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 12),
                ],

                ElevatedButton(
                  onPressed: loading ? null : _submit,
                  child: Text(loading
                      ? 'Loading…'
                      : (isSignUp ? 'Create account' : 'Sign in')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}