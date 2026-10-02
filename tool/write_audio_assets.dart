import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

/// Writes original synthesized tones. Not studio music and not narration.
void main() {
  final directory = Directory('assets/audio');
  directory.createSync(recursive: true);
  _write(directory, 'tap.wav', _tone([(880, 0.04)], 0.35));
  _write(directory, 'correct.wav', _tone([(523, 0.16), (659, 0.18)], 0.45));
  _write(directory, 'retry.wav', _tone([(392, 0.12), (330, 0.16)], 0.28));
  _write(
    directory,
    'complete.wav',
    _tone([(523, 0.12), (659, 0.12), (784, 0.2)], 0.4),
  );
  _write(
    directory,
    'reward.wav',
    _tone([(659, 0.1), (784, 0.1), (1046, 0.22)], 0.45),
  );
  _write(directory, 'music.wav', _loop());
  for (final file in directory.listSync()) {
    if (file is File) {
      stdout.writeln('${file.path} ${file.lengthSync()}');
    }
  }
}

void _write(Directory directory, String name, Uint8List samples) {
  File('${directory.path}/$name').writeAsBytesSync(_wav(samples));
}

Uint8List _tone(List<(double, double)> notes, double gain) {
  const rate = 16000;
  final samples = <int>[];
  for (final (frequency, seconds) in notes) {
    final count = (rate * seconds).round();
    for (var index = 0; index < count; index++) {
      final attack = (index / 400).clamp(0, 1).toDouble();
      final release = ((count - index) / 800).clamp(0, 1).toDouble();
      final envelope = math.min(attack, release);
      final wave = math.sin(2 * math.pi * frequency * index / rate);
      samples.add(
        (wave * envelope * gain * 32767).round().clamp(-32767, 32767),
      );
    }
  }
  return Uint8List.view(Int16List.fromList(samples).buffer);
}

Uint8List _loop() {
  const rate = 16000;
  const seconds = 8;
  final notes = <double>[262, 294, 330, 392, 330, 294, 262, 392];
  final samples = List<int>.filled(rate * seconds, 0);
  final noteLength = rate;
  for (var note = 0; note < notes.length; note++) {
    for (var index = 0; index < noteLength; index++) {
      final envelope = math.sin(math.pi * index / noteLength);
      final wave = math.sin(2 * math.pi * notes[note] * index / rate);
      samples[note * noteLength + index] = (wave * envelope * 0.12 * 32767)
          .round();
    }
  }
  return Uint8List.view(Int16List.fromList(samples).buffer);
}

Uint8List _wav(Uint8List pcm) {
  final dataSize = pcm.length;
  final builder = BytesBuilder();
  builder.add('RIFF'.codeUnits);
  builder.add(_le(36 + dataSize));
  builder.add('WAVE'.codeUnits);
  builder.add('fmt '.codeUnits);
  builder.add(_le(16));
  builder.add(_le16(1));
  builder.add(_le16(1));
  builder.add(_le(16000));
  builder.add(_le(32000));
  builder.add(_le16(2));
  builder.add(_le16(16));
  builder.add('data'.codeUnits);
  builder.add(_le(dataSize));
  builder.add(pcm);
  return builder.toBytes();
}

List<int> _le(int value) {
  final data = ByteData(4)..setUint32(0, value, Endian.little);
  return data.buffer.asUint8List();
}

List<int> _le16(int value) {
  final data = ByteData(2)..setUint16(0, value, Endian.little);
  return data.buffer.asUint8List();
}
