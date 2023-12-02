class ApiClient {
  final String domainName = 'http://172.16.65.98:8000';
  late final String baseUrl;
  ApiClient() {
    baseUrl = '$domainName/api';
  }
}
