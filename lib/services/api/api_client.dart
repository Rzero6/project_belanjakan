class ApiClient {
  final String domainName = '192.168.18.167:8000';
  late final String baseUrl;
  ApiClient() {
    baseUrl = 'http://$domainName/api';
  }
}
