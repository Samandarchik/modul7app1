import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:modul8app_1/firebase_options.dart';
import 'package:modul8app_1/forger_password.dart';
import 'package:modul8app_1/widget.dart';
import 'package:google_sign_in/google_sign_in.dart';

const List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isRegistered = FirebaseAuth.instance.currentUser != null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: const Color(0xff000519)),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.active) {
                final isRegistered = snap.data != null;
                return isRegistered ? const HomePage() : LoginScreen();
              }
              return Container();
            }));
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: scopes,
);
Future<void> _handleSignIn() async {
  try {
    await _googleSignIn.signIn();
  } catch (error) {
    print(error);
  }
}

class _LoginScreenState extends State<LoginScreen> {
  static bool checkbox = false;
  static bool login = false;
  static bool passwordpage = false;
  String email = "";
  String password = "";
  bool isLoading = false;
  String? errorText; // Xato xabarini saqlash uchun o'zgaruvchi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 90,
                  child: Row(
                    children: [
                      Image.asset(
                        "images/Group.png",
                        height: 30,
                      ),
                      const Text(
                        " installpay",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Text(
                  login ? "Welcome" : "Create a new account",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Please put your information below to log in to your account",
                  style: TextStyle(
                      color: Colors.white.withOpacity(.7), fontSize: 18),
                ),
                if (!login)
                  MyTextFild(
                    press: (p0) {},
                    textInputType: TextInputType.name,
                    text: "Name",
                    obscureText: false,
                  ),
                MyTextFild(
                  press: (email) => this.email = email,
                  textInputType: TextInputType.emailAddress,
                  text: "Email",
                  obscureText: false,
                ),
                if (!login)
                  MyTextFild(
                    press: (p0) {},
                    text: "Phone Number",
                    obscureText: false,
                    textInputType: TextInputType.number,
                  ),
                SizedBox(
                  height: 50,
                  child: MyTextFild(
                    press: (password) => this.password = password,
                    text: "Password",
                    obscureText: true,
                    textInputType: TextInputType.visiblePassword,
                  ),
                ),
                Row(
                  children: [
                    Checkbox.adaptive(
                      checkColor: Colors.black,
                      fillColor: WidgetStatePropertyAll(Colors.black),
                      activeColor: const Color(0xffd2fe55),
                      value: checkbox,
                      onChanged: (value) {
                        setState(() {
                          checkbox = value ?? false;
                        });
                      },
                    ),
                    const Text(
                      "Remember me",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          login = false;
                        });
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgerPassword()));
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    )
                  ],
                ),
                Center(
                  child: isLoading
                      ? const SizedBox(
                          height: 100,
                          child: CircularProgressIndicator.adaptive(
                            backgroundColor: Colors.white,
                          ),
                        )
                      : SizedBox(),
                ),
                if (errorText != null)
                  Text(
                    errorText!,
                    style: const TextStyle(color: Color(0xffd2fe55)),
                  ),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                      errorText = null; // Xato matnini tozalash
                    });
                    try {
                      if (login) {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          password: password,
                          email: email.trim(),
                        );
                      } else {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          password: password,
                          email: email.trim(),
                        );
                      }
                    } on FirebaseAuthException catch (e) {
                      setState(() {
                        print(e.code);
                        if (e.code == 'invalid-email') {
                          errorText = 'Noto‘g‘ri email format';
                        } else if (e.code == 'user-not-found') {
                          errorText = 'Foydalanuvchi topilmadi';
                        } else if (e.code == 'wrong-password') {
                          errorText = 'Parol noto‘g‘ri';
                        } else if (e.code == 'invalid-credential') {
                          errorText = 'Xato email';
                        } else if (e.code == 'weak-password') {
                          errorText = 'Parol kiriting kamida 6 ta belgi ';
                        } else {
                          errorText = 'Xato: ${e.message}';
                        }
                        // invalid-credential
                      });
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    padding: const EdgeInsets.all(15),
                    width: double.infinity,
                    decoration: BoxDecoration(color: const Color(0xffd2fe55)),
                    child: Text(
                      login ? "Login" : "Create account",
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      login
                          ? "Don't have an account?"
                          : "Already have an account?",
                      style: TextStyle(
                          fontSize: 18, color: Colors.white.withOpacity(.7)),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          login = !login;
                        });
                      },
                      child: Text(
                        login ? "Sign up" : "Login",
                        style: const TextStyle(
                            fontSize: 18, color: Color(0xffd2fe55)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.white.withOpacity(.7),
                      ),
                    ),
                    Text(
                      login ? "  Or Login with  " : "  Or Sign up with  ",
                      style: const TextStyle(color: Colors.white, fontSize: 19),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.white.withOpacity(.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SocialMediaIcon(
                      press: () {
                        _handleSignIn();
                      },
                      image: "images/google icon.png",
                      apple: false,
                    ),
                    SocialMediaIcon(
                      press: () {},
                      image: "images/fasebook.png",
                      apple: false,
                    ),
                    SocialMediaIcon(
                      press: () {},
                      image: "images/apple.png",
                      apple: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SocialMediaIcon extends StatelessWidget {
  final String image;
  final bool apple;
  VoidCallback press;

  SocialMediaIcon(
      {super.key,
      required this.image,
      required this.apple,
      required this.press});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        height: MediaQuery.of(context).size.height * .08,
        width: MediaQuery.of(context).size.width * .27,
        decoration: BoxDecoration(
          border: Border.all(width: 0.4, color: Colors.white.withOpacity(.7)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Image.asset(
            image,
            color: apple ? Colors.white : null,
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: Text("data")),
      ),
    );
  }
}
