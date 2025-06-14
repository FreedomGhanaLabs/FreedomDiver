import 'package:dio/dio.dart';

import 'package:freedomdriver/feature/debt_financial_earnings/models/bank.dart';

class BankService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.paystack.co'));

  Future<List<Bank>> getGhanaBanks() async {
    final response = await _dio.get('/bank?country=ghana');
    final List data = response.data['data'];
    return data.map((json) => Bank.fromJson(json)).toList();
  }
}
