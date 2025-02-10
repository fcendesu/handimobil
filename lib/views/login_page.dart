import 'package:flutter/material.dart';
import 'package:handimobil/views/widgets/input_widget.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var size    = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:30,),
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Login Page',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 30),
                InputWidget(
                  hintText: 'Email',
                  controller: emailController,
                  obscureText: false,
                ),
                SizedBox(height: 30),
                InputWidget(
                  hintText: 'Password',
                  controller: passwordController,
                  obscureText: true,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    print(emailController.text);
                    print(passwordController.text);
                  },
                  child: Text('Login',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                  ),

              ]
          ),
        ),
      ),
    );
  }
}


