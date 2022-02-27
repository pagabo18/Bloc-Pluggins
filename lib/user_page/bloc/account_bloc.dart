import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:io';
import 'dart:convert';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(AccountInitial()) {
    on<AccountEvent>(call);
  }
  String api =
      "https://api.sheety.co/a2c27a5703f93ff75370b7cd6ed53446/dummyApi/hoja1";

  void call(AccountEvent event, Emitter emmiter) async {
    var dataMap = await _getData();
    if (dataMap == null) {
      emmiter(AccountError(error: "No data found"));
    } else {
      emmiter(AccountSuccess(data: dataMap));
    }
  }

  Future _getData() async {
    try {
      Response res = await get(Uri.parse(api));
      if (res.statusCode == HttpStatus.ok) {
        return jsonDecode(res.body);
      }
    } catch (error) {
      print(error);
    }
  }
}
