import 'package:choresreminder/addChore/addChore.dart';

import 'home/home.dart';

var appRoutes = {
  '/': (context) => const Home(),
  '/add': (context) => AddChore(),
};
