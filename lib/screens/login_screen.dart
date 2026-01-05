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
  final confirmCtrl = TextEditingController();

  bool loading = false;
  String? error;
  bool isSignUp = false; // default to sign in to match design

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    confirmCtrl.dispose();
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
    final confirm = confirmCtrl.text;

    try {
      if (isSignUp) {
        if (pass != confirm) {
          setState(() => error = 'Passwords do not match');
          return;
        }
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

  static const _darkPrimary = Color(0xFF030213);
  static const _grayInput = Color(0xFFF3F3F5);
  static const _grayText = Color(0xFF6A7282);
  static const _brandRed = Color(0xFFB71C1C);

  Widget _segmented() {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFECECF0),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          _segmentedTab(selected: !isSignUp, label: 'Sign In', onTap: () {
            if (loading) return;
            setState(() => isSignUp = false);
          }),
          _segmentedTab(selected: isSignUp, label: 'Sign Up', onTap: () {
            if (loading) return;
            setState(() => isSignUp = true);
          }),
        ],
      ),
    );
  }

  Widget _segmentedTab(
      {required bool selected, required String label, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialButton(String label, Widget leading) {
    return SizedBox(
      height: 44,
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFE4E4E7)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: loading ? null : () {},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            leading,
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String placeholder) {
    return InputDecoration(
      hintText: placeholder,
      filled: true,
      fillColor: _grayInput,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 340),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'No',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: 'Tilt ',
                          style: TextStyle(color: _brandRed),
                        ),
                        TextSpan(
                          text: 'Chess',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Play chess without the tilt',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF4A5565),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  _segmented(),
                  const SizedBox(height: 32),
                  _socialButton(
                    'Continue with Google',
                    Image.asset(
                      'assets/google_logo.png',
                      width: 18,
                      height: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _socialButton(
                    'Continue with Apple',
                    const Icon(Icons.apple, size: 18, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: const [
                      Expanded(
                          child: Divider(
                        color: Color(0x19000000),
                        thickness: 1,
                      )),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'OR CONTINUE WITH EMAIL',
                          style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 0.5,
                            color: _grayText,
                          ),
                        ),
                      ),
                      Expanded(
                          child: Divider(
                        color: Color(0x19000000),
                        thickness: 1,
                      )),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Email',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDecoration('your@email.com'),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Password',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                TextField(
                  controller: passCtrl,
                  obscureText: true,
                  decoration: _inputDecoration('••••••••'),
                ),
                if (isSignUp) ...[
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Confirm Password',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: confirmCtrl,
                    obscureText: true,
                    decoration: _inputDecoration('••••••••'),
                  ),
                ],
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: loading ? null : () {},
                    style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF4A5565),
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (error != null) ...[
                    Text(
                      error!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                  ],
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: _darkPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: loading ? null : _submit,
                      child: Text(
                        loading
                            ? 'Loading…'
                            : (isSignUp ? 'Create Account' : 'Sign In'),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    '© 2026 NoTilt Chess. All rights reserved.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: _grayText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
