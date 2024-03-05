import 'package:counter_test2/pages/home_page.dart';
import 'package:counter_test2/pages/recordar_password.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';

//final FirebaseAuth _auth = FirebaseAuth.instance;

final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

Future<void> registerWithEmailAndPassword(String email, String password) async {
  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      //print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      //print('The account already exists for that email.');
    }
  } catch (e) {
    //print(e);
  }
}

Future<void> signInWithEmailAndPassword(
    String email, String password, BuildContext context) async {
  try {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    // Usuario inició sesión exitosamente, navegar a la página principal
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      //print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      //print('Wrong password provided for that user.');
    }
  }
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          Fondo(),
          Contenido(),
        ],
      ),
    );
  }
}

class Fondo extends StatelessWidget {
  const Fondo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [
            Colors.blue.shade300,
            Colors.blue,
          ],
        ),
      ),
    );
  }
}

class Contenido extends StatefulWidget {
  const Contenido({super.key});

  @override
  State<Contenido> createState() => _ContenidoState();
}

class _ContenidoState extends State<Contenido> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Login',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
          ),
          SizedBox(height: 5),
          Text(
            'Bienvenido a tu cuenta',
            style: TextStyle(
                color: Colors.white, fontSize: 18, letterSpacing: 1.5),
          ),
          SizedBox(height: 15),
          Datos(),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}

class Datos extends StatefulWidget {
  const Datos({super.key});

  @override
  State<Datos> createState() => _DatosState();
}

class _DatosState extends State<Datos> {
  bool showPass = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Email',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'micorreo@micorreo.com'),
          ),
          const SizedBox(height: 5),
          const Text(
            'Password',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: _passwordController,
            obscureText: showPass,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'contraseña',
                suffixIcon: IconButton(
                  icon:
                      Icon(showPass ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => {
                    setState(() {
                      showPass = !showPass;
                      //showPass == true ? showPass = false : showPass = true;
                    })
                  },
                )),
          ),
          const Remember(),
          const SizedBox(height: 30),
          const Botones(),
        ],
      ),
    );
  }
}

class Remember extends StatefulWidget {
  const Remember({super.key});

  @override
  State<Remember> createState() => _RememberState();
}

class _RememberState extends State<Remember> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: checked,
          onChanged: (value) {
            setState(() => checked == false ? checked = true : checked = false);
          },
        ),
        const Text(
          "Recordar cuenta",
          style: TextStyle(fontSize: 12),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RecordarPassword()));
          }, // ------------------------------------------------------------------------------------------------
          child: const Text(
            "Olvido su contraseña",
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class Botones extends StatelessWidget {
  const Botones({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              signInWithEmailAndPassword(
                  _emailController.text, _passwordController.text, context);
            },
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xff142047))),
            child: const Text(
              "Login",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(
          height: 25,
          width: double.infinity,
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              // registerWithEmailAndPassword(
              //     _emailController.text, _passwordController.text);

              try {
                final credential =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: "_emailController.text",
                  password: "_passwordController.text",
                );
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  //print('The password provided is too weak.');
                } else if (e.code == 'email-already-in-use') {
                  //print('The account already exists for that email.');
                }
              } catch (e) {
                //print(e);
              }
            },
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xff142047))),
            child: const Text(
              "Register",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(
          height: 25,
          width: double.infinity,
        ),
        const Text(
          'O entra con',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          height: 25,
          width: double.infinity,
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
              onPressed: () {
                signInWithGoogle();
              },
              child: const Text(
                'Google',
                style: TextStyle(
                  color: Color(0xff142047),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              )),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
              onPressed: () => {},
              child: const Text(
                'Facebook',
                style: TextStyle(
                  color: Color(0xff142047),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              )),
        ),
        //const Container().
        const SizedBox(height: 20),
        TextButton(
          onPressed:
              () {}, // ------------------------------------------------------------------------------------------------
          child: const Text(
            "Politicas de privacidad",
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
