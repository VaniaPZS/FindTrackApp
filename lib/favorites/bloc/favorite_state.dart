part of 'favorite_bloc.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteSuccessState extends FavoriteState {}

class FavoriteErrorState extends FavoriteState {
  final String error;

  FavoriteErrorState({required this.error});
}

class DeleteFavoriteSuccessState extends FavoriteState {}

class DeleteFavoriteErrorState extends FavoriteState {
  final String error;

  DeleteFavoriteErrorState({required this.error});
}

