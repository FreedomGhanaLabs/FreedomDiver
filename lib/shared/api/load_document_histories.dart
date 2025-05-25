import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../feature/documents/cubit/driver_document_cubit.dart';
import '../../feature/documents/models/driver_documents.dart';
import '../../feature/debt_financial_earnings/cubit/finance/financial_cubit.dart';

Future<void> loadDocumentHistories(BuildContext context) async {
  final documentCubit = context.read<DocumentCubit>();
  final financialCubit = context.read<FinancialCubit>();

  await Future.wait([
    documentCubit.getDriverDocumentHistory(
      context,
      documentType: DriverDocumentType.driverLicense.name,
    ),
    documentCubit.getDriverDocumentHistory(
      context,
      documentType: DriverDocumentType.ghanaCard.name,
    ),
    documentCubit.getDriverDocumentHistory(
      context,
      documentType: DriverDocumentType.motorcycleImage.name,
    ),
    documentCubit.getDriverDocumentHistory(
      context,
      documentType: DriverDocumentType.profilePicture.name,
    ),
    documentCubit.getDriverDocumentHistory(
      context,
      documentType: DriverDocumentType.addressProof.name,
    ),
    // financialCubit.getWalletBalance(context),
  ]);
}
