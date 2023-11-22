class ApiClient {
  final String domainName = '10.53.9.58';
  late final String baseUrl;
  ApiClient() {
    baseUrl = 'http://$domainName:7000/api';
  }
}
