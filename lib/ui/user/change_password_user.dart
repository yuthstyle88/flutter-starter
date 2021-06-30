import 'package:another_flushbar/flushbar_helper.dart';
import 'package:boilerplate/constants/assets.dart';
import 'package:boilerplate/data/sharedpref/constants/preferences.dart';
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

class ChangePasswordUserScreen extends StatefulWidget {
  @override
  _ChangePasswordUserScreenState createState() => _ChangePasswordUserScreenState();
}

class _ChangePasswordUserScreenState extends State<ChangePasswordUserScreen> {
  //text controllers:-----------------------------------------------------------
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  //stores:---------------------------------------------------------------------
  late ThemeStore _themeStore;

  //focus node:-----------------------------------------------------------------
  late FocusNode _oldPasswordFocusNode;
  late FocusNode _newPasswordFocusNode;
  late FocusNode _confirmPasswordFocusNode;

  //stores:---------------------------------------------------------------------
  final _store = FormStore();

  @override
  void initState() {
    super.initState();
    _oldPasswordFocusNode = FocusNode();
    _newPasswordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeStore = Provider.of<ThemeStore>(context);
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
    return Material(
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
          Observer(
            builder: (context) {
              return Visibility(
                visible: _store.loading,
                child: CustomProgressIndicatorWidget(),
              );
            },
          )
        ],
      ),
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
            _buildOldPasswordField(),
            _buildNewPasswordField(),
            _buildConfirmPasswordField(),
            _buildSaveButton()
          ],
        ),
      ),
    );
  }

  Widget _buildOldPasswordField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          hint: AppLocalizations.of(context).translate('enter_your_old_password'),
          isObscure: true,
          padding: EdgeInsets.only(top: 16.0),
          icon: Icons.lock,
          iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
          textController: _oldPasswordController,
          errorText: _store.formErrorStore.password,
          focusNode: _oldPasswordFocusNode,
          inputAction: TextInputAction.next,
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
          },
          onChanged: (value) {
            _store.setPassword(_oldPasswordController.text);
          },
        );
      },
    );
  }

  Widget _buildNewPasswordField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          hint: AppLocalizations.of(context).translate('enter_your_new_password'),
          isObscure: true,
          padding: EdgeInsets.only(top: 16.0),
          icon: Icons.lock,
          iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
          textController: _newPasswordController,
          errorText: _store.formErrorStore.password,
          focusNode: _newPasswordFocusNode,
          inputAction: TextInputAction.next,
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
          },
          onChanged: (value) {
            _store.setPassword(_newPasswordController.text);
          },
        );
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          hint: AppLocalizations.of(context)
              .translate('enter_confirm_password'),
          isObscure: true,
          padding: EdgeInsets.only(top: 16.0),
          icon: Icons.lock,
          iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
          textController: _confirmPasswordController,
          focusNode: _confirmPasswordFocusNode,
          errorText: _store.formErrorStore.confirmPassword,
          onChanged: (value) {
            _store.setConfirmPassword(_confirmPasswordController.text);
          },
        );
      },
    );
  }

  Widget _buildSaveButton() {
    return RoundedButtonWidget(
      buttonText:
      AppLocalizations.of(context).translate('ok'),
      buttonColor: Colors.orangeAccent,
      textColor: Colors.white,
      onPressed: () async {
        if (_store.canChangPassword) {
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
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();

    _oldPasswordFocusNode.dispose();
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }
}
