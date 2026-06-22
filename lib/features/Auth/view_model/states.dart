abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoginLoading extends AuthState {}

class AuthLoginSuccess extends AuthState {
  final String message;
  AuthLoginSuccess(this.message);
}

class AuthLoginError extends AuthState {
  final String error;
  AuthLoginError(this.error);
}

class AuthRegisterLoading extends AuthState {}

class AuthRegisterSuccess extends AuthState {
  final String message;
  AuthRegisterSuccess(this.message);
}

class AuthRegisterError extends AuthState {
  final String error;
  AuthRegisterError(this.error);
}