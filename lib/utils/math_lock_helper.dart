import 'dart:math';

class MathQuestion {
  final int answer;
  final String label;

  MathQuestion(this.answer, this.label);
}

class MathLockHelper {
  static final _random = Random();

  static MathQuestion generateQuestion() {
    int a = _random.nextInt(10) + 1;
    int b = _random.nextInt(10) + 1;
    return MathQuestion(a + b, '$a + $b = ?');
  }
}
