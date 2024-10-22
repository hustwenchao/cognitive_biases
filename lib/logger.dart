import 'package:logger/logger.dart';

final Logger logger = Logger(
  filter: bool.fromEnvironment('dart.vm.product')
      ? ProductionFilter()
      : DevelopmentFilter(),
  printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.dateAndTime),
);
