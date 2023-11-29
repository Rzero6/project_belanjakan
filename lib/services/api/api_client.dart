class ApiClient {
  final String domainName = '192.168.1.3';
  late final String baseUrl;
  ApiClient() {
    baseUrl = 'http://$domainName:8000/api';
  }
}
