import 'package:equatable/equatable.dart';
import 'package:freedomdriver/feature/documents/models/driver_documents.dart';

abstract class DocumentState extends Equatable {
  const DocumentState();

  @override
  List<Object?> get props => [];
}

class DocumentInitial extends DocumentState {}

class DocumentLoading extends DocumentState {}

class DocumentSuccess extends DocumentState {}

class DocumentLoaded extends DocumentState {
  const DocumentLoaded(this.driver);
  final DriverDocument driver;

  @override
  List<Object?> get props => [driver];
}

class DocumentError extends DocumentState {
  const DocumentError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

