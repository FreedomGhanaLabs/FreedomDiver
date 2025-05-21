import 'package:equatable/equatable.dart';

abstract class DocumentUploadState extends Equatable {
  const DocumentUploadState();

  @override
  List<Object?> get props => [];
}

class DocumentUploadInitial extends DocumentUploadState {}

class DocumentLoading extends DocumentUploadState {}

class DocumentSuccess extends DocumentUploadState {}

class DocumentError extends DocumentUploadState {
  const DocumentError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

