import 'package:flutter/material.dart';
import 'package:flutter_localization/custom_text_field.dart';
import 'package:flutter_localization/localization/app_translations.dart';
import 'package:flutter_localization/localization/application.dart';

class SignUpUI extends StatefulWidget {
  @override
  _SignUpScreenState createState() => new _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpUI> {
  static final List<String> languagesList = application.supportedLanguages;
  static final List<String> languageCodesList =
      application.supportedLanguagesCodes;

  final Map<dynamic, dynamic> languagesMap = {
    languagesList[0]: languageCodesList[0],
    languagesList[1]: languageCodesList[1],
  };

  String label = languagesList[0];

  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  final teFirstName = TextEditingController();
  final teLastName = TextEditingController();
  final teEmail = TextEditingController();
  final tePassword = TextEditingController();

  FocusNode _focusNodeFirstName = new FocusNode();
  FocusNode _focusNodeLastName = new FocusNode();
  FocusNode _focusNodeEmail = new FocusNode();
  FocusNode _focusNodePass = new FocusNode();

  @override
  void initState() {
    super.initState();
    application.onLocaleChanged = onLocaleChange;
    onLocaleChange(Locale(languagesMap["Hindi"]));
  }

  void onLocaleChange(Locale locale) async {
    setState(() {
      AppTranslations.load(locale);
    });
  }

  @override
  void dispose() {
    teFirstName.dispose();
    teLastName.dispose();
    teEmail.dispose();
    tePassword.dispose();
    super.dispose();
  }

  void _select(String language) {
    print("dd "+language);
    onLocaleChange(Locale(languagesMap[language]));
    setState(() {
      if (language == "Hindi") {
        label = "हिंदी";
      } else {
        label = language;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var signUpForm = new Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new Container(
          alignment: FractionalOffset.center,
          margin: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
          padding: EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 10.0),
          decoration: new BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 1.0),
            border: Border.all(color: const Color(0x33A6A6A6)),
            borderRadius: new BorderRadius.all(const Radius.circular(6.0)),
          ),
          child: new Form(
            key: formKey,
            child: new Column(
              children: <Widget>[
                new CustomTextField(
                  inputBoxController: teFirstName,
                  focusNod: _focusNodeFirstName,
                  textSize: 12.0,
                  textFont: "Nexa_Bold",
                ).textFieldWithOutPrefix(
                    AppTranslations.of(context).text("key_first_name"),
                    AppTranslations.of(context).text("key_enter_first_name")),
                new CustomTextField(
                  inputBoxController: teLastName,
                  focusNod: _focusNodeLastName,
                  textSize: 12.0,
                  margin: EdgeInsets.only(top: 20.0),
                  textFont: "Nexa_Bold",
                ).textFieldWithOutPrefix(
                    AppTranslations.of(context).text("key_last_name"),
                    AppTranslations.of(context).text("key_enter_last_name")),
                new CustomTextField(
                  inputBoxController: teEmail,
                  focusNod: _focusNodeEmail,
                  textSize: 12.0,
                  margin: EdgeInsets.only(top: 20.0),
                  textFont: "Nexa_Bold",
                ).textFieldWithOutPrefix(
                    AppTranslations.of(context).text("key_email"),
                    AppTranslations.of(context)
                        .text("key_please_enter_valid_email")),
                new CustomTextField(
                  inputBoxController: tePassword,
                  focusNod: _focusNodePass,
                  textSize: 12.0,
                  isPassword: true,
                  margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  textFont: "Nexa_Bold",
                ).textFieldWithOutPrefix(
                    AppTranslations.of(context).text("key_password"),
                    AppTranslations.of(context)
                        .text("key_must_be_at_least_6_characters")),
              ],
            ),
          ),
        ),
        new Container(
          margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: buttonWithColorBg(
              AppTranslations.of(context).text("key_next"),
              EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
              const Color(0xFFFFD900),
              const Color(0xFF28324E)),
        ),
      ],
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primaryColor: const Color(0xFF02BB9F),
        primaryColorDark: const Color(0xFF167F67),
        accentColor: const Color(0xFF167F67),
      ),
      home: new Scaffold(
        backgroundColor: const Color(0xFFF1F1EF),
        appBar: new AppBar(
          title: new Text(
            label,
            style: new TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            PopupMenuButton<String>(
              // overflow menu
              onSelected: _select,
              icon: new Icon(Icons.language, color: Colors.white),
              itemBuilder: (BuildContext context) {
                return languagesList
                    .map<PopupMenuItem<String>>((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        key: scaffoldKey,
        body: new Container(
          child: new SingleChildScrollView(
            child: new Center(
              child: signUpForm,
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonWithColorBg(
      String buttonLabel, EdgeInsets margin, Color bgColor, Color textColor) {
    var loginBtn = new Container(
      margin: margin,
      padding: EdgeInsets.all(15.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: bgColor,
        borderRadius: new BorderRadius.all(const Radius.circular(6.0)),
      ),
      child: Text(
        buttonLabel,
        style: new TextStyle(
            color: textColor, fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
    return loginBtn;
  }
}
