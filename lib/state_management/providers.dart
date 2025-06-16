// 所有的provider都統一在這裡管理

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../controllers/auth_controller.dart';

final List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider<AuthController>(create: (_) => AuthController()),
];