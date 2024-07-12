// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_page_cubit.dart';

abstract class HomePageState extends Equatable {
  const HomePageState();

  @override
  List<Object> get props => [];
}

class HomePageInitial extends HomePageState {}

class HomePageLoading extends HomePageState {}

class HomePageLoaded extends HomePageState {
  const HomePageLoaded();
}

class HomePageFailure extends HomePageState {
  final String errorMessage;
  const HomePageFailure({
    required this.errorMessage,
  });
}
