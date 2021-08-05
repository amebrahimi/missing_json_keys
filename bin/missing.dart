import 'dart:convert' as j;

import 'dart:io';

import 'package:args/args.dart';

void main(List<String> arguments) async {
  final parser = ArgParser();

  parser
    ..addOption(
      'from',
      abbr: 'f',
      allowed: ['en', 'ar'],
      help: 'Use -f or --from flag to use the file you want to read from.',
    )
    ..addOption(
      'to',
      abbr: 't',
      allowed: ['ar', 'en'],
      help: 'Use -t or --to flag to write the file from to this file.',
    )
    ..addFlag(
      'help',
      abbr: 'h',
    );

  try {
    final results = parser.parse(arguments);
    final from = results['from'];
    final to = results['to'];
    final help = results['help'];

    if (!help) {
      if ((from == null || to == null)) {
        print('You must specify both from and to arguments');
      } else {
        final jsonObject = await readJsonFile(path: '$from.json');
        final testObject = await readJsonFile(path: '$to.json');

        jsonObject.forEach((key, value) {
          if (!testObject.containsKey(key)) {
            testObject[key] = value;
          }
        });

        await writeToFile(path: '$to.json', map: testObject);
      }
    } else {
      print(parser.usage);
    }
  } on FormatException catch (e) {
    print(e.message);
    print('You have to use "en" or "ar".');
  }
}

Future<Map<String, dynamic>> readJsonFile({required String path}) async {
  final json = await File(path).readAsString();
  return j.json.decode(json);
}

Future<void> writeToFile({
  required String path,
  required Map<String, dynamic> map,
}) async {
  final file = File(path);
  final stringMap = j.json.encode(map);
  await file.writeAsString(stringMap);
}
