import 'package:another_flushbar/flushbar_helper.dart';
import 'package:boilerplate/constants/assets.dart';
import 'package:boilerplate/data/sharedpref/constants/preferences.dart';
import 'package:boilerplate/models/user/user.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/utils/routes/routes.dart';
import 'package:boilerplate/stores/form/form_store.dart';
import 'package:boilerplate/stores/theme/theme_store.dart';
import 'package:boilerplate/utils/device/device_utils.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/app_icon_widget.dart';
import 'package:boilerplate/widgets/empty_app_bar_widget.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:boilerplate/widgets/rounded_button_widget.dart';
import 'package:boilerplate/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class UpdateUserScreen extends StatefulWidget {
  @override
  _UpdateUserScreenState createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  //text controllers:-----------------------------------------------------------
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _phonenumberController = TextEditingController();

  //stores:---------------------------------------------------------------------
  late ThemeStore _themeStore;

  //focus node:-----------------------------------------------------------------
  late FocusNode _firstNameFocusNode;
  late FocusNode _lastNameFocusNode;
  late FocusNode _phoneNumberFocusNode;

  //stores:---------------------------------------------------------------------
  final _store = FormStore();
  late UserStore _userStore;

  @override
  void initState() {
    super.initState();
    _firstNameFocusNode = FocusNode();
    _lastNameFocusNode = FocusNode();
    _phoneNumberFocusNode = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeStore = Provider.of<ThemeStore>(context);
    _userStore = Provider.of<UserStore>(context);

    // check to see if already called api
    if (!_userStore.loading) {
      _userStore.getUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      appBar: EmptyAppBar(),
      body: _buildBody(),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Observer(
      builder: (context) {
        return _userStore.loading
            ? CustomProgressIndicatorWidget()
            : Material(
                child: Stack(
                  children: <Widget>[
                    MediaQuery.of(context).orientation == Orientation.landscape
                        ? Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: _buildLeftSide(),
                              ),
                              Expanded(
                                flex: 1,
                                child: _buildRightSide(),
                              ),
                            ],
                          )
                        : Center(child: _buildRightSide()),
                    Observer(
                      builder: (context) {
                        return _store.success
                            ? navigate(context)
                            : _showErrorMessage(_store.errorStore.errorMessage);
                      },
                    ),
                  ],
                ),
              );
      },
    );
  }

  Widget _buildLeftSide() {
    return SizedBox.expand(
      child: Image.asset(
        Assets.carBackground,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildRightSide() {
    _firstnameController.text = _userStore.user!.firstName!;
    _lastnameController.text = _userStore.user!.lastName!;
    _phonenumberController.text = _userStore.user!.phoneNumber!;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AppIconWidget(image: 'assets/icons/ic_appicon.png'),
            SizedBox(height: 24.0),
            _buildFirstNameField(),
            _buildLastNameField(),
            _buildPhoneNumberField(),
            _buildUpdateUserButton()
          ],
        ),
      ),
    );
  }

  Widget _buildFirstNameField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          hint:
              AppLocalizations.of(context).translate('register_et_first_name'),
          padding: EdgeInsets.only(top: 16.0),
          icon: Icons.person,
          iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
          textController: _firstnameController,
          focusNode: _firstNameFocusNode,
          inputAction: TextInputAction.next,
          onChanged: (value) {
            _store.setFirstName(_firstnameController.text);
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_lastNameFocusNode);
          },
          errorText: '',
        );
      },
    );
  }

  Widget _buildLastNameField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          hint: AppLocalizations.of(context).translate('register_et_last_name'),
          padding: EdgeInsets.only(top: 16.0),
          icon: Icons.person,
          iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
          textController: _lastnameController,
          focusNode: _lastNameFocusNode,
          inputAction: TextInputAction.next,
          onChanged: (value) {
            _store.setLastName(_lastnameController.text);
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_phoneNumberFocusNode);

            User.instance.lastName = value;
          },
          errorText: '',
        );
      },
    );
  }

  Widget _buildPhoneNumberField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          hint: AppLocalizations.of(context)
              .translate('register_et_phone_number'),
          padding: EdgeInsets.only(top: 16.0),
          icon: Icons.phone,
          iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
          textController: _phonenumberController,
          errorText: _store.formErrorStore.phoneNumber,
          focusNode: _phoneNumberFocusNode,
          inputAction: TextInputAction.next,
          onChanged: (value) {
            _store.setPhoneNumber(_phonenumberController.text);
          },
        );
      },
    );
  }

  Widget _buildUpdateUserButton() {
    return RoundedButtonWidget(
      buttonText:
          AppLocalizations.of(context).translate('register_btn_update_user'),
      buttonColor: Colors.orangeAccent,
      textColor: Colors.white,
      onPressed: () async {
        if (_store.canRegister) {
          DeviceUtils.hideKeyboard(context);
          _store.signup(context);
        } else {
          _showErrorMessage('Please fill in all fields');
        }
      },
    );
  }

  Widget navigate(BuildContext context) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(Preferences.is_logged_in, true);
    });

    Future.delayed(Duration(milliseconds: 0), () {
      Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.home, (Route<dynamic> route) => false);
    });

    return Container();
  }

  // General Methods:-----------------------------------------------------------
  _showErrorMessage(String message) {
    if (message.isNotEmpty) {
      Future.delayed(Duration(milliseconds: 0), () {
        if (message.isNotEmpty) {
          FlushbarHelper.createError(
            message: message,
            title: AppLocalizations.of(context).translate('home_tv_error'),
            duration: Duration(seconds: 3),
          )..show(context);
        }
      });
    }

    return SizedBox.shrink();
  }

  // dispose:-------------------------------------------------------------------
  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _firstnameController.dispose();
    _lastnameController.dispose();
    _phonenumberController.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }
}
