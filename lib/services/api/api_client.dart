class ApiClient {
  final String domainName = 'http://10.53.4.50:8000';
  late final String baseUrl;
  ApiClient() {
    baseUrl = '$domainName/api';
  }
}
