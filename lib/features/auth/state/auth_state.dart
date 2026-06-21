import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordVisibilityNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

final loginPasswordVisibleProvider = NotifierProvider<PasswordVisibilityNotifier, bool>(PasswordVisibilityNotifier.new);
final registerPasswordVisibleProvider = NotifierProvider<PasswordVisibilityNotifier, bool>(PasswordVisibilityNotifier.new);
final registerConfirmVisibleProvider = NotifierProvider<PasswordVisibilityNotifier, bool>(PasswordVisibilityNotifier.new);

class TermsAcceptedNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

final termsAcceptedProvider = NotifierProvider<TermsAcceptedNotifier, bool>(TermsAcceptedNotifier.new);
