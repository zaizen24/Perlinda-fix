import 'package:flutter/material.dart';
import 'package:flutter_perlinda/views/auth/login_kpppa_page.dart';
import 'package:flutter_perlinda/views/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showNotification(String message, bool isSuccess) {
    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          color: isSuccess ? Colors.green : Colors.red,
          padding: EdgeInsets.all(16),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  message,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(Duration(seconds: 3), () {
      _overlayEntry?.remove();
    });
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        _showNotification('Berhasil masuk!', true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'user-not-found') {
          message = 'Pengguna tidak ditemukan. Pastikan email sudah benar atau daftar akun baru.';
        } else if (e.code == 'wrong-password') {
          message = 'Kata sandi salah. Silakan coba lagi.';
        } else if (e.code == 'invalid-email') {
          message = 'Format email tidak valid. Pastikan kamu memasukkan email dengan benar.';
        } else {
          message = 'Terjadi kesalahan. Silakan coba lagi.';
        }
        _showNotification(message, false);
      } catch (e) {
        _showNotification(e.toString(), false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4682A9),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Stack to overlay logo and circle
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Circle
                      Container(
                        margin: EdgeInsets.only(top: 20.0),
                        width: 350.0,
                        height: 350.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF749BC2),
                        ),
                      ),
                      // Logo
                      Positioned(
                        top: 70.0, // Adjust the top position
                        child: Container(
                          width: 270.0,
                          height: 270.0,
                          child: Image.asset(
                            'images/logo_perlinda.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0), // Spacing

                  // Login form with rounded container
                  Container(
                    width: 430.0, // Adjust width as needed
                    height: 585.0, // Adjust height as needed to accommodate the new button
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // "Masuk" text
                          Center(
                            child: Text(
                              'Masuk',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0, // Adjust the font size
                                color: Color(0xFF00355C), // Adjust the text color
                              ),
                            ),
                          ),
                          const SizedBox(height: 30.0), // Spacing

                          // Alamat email text
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0), // Adjust the left padding
                              child: Text(
                                'Alamat Email',
                                style: TextStyle(
                                  fontSize: 16.0, // Adjust the font size
                                  fontWeight: FontWeight.bold, // Make the text bold
                                  color: Color(0xFF00355C), // Adjust the text color
                                ),
                              ),
                            ),
                          ),

                          // SizedBox for spacing between Alamat email text and email field
                          SizedBox(height: 12.0),

                          // Email field
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Masukkan alamat email',
                              border: InputBorder.none,
                              fillColor: Color(0xFFC1D9F1),
                              filled: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15.0), // Spacing

                          // Kata Sandi text
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0), // Adjust the left padding
                              child: Text(
                                'Kata Sandi',
                                style: TextStyle(
                                  fontSize: 16.0, // Adjust the font size
                                  fontWeight: FontWeight.bold, // Make the text bold
                                  color: Color(0xFF00355C), // Adjust the text color
                                ),
                              ),
                            ),
                          ),

                          // SizedBox for spacing between Kata Sandi text and password field
                          SizedBox(height: 12.0),

                          // Password field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Masukkan kata sandi',
                              border: InputBorder.none,
                              fillColor: Color(0xFFC1D9F1),
                              filled: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 5.0), // Spacing

                          // Forgot password button
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // Add your forgot password logic here
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Lupa Kata Sandi?',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold, // Make the text bold
                                          color: Color(0xFF00355C), // Adjust the text color
                                        ),
                                      ),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: [
                                            Text('Masukkan alamat email Anda untuk pemulihan kata sandi.'),
                                            TextFormField(
                                              decoration: const InputDecoration(
                                                labelText: 'Email',
                                                border: OutlineInputBorder(),
                                              ),
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please enter your email';
                                                }
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // Implement forgot password logic here
                                            // This is just a placeholder
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Pemulihan kata sandi sedang dalam pengembangan.'),
                                              ),
                                            );
                                          },
                                          child: const Text('Kirim'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text(
                                'Lupa Kata Sandi?',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, // Make the text bold
                                  color: Color(0xFF00355C), // Adjust the text color
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0), // Spacing

                          // Login button
                          ElevatedButton(
                            onPressed: _login,
                            child: SizedBox(
                              width: 391.0, // Set the width
                              height: 55.0, // Set the height
                              child: Center(
                                child: const Text(
                                  'Masuk',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF4682A9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12.0), // Spacing for the new button

                          // New Login button
                          ElevatedButton(
                            onPressed: () {
                              // Directly navigate to LoginKPPPAPage without validation
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => LoginKPPAPage()), // Navigate to LoginKPPPAPage
                              );
                            },
                            child: SizedBox(
                              width: 391.0, // Set the width
                              height: 55.0, // Set the height
                              child: Center(
                                child: const Text(
                                  'Masuk sebagai pihak berwenang',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF00355C),
                                  ),
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFC1D9F1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
