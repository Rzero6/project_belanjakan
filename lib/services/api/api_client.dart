class ApiClient {
  final String domainName = '172.16.59.35';
  late final String baseUrl;
  ApiClient() {
    baseUrl = 'http://$domainName:8000/api';
  }
}
