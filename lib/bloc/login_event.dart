abstract class LoginEvent {}

class IsPasswordVisibleChanged extends LoginEvent {}

class FormSubmitted extends LoginEvent {
  String username;
  String password;

  FormSubmitted({required this.username, required this.password});
}