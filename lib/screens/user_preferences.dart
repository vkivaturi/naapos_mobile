import 'package:flutter/material.dart';
import 'package:naapos/utils/utils.dart';

//User prefereces are stored using this screen. These are saved at app level and will be available untill the app is unintalled
class UserPreferences extends StatefulWidget {
  UserPreferences({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _UserPreferencesState createState() => _UserPreferencesState();
}

class _UserPreferencesState extends State<UserPreferences> {
  final operatorIdController = TextEditingController();
  final storeIdController = TextEditingController();
  final emailController = TextEditingController();

  String emailIdPreference, operatorIdPreference, storeIdPreference;

  final _formKey = GlobalKey<FormState>();

  Future getDataFromPreferences() async {
    emailIdPreference =
    await HelperMethods.getUserPreferences(Constants.emailId);
    emailIdPreference != null
        ? emailController.text = emailIdPreference
        : emailController.text = "";

    operatorIdPreference =
    await HelperMethods.getUserPreferences(Constants.operatorId);
    operatorIdPreference != null
        ? operatorIdController.text = operatorIdPreference
        : operatorIdController.text = "";

    storeIdPreference =
    await HelperMethods.getUserPreferences(Constants.storeId);
    storeIdPreference != null
        ? storeIdController.text = storeIdPreference
        : storeIdController.text = "";

  }

  @override
  void initState() {
    getDataFromPreferences();
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    operatorIdController.dispose();
    storeIdController.dispose();
    emailController.dispose();

    super.dispose();
  }

  //This is the main build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "User preferences",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30.0, color: Colors.pink),
          ),
          //backgroundColor: Color.fromRGBO(49, 87, 110, 1.0),
        ),
        body: SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(),
                child: Builder(
                  //Added this builder only to make snackbar work
                  builder: (context) => Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Divider(
                            height: 2.0,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: 35.0,
                          ),
                          new TextFormField(
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Please enter a valid email address';
                              } else
                                return null;
                            },
                            decoration: new InputDecoration(
                              labelText: "Email address",
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.email),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                          ),
                          SizedBox(
                            height: 35.0,
                          ),
                          new TextFormField(
                            validator: (String value) {
                              //Validate that start date is not greater that end date
                              if (value.isEmpty) {
                                return 'Please enter a valid operator id';
                              } else {
                                return null;
                              }
                            },
                            decoration: new InputDecoration(
                                labelText: "Operator id",
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.person)),
                            keyboardType: TextInputType.text,
                            controller: operatorIdController,
                          ),
                          SizedBox(
                            height: 35.0,
                          ),
                          new TextFormField(
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Please enter a valid date';
                              } else
                                return null;
                            },
                            decoration: new InputDecoration(
                                labelText: "Store id",
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.store)),
                            keyboardType: TextInputType.text,
                            controller: storeIdController,
                          ),
                          SizedBox(
                            height: 35.0,
                          ),
                          ButtonTheme(
                              minWidth: MediaQuery.of(context).size.width,
                              child: RaisedButton(
                                  padding: const EdgeInsets.all(12.0),
                                  textColor: Colors.white,
                                  color: Colors.blue,
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {

                                      //Save preferences
                                      HelperMethods.saveUserPreferences(Constants.operatorId, operatorIdController.text);
                                      HelperMethods.saveUserPreferences(Constants.storeId, storeIdController.text);
                                      HelperMethods.saveUserPreferences(Constants.emailId, emailController.text);

                                      HelperMethods.showMessage(
                                          context,
                                          Colors.green,
                                          "User preferences are saved");
                                    } else {
                                      // If the form is valid, display a Snackbar.
                                      HelperMethods.showMessage(
                                          context,
                                          Colors.deepOrange,
                                          "There are errors in your input data. Please correct them");
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.save),
                                      Text('   Save preferences',
                                          style: TextStyle(fontSize: 25))
                                    ],
                                  ))),
                        ],
                      )),
                ))));
  }
}
