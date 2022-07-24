import 'package:choresreminder/addChore/addChore.dart';
import 'package:choresreminder/updateChore/updateChore.dart';

import 'home/home.dart';

var appRoutes = {
  '/': (context) => const Home(),
  '/add': (context) => AddChore(),
  '/update': (context) => UpdateChore(),
};
