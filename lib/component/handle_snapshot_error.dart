import 'package:flutter/cupertino.dart';

Widget? handleSnapShotError(AsyncSnapshot snapshot) {
  if (snapshot.hasError) return const Text("Something Went Wrong");
  if (snapshot.connectionState == ConnectionState.waiting) return const CupertinoActivityIndicator.partiallyRevealed();
  if (!snapshot.hasData || snapshot.data!.isEmpty) return const Text("No data available");
  return null;
}
