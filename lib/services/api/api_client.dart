class ApiClient {
  final String domainName = 'http://20.243.138.216:8000';
  late final String baseUrl;
  ApiClient() {
    baseUrl = '$domainName/api';
  }
}
