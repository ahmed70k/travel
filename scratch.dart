import 'dart:convert';
import 'dart:io';

void main() async {
  final url = Uri.parse('https://office10.runasp.net/api/bookings/my');
  final token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJiMmM0OGY0MS0zYTljLTQxM2EtOTg4NS1hNTgzYTE4MjJlZTEiLCJyb2xlIjoiYjJjIiwiZW1haWwiOiJzaGFoZG1hcndhbkBlbWFpbC5jb20iLCJpYXQiOjE3NzgzMDg3MTMsImV4cCI6MTc3ODkxMzUxM30.usi_bMLywkMjTp8n0yCZL36AimGAJ4gd9gKPd7whEK4';
  
  final request = await HttpClient().getUrl(url);
  request.headers.add('Authorization', 'Bearer $token');
  request.headers.add('Accept', 'application/json');
  
  final response = await request.close();
  final stringData = await response.transform(utf8.decoder).join();
  final json = jsonDecode(stringData);
  print(jsonEncode(json['data']['cars']));
}
