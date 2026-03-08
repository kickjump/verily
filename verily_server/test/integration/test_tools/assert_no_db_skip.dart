import 'dart:io';

void main() {
  final root = Directory('test');
  if (!root.existsSync()) {
    stderr.writeln('::error::Expected test directory not found: ${root.path}');
    exitCode = 1;
    return;
  }

  final dbTagPattern = RegExp(
    "@Tags\\(\\s*\\[[^\\]]*['\\\"]db['\\\"][^\\]]*\\]\\s*\\)",
  );
  final skipPattern = RegExp("\\bskip\\s*:\\s*(?:'[^']*'|\\\"[^\\\"]*\\\")");

  final offendingFiles = <String>[];

  for (final entity in root.listSync(recursive: true, followLinks: false)) {
    if (entity is! File || !entity.path.endsWith('_test.dart')) {
      continue;
    }

    final content = entity.readAsStringSync();
    if (!dbTagPattern.hasMatch(content)) {
      continue;
    }

    final executableLines = content
        .split('\n')
        .where((line) => !line.trimLeft().startsWith('//'))
        .join('\n');

    if (skipPattern.hasMatch(executableLines)) {
      offendingFiles.add(entity.path);
    }
  }

  if (offendingFiles.isNotEmpty) {
    stderr.writeln(
      '::error::DB-tagged tests must not use `skip:`. '
      'Run the DB shard in CI instead of hard-skipping.',
    );
    for (final file in offendingFiles..sort()) {
      stderr.writeln(' - $file');
    }
    exitCode = 1;
    return;
  }

  stdout.writeln(
    'No hard-coded skip markers found in db-tagged _test.dart files.',
  );
}
