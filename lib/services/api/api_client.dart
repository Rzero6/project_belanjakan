class ApiClient {
  final String domainName = '10.53.3.91';
  late final String baseUrl;
  ApiClient() {
    baseUrl = 'http://$domainName:8000/api';
  }
}
