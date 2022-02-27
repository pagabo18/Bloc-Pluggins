part of 'account_bloc.dart';

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object> get props => [];
}

class AccountInitial extends AccountState {}

class AccountError extends AccountState {
  final String error;
  AccountError({required this.error});
  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class AccountSuccess extends AccountState {
  final Map data;
  AccountSuccess({required this.data});
  @override
  // TODO: implement props
  List<Object> get props => [];
}
