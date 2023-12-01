class ApiClient {
  final String domainName = '192.168.18.167';
  late final String baseUrl;
  ApiClient() {
    baseUrl = 'http://$domainName:8000/api';
  }
}
