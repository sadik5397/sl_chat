import 'package:flutter/cupertino.dart';

Widget? handleSnapShotError(AsyncSnapshot snapshot) {
  if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}', textAlign: TextAlign.center,));
  if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CupertinoActivityIndicator.partiallyRevealed());
  if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("No data available"));
  return null;
}
