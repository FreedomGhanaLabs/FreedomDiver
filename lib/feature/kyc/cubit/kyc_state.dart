part of 'kyc_cubit.dart';

abstract class KycState {}

class KycInitial extends KycState {}
class KycImageLoading extends KycState {}
class KycImageSelected extends KycState {
  KycImageSelected(this.image);
  final File image;
}
class KycImageUploadLoading extends KycState {
  KycImageUploadLoading(this.image);
  final File image;
}
class KycImageUploadSuccess extends KycState {
  KycImageUploadSuccess(this.imageUrl, this.image);
  final String imageUrl;
  final File image;
}
class KycImageUploadFailure extends KycState {
  KycImageUploadFailure(this.error, this.image);
  final String error;
  final File image;
}
class KycImagePickFailure extends KycState {
  KycImagePickFailure(this.error);
  final String error;
}