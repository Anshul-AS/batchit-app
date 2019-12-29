//Basic methods for adding new user to our
//firsebase auuth db and directing it to home page
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuth _auth =FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey= GlobalKey<FormState>();

  String _name, _email, _password;

  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user){
      if(user != null){
        Navigator.pushReplacementNamed(context, "/");
      }
    });
  }
  navigateToSigninScreen(){
    Navigator.pushReplacementNamed(context, "/SigninPage");
  }
  @override
  void initState(){
    super.initState();
    this.checkAuthentication();
  }
//signing up of user method
  signup() async {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();

      try {
        AuthResult result = await _auth.createUserWithEmailAndPassword(email:
        _email,password: _password);
        FirebaseUser user = result.user;

        if (user != null){
          UserUpdateInfo updateuser = UserUpdateInfo();
          updateuser.displayName = _name;
          user.updateProfile(updateuser);
        }

      } catch (e) {
        showError(e.message);
      }
    }
  }

  showError(String errorMessage){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Container(
        child: Center(
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 50.0),
                child: Image(image: AssetImage("assets/logo.png"),
                width: 100.0,
                height: 100.0,
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 20.0),
                        child: TextFormField(
                          validator: (input) {
                            if(input.isEmpty){
                              return "Provide a name";
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )
                          ),
                          onSaved: (input) => _name = input,
                        ),
                      ),
                      //email
                      
                      Container(
                        padding: EdgeInsets.only(top: 20.0),
                        child: TextFormField(
                          validator: (input) {
                            if(input.isEmpty){
                              return "Provide an email";
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )
                          ),
                          onSaved: (input) => _email = input,
                        ),
                      ),
                      //password
                      Container(
                        padding: EdgeInsets.only(top: 20.0),
                        child: TextFormField(
                          validator: (input) {
                            if(input.length < 6){
                              return "Password should be 6 char atleast";
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )
                          ),
                          onSaved: (input) => _password = input,
                          obscureText: true,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0,20.0,0,20.0),
                        child: RaisedButton(
                          padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
                          color: Colors.lightBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          onPressed: signup,
                          child: Text('Sign Up',
                            style: TextStyle(
                              color: Colors.white,fontSize: 20.0,
                            ),),
                        )
                      ),
                      //redirect to signup page
                      GestureDetector(
                        onTap: navigateToSigninScreen,
                        child: Text(
                          'Already have an account',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16.0,color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}