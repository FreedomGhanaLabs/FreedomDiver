import 'package:equatable/equatable.dart';

abstract class DocumentUploadState extends Equatable {
  const DocumentUploadState();

  @override
  List<Object?> get props => [];
}

class DocumentUploadInitial extends DocumentUploadState {}

class DocumentUploadLoading extends DocumentUploadState {}

class DocumentUploadSuccess extends DocumentUploadState {}

class DocumentUploadError extends DocumentUploadState {
  const DocumentUploadError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

