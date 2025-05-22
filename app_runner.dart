import 'dart:io';

void main(List<String>? params) async {
  List<String> args = ['run', 'android'];

  if (args.length < 2) {
    print('Usage: dart app_runner.dart [run|build] [android|ios|apk]');
    exit(1);
  }

  final mode = args[0];
  final platform = args[1];

var envFile = File('.env');
  print('Current working directory: ${Directory.current.path}');
  if (!envFile.existsSync()) {
    // fallback
    envFile = File('${Directory.current.path}/.env');
  }
  if (!envFile.existsSync()) {
    print('[ERROR] .env file not found.');
    exit(1);
  }

  final lines = await envFile.readAsLines();
  final dartDefines = <String>[];

  for (var line in lines) {
    if (line.trim().isEmpty || line.trim().startsWith('#')) continue;
    final parts = line.split('=');
    if (parts.length < 2) continue;
    final key = parts[0].trim();
    final value = parts.sublist(1).join('=').trim();
    dartDefines.add('--dart-define=$key=$value');
  }

  if (dartDefines.isEmpty) {
    print('[ERROR] No valid env variables found in .env file.');
    exit(1);
  }

  List<String> command;
  switch ('$mode:$platform') {
    case 'run:android':
      command = ['flutter', 'run', ...dartDefines];
      break;
    case 'run:ios':
      command = ['flutter', 'run', '-d', 'ios', ...dartDefines];
      break;
    case 'build:apk':
      command = [
        'flutter',
        'build',
        'apk',
        ...dartDefines,
        '--obfuscate',
        '--split-debug-info=build/debug-info',
      ];
      break;
    case 'build:ios':
      command = [
        'flutter',
        'build',
        'ios',
        ...dartDefines,
        '--obfuscate',
        '--split-debug-info=build/debug-info',
      ];
      break;
    default:
      print('[ERROR] Unsupported mode/platform combination.');
      exit(1);
  }

  print('[INFO] Running: ${command.join(' ')}');

  final process = await Process.start(
    command.first,
    command.sublist(1),
    mode: ProcessStartMode.inheritStdio,
  );

  final exitCode = await process.exitCode;
  if (exitCode != 0) {
    print('[ERROR] Command failed with exit code $exitCode');
    exit(exitCode);
  }
}
