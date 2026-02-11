import 'package:flutter/material.dart';
import '../errors/api_error.dart';

String handleApiError(BuildContext context, Object error, {VoidCallback? onUnauthorized}) {
  final api = ApiError.from(error);
  final status = api.statusCode;

  if (status == 401) {
    if (onUnauthorized != null) onUnauthorized();
    return 'Unauthorized';
  }
  if (status == 403) {
    return 'Forbidden';
  }
  if (status == 400 || status == 409) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(api.message)),
      );
    });
    return api.message;
  }

  return api.message;
}
