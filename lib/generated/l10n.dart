// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Home`
  String get tab_home {
    return Intl.message('Home', name: 'tab_home', desc: '', args: []);
  }

  /// `Notifications`
  String get tab_notification {
    return Intl.message(
      'Notifications',
      name: 'tab_notification',
      desc: '',
      args: [],
    );
  }

  /// `Billing`
  String get tab_billing {
    return Intl.message('Billing', name: 'tab_billing', desc: '', args: []);
  }

  /// `Profile`
  String get tab_profile {
    return Intl.message('Profile', name: 'tab_profile', desc: '', args: []);
  }

  /// `Notification`
  String get title {
    return Intl.message('Notification', name: 'title', desc: '', args: []);
  }

  /// `Account`
  String get account {
    return Intl.message('Account', name: 'account', desc: '', args: []);
  }

  /// `Contact`
  String get contact {
    return Intl.message('Contact', name: 'contact', desc: '', args: []);
  }

  /// `Address: `
  String get address {
    return Intl.message('Address: ', name: 'address', desc: '', args: []);
  }

  /// `Phone number: `
  String get phone {
    return Intl.message('Phone number: ', name: 'phone', desc: '', args: []);
  }

  /// `2nd Floor, Building No. 19-21 Tan Cang, Thanh My Tay Ward, Ho Chi Minh City`
  String get info_address {
    return Intl.message(
      '2nd Floor, Building No. 19-21 Tan Cang, Thanh My Tay Ward, Ho Chi Minh City',
      name: 'info_address',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get change_password {
    return Intl.message(
      'Change password',
      name: 'change_password',
      desc: '',
      args: [],
    );
  }

  /// `Sign out`
  String get sign_out {
    return Intl.message('Sign out', name: 'sign_out', desc: '', args: []);
  }

  /// `Delete account`
  String get delete_account {
    return Intl.message(
      'Delete account',
      name: 'delete_account',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to sign out?`
  String get confirm_sign_out {
    return Intl.message(
      'Are you sure you want to sign out?',
      name: 'confirm_sign_out',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your account?`
  String get confirm_delete_account {
    return Intl.message(
      'Are you sure you want to delete your account?',
      name: 'confirm_delete_account',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Confirm password`
  String get confirm_password {
    return Intl.message(
      'Confirm password',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Forgot password`
  String get forgot_password {
    return Intl.message(
      'Forgot password',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Dont have an account? `
  String get dont_have_account {
    return Intl.message(
      'Dont have an account? ',
      name: 'dont_have_account',
      desc: '',
      args: [],
    );
  }

  /// `You have an account? `
  String get you_have_account {
    return Intl.message(
      'You have an account? ',
      name: 'you_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signup {
    return Intl.message('Sign up', name: 'signup', desc: '', args: []);
  }

  /// `Or login with`
  String get or_login_with {
    return Intl.message(
      'Or login with',
      name: 'or_login_with',
      desc: '',
      args: [],
    );
  }

  /// `Apple Id`
  String get apple_id {
    return Intl.message('Apple Id', name: 'apple_id', desc: '', args: []);
  }

  /// `Google`
  String get google {
    return Intl.message('Google', name: 'google', desc: '', args: []);
  }

  /// `Facebook`
  String get facebook {
    return Intl.message('Facebook', name: 'facebook', desc: '', args: []);
  }

  /// `Full name`
  String get full_name {
    return Intl.message('Full name', name: 'full_name', desc: '', args: []);
  }

  /// `Continue`
  String get txt_continue {
    return Intl.message('Continue', name: 'txt_continue', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Privacy Policies`
  String get privacy_policies {
    return Intl.message(
      'Privacy Policies',
      name: 'privacy_policies',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Service`
  String get terms_of_service {
    return Intl.message(
      'Terms of Service',
      name: 'terms_of_service',
      desc: '',
      args: [],
    );
  }

  /// `Your session has expired. Please log in again.`
  String get error_session_expired {
    return Intl.message(
      'Your session has expired. Please log in again.',
      name: 'error_session_expired',
      desc: '',
      args: [],
    );
  }

  /// `You do not have permission to perform this action.`
  String get error_permission_denied {
    return Intl.message(
      'You do not have permission to perform this action.',
      name: 'error_permission_denied',
      desc: '',
      args: [],
    );
  }

  /// `Requested data not found.`
  String get error_not_found {
    return Intl.message(
      'Requested data not found.',
      name: 'error_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Invalid data.`
  String get error_invalid_data {
    return Intl.message(
      'Invalid data.',
      name: 'error_invalid_data',
      desc: '',
      args: [],
    );
  }

  /// `Server error. Please try again later.`
  String get error_server {
    return Intl.message(
      'Server error. Please try again later.',
      name: 'error_server',
      desc: '',
      args: [],
    );
  }

  /// `Connection to the server timed out. Please check your network connection.`
  String get error_connection_timeout {
    return Intl.message(
      'Connection to the server timed out. Please check your network connection.',
      name: 'error_connection_timeout',
      desc: '',
      args: [],
    );
  }

  /// `Receiving data timed out. Please try again later.`
  String get error_receive_timeout {
    return Intl.message(
      'Receiving data timed out. Please try again later.',
      name: 'error_receive_timeout',
      desc: '',
      args: [],
    );
  }

  /// `Sending data timed out. Please try again later.`
  String get error_send_timeout {
    return Intl.message(
      'Sending data timed out. Please try again later.',
      name: 'error_send_timeout',
      desc: '',
      args: [],
    );
  }

  /// `The request was cancelled.`
  String get error_request_cancelled {
    return Intl.message(
      'The request was cancelled.',
      name: 'error_request_cancelled',
      desc: '',
      args: [],
    );
  }

  /// `Cannot connect to the server. Please check your network connection.`
  String get error_network_unreachable {
    return Intl.message(
      'Cannot connect to the server. Please check your network connection.',
      name: 'error_network_unreachable',
      desc: '',
      args: [],
    );
  }

  /// `An unknown error has occurred.`
  String get error_unknown {
    return Intl.message(
      'An unknown error has occurred.',
      name: 'error_unknown',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect password.`
  String get error_incorrect_password {
    return Intl.message(
      'Incorrect password.',
      name: 'error_incorrect_password',
      desc: '',
      args: [],
    );
  }

  /// `Account does not exist.`
  String get error_not_found_account {
    return Intl.message(
      'Account does not exist.',
      name: 'error_not_found_account',
      desc: '',
      args: [],
    );
  }

  /// `This phone number is already registered.`
  String get error_phone_number_already_registered {
    return Intl.message(
      'This phone number is already registered.',
      name: 'error_phone_number_already_registered',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters long.`
  String get error_too_short_password {
    return Intl.message(
      'Password must be at least 6 characters long.',
      name: 'error_too_short_password',
      desc: '',
      args: [],
    );
  }

  /// `An error has occurred. Please try again later.`
  String get error_occurred {
    return Intl.message(
      'An error has occurred. Please try again later.',
      name: 'error_occurred',
      desc: '',
      args: [],
    );
  }

  /// `Please check your internet connection.`
  String get no_connect_internet {
    return Intl.message(
      'Please check your internet connection.',
      name: 'no_connect_internet',
      desc: '',
      args: [],
    );
  }

  /// `Update Information`
  String get title_update_app {
    return Intl.message(
      'Update Information',
      name: 'title_update_app',
      desc: '',
      args: [],
    );
  }

  /// `A new version ({ver}) of the app is available. Please update to continue using it.`
  String mgs_update_app(Object ver) {
    return Intl.message(
      'A new version ($ver) of the app is available. Please update to continue using it.',
      name: 'mgs_update_app',
      desc: '',
      args: [ver],
    );
  }

  /// `Update Now`
  String get btn_update {
    return Intl.message('Update Now', name: 'btn_update', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ko'),
      Locale.fromSubtags(languageCode: 'vi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
