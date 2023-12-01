class ApiClient {
  final String domainName = 'http://10.53.11.169:8000';
  late final String baseUrl;
  ApiClient() {
    baseUrl = '$domainName/api';
  }
}
