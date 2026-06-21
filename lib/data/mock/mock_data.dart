import 'package:flutter/material.dart';
import '../models/module.dart';
import '../models/quiz.dart';
import '../models/progress_entry.dart';
import '../models/user.dart';

/// Static, realistic dummy data standing in for a future backend.
class MockData {
  MockData._();

  static const dailyGoals = [
    DailyGoal(id: 'santai', label: 'Santai', subtitle: '5 menit / hari', xpTarget: 50),
    DailyGoal(id: 'reguler', label: 'Reguler', subtitle: '10 menit / hari', xpTarget: 100),
    DailyGoal(id: 'serius', label: 'Serius', subtitle: '20 menit / hari', xpTarget: 200),
    DailyGoal(id: 'intensif', label: 'Intensif', subtitle: '30 menit / hari', xpTarget: 300),
  ];

  static const badges = [
    AppBadge(id: 'pemula', title: 'Pemula', icon: Icons.rocket_launch_rounded, earnedOn: '1 Mei 2026'),
    AppBadge(id: 'streak7', title: '7 Hari', icon: Icons.local_fire_department_rounded, earnedOn: '7 Mei 2026'),
    AppBadge(id: 'akurat', title: 'Akurat', icon: Icons.gps_fixed_rounded, earnedOn: '5 Mei 2026'),
    AppBadge(id: 'master', title: 'Master', icon: Icons.workspace_premium_rounded, earnedOn: 'Lvl 10', locked: true),
    AppBadge(id: 'perfek', title: 'Perfek', icon: Icons.diamond_rounded, earnedOn: '100%', locked: true),
    AppBadge(id: 'kilat', title: 'Kilat', icon: Icons.bolt_rounded, earnedOn: '15 Hari', locked: true),
  ];

  static AppUser user = const AppUser(
    id: 'u1',
    name: 'Thariq Habibi',
    email: 'thariq@example.com',
    level: 5,
    totalXp: 1280,
    streakDays: 7,
    dailyGoalId: 'reguler',
    badgeIds: ['pemula', 'streak7', 'akurat'],
  );

  static final List<LearningModule> modules = [
    LearningModule(
      id: 'nglegena',
      title: 'Nglegena',
      subtitle: 'Aksara dasar · 20 huruf',
      previewAksara: 'ꦤ',
      color: const Color(0xFFB7E4A0),
      xpReward: 50,
      completedCards: 12,
      cards: const [
        LessonCard(
          id: 'ng-1',
          aksara: 'ꦲ',
          title: 'Ha',
          pronunciation: 'Ha',
          description: 'Aksara dasar pertama dalam urutan Hanacaraka, melambangkan bunyi konsonan "h" dengan vokal bawaan "a".',
          example: 'ꦲꦤ',
          exampleMeaning: 'hana (ada)',
          attributes: ['Fonem: /h/', 'Urutan: 1'],
        ),
        LessonCard(
          id: 'ng-2',
          aksara: 'ꦤ',
          title: 'Na',
          pronunciation: 'Na',
          description: 'Aksara kedua, melambangkan bunyi konsonan "n" dengan vokal bawaan "a".',
          example: 'ꦤꦩ',
          exampleMeaning: 'nama (nama)',
          attributes: ['Fonem: /n/', 'Urutan: 2'],
        ),
        LessonCard(
          id: 'ng-3',
          aksara: 'ꦕ',
          title: 'Ca',
          pronunciation: 'Ca',
          description: 'Aksara ketiga, melambangkan bunyi konsonan "c" dengan vokal bawaan "a".',
          example: 'ꦕꦫ',
          exampleMeaning: 'cara (cara)',
          attributes: ['Fonem: /c/', 'Urutan: 3'],
        ),
        LessonCard(
          id: 'ng-4',
          aksara: 'ꦫ',
          title: 'Ra',
          pronunciation: 'Ra',
          description: 'Aksara keempat, melambangkan bunyi konsonan "r" dengan vokal bawaan "a".',
          example: 'ꦫꦱ',
          exampleMeaning: 'rasa (rasa)',
          attributes: ['Fonem: /r/', 'Urutan: 4'],
        ),
        LessonCard(
          id: 'ng-5',
          aksara: 'ꦏ',
          title: 'Ka',
          pronunciation: 'Ka',
          description: 'Aksara kelima, melambangkan bunyi konsonan "k" dengan vokal bawaan "a".',
          example: 'ꦏꦭ',
          exampleMeaning: 'kala (waktu)',
          attributes: ['Fonem: /k/', 'Urutan: 5'],
        ),
      ],
    ),
    LearningModule(
      id: 'sandhangan',
      title: 'Sandhangan',
      subtitle: 'Tanda vokal · 8 aturan',
      previewAksara: 'ꦏꦶ',
      color: const Color(0xFFA5D8F0),
      xpReward: 80,
      completedCards: 2,
      cards: const [
        LessonCard(
          id: 'sd-1',
          aksara: 'ꦶ',
          title: 'Wulu',
          pronunciation: 'i',
          description: 'Sandhangan wulu mengubah bunyi vokal bawaan "a" pada aksara menjadi "i". Ditulis di atas aksara.',
          example: 'ꦏꦶ',
          exampleMeaning: 'ki',
          attributes: ['Posisi: Atas', 'Mengubah ke: i'],
          tip: 'Wulu berbentuk seperti titik kecil di atas huruf — mudah dihafal sebagai "titik di atas = i".',
        ),
        LessonCard(
          id: 'sd-2',
          aksara: 'ꦸ',
          title: 'Suku',
          pronunciation: 'u',
          description: 'Sandhangan suku mengubah bunyi vokal bawaan "a" menjadi "u". Ditulis menempel di bawah aksara.',
          example: 'ꦏꦸ',
          exampleMeaning: 'ku',
          attributes: ['Posisi: Bawah', 'Mengubah ke: u'],
          tip: 'Suku bentuknya melengkung ke bawah seperti ekor, menempel langsung di bawah huruf.',
        ),
      ],
    ),
    LearningModule(
      id: 'pasangan',
      title: 'Pasangan',
      subtitle: 'Konsonan ganda · 20 huruf',
      previewAksara: 'ꦢ',
      color: const Color(0xFFD7C5F0),
      xpReward: 100,
      locked: true,
      cards: const [
        LessonCard(
          id: 'ps-1',
          aksara: 'ꦤ꧀ꦤ',
          title: 'Pasangan Na',
          pronunciation: 'Pasangan Na',
          description: 'Mematikan vokal aksara di depannya. Ditulis di bawah aksara sebelumnya.',
          example: 'ꦱꦸꦫꦠ꧀ꦤ',
          exampleMeaning: 'surat-na',
          attributes: ['Fonem: /n/', 'Posisi: Bawah'],
          warning: 'Pasangan hanya muncul setelah aksara berakhiran konsonan. Tidak bisa berdiri sendiri.',
        ),
      ],
    ),
    LearningModule(
      id: 'wilangan',
      title: 'Aksara Wilangan',
      subtitle: 'Angka · 10 simbol',
      previewAksara: '꧇',
      color: const Color(0xFFF3E0B8),
      xpReward: 60,
      locked: true,
      cards: [],
    ),
  ];

  static LearningModule moduleById(String id) => modules.firstWhere((m) => m.id == id);

  static final Map<QuizLevel, List<QuizQuestion>> quizBank = {
    QuizLevel.harian: const [
      QuizQuestion(
        id: 'h1',
        aksara: 'ꦏ',
        prompt: 'Aksara ini dibaca apa?',
        options: ['Ka', 'Ha', 'Ra', 'Ta'],
        correctAnswer: 'Ka',
        explanation: 'Aksara ꦏ dibaca "Ka".',
      ),
      QuizQuestion(
        id: 'h2',
        aksara: 'ꦢ',
        prompt: 'Aksara ini dibaca apa?',
        options: ['Da', 'Ta', 'Sa', 'Pa'],
        correctAnswer: 'Da',
        explanation: 'Aksara ꦢ dibaca "Da".',
      ),
      QuizQuestion(
        id: 'h3',
        aksara: 'ꦱ',
        prompt: 'Aksara ini dibaca apa?',
        options: ['Sa', 'Wa', 'La', 'Pa'],
        correctAnswer: 'Sa',
        explanation: 'Aksara ꦱ dibaca "Sa".',
      ),
      QuizQuestion(
        id: 'h4',
        aksara: 'ꦏꦶ',
        prompt: 'Bagaimana aksara ini dibaca?',
        options: ['Ka', 'Ki', 'Ku', 'Ke'],
        correctAnswer: 'Ki',
        explanation: 'Sandhangan wulu mengubah vokal bawaan "a" pada ꦏ menjadi "i", sehingga dibaca "Ki".',
      ),
      QuizQuestion(
        id: 'h5',
        aksara: 'ꦮ',
        prompt: 'Aksara ini dibaca apa?',
        options: ['Wa', 'Ya', 'Ba', 'Ga'],
        correctAnswer: 'Wa',
        explanation: 'Aksara ꦮ dibaca "Wa".',
      ),
    ],
    QuizLevel.pemula: const [
      QuizQuestion(
        id: 'q1',
        aksara: 'ꦠ',
        prompt: 'Aksara ini dibaca apa?',
        options: ['Ka', 'Ha', 'Ra', 'Ta'],
        correctAnswer: 'Ta',
        explanation: 'Aksara ꦠ dibaca "Ta". Bentuknya mirip ekor melingkar di bawah — beda dengan ꦏ yang lebih tegak di kiri.',
      ),
      QuizQuestion(
        id: 'q2',
        aksara: 'ꦲ',
        prompt: 'Aksara ini dibaca apa?',
        options: ['Ha', 'Na', 'Ca', 'Sa'],
        correctAnswer: 'Ha',
        explanation: 'Aksara ꦲ dibaca "Ha", aksara pertama dalam urutan Hanacaraka.',
      ),
      QuizQuestion(
        id: 'q3',
        aksara: 'ꦤ',
        prompt: 'Aksara ini dibaca apa?',
        options: ['Ma', 'Na', 'Da', 'La'],
        correctAnswer: 'Na',
        explanation: 'Aksara ꦤ dibaca "Na", aksara kedua dalam urutan Hanacaraka.',
      ),
      QuizQuestion(
        id: 'q4',
        aksara: 'ꦕ',
        prompt: 'Aksara ini dibaca apa?',
        options: ['Ca', 'Ja', 'Ya', 'Wa'],
        correctAnswer: 'Ca',
        explanation: 'Aksara ꦕ dibaca "Ca", aksara ketiga dalam urutan Hanacaraka.',
      ),
      QuizQuestion(
        id: 'q5',
        aksara: 'ꦫ',
        prompt: 'Aksara ini dibaca apa?',
        options: ['Ga', 'Ba', 'Ra', 'Pa'],
        correctAnswer: 'Ra',
        explanation: 'Aksara ꦫ dibaca "Ra", aksara keempat dalam urutan Hanacaraka.',
      ),
    ],
    QuizLevel.menengah: const [
      QuizQuestion(
        id: 'm1',
        aksara: 'ꦏꦶ',
        prompt: 'Bagaimana aksara ini dibaca?',
        options: ['Ka', 'Ki', 'Ku', 'Ke'],
        correctAnswer: 'Ki',
        explanation: 'Sandhangan wulu (titik di atas) mengubah vokal bawaan "a" pada ꦏ menjadi "i", sehingga dibaca "Ki".',
      ),
      QuizQuestion(
        id: 'm2',
        aksara: 'ꦏꦸ',
        prompt: 'Bagaimana aksara ini dibaca?',
        options: ['Ka', 'Ki', 'Ku', 'Ko'],
        correctAnswer: 'Ku',
        explanation: 'Sandhangan suku (di bawah huruf) mengubah vokal bawaan "a" pada ꦏ menjadi "u", sehingga dibaca "Ku".',
      ),
      QuizQuestion(
        id: 'm3',
        aksara: 'ꦤꦶ',
        prompt: 'Bagaimana aksara ini dibaca?',
        options: ['Na', 'Ni', 'Nu', 'Ne'],
        correctAnswer: 'Ni',
        explanation: 'Sandhangan wulu mengubah vokal bawaan "a" pada ꦤ menjadi "i", sehingga dibaca "Ni".',
      ),
      QuizQuestion(
        id: 'm4',
        aksara: 'ꦕꦸ',
        prompt: 'Bagaimana aksara ini dibaca?',
        options: ['Ca', 'Ci', 'Cu', 'Co'],
        correctAnswer: 'Cu',
        explanation: 'Sandhangan suku mengubah vokal bawaan "a" pada ꦕ menjadi "u", sehingga dibaca "Cu".',
      ),
      QuizQuestion(
        id: 'm5',
        aksara: 'ꦫꦶ',
        prompt: 'Bagaimana aksara ini dibaca?',
        options: ['Ra', 'Ri', 'Ru', 'Re'],
        correctAnswer: 'Ri',
        explanation: 'Sandhangan wulu mengubah vokal bawaan "a" pada ꦫ menjadi "i", sehingga dibaca "Ri".',
      ),
    ],
    QuizLevel.tantanganWaktu: const [
      QuizQuestion(
        id: 't1',
        aksara: 'ꦲ',
        prompt: 'Aksara ini dibaca apa?',
        options: ['Ha', 'Na', 'Ca', 'Ra'],
        correctAnswer: 'Ha',
        explanation: 'Aksara ꦲ dibaca "Ha".',
      ),
      QuizQuestion(
        id: 't2',
        aksara: 'ꦤ',
        prompt: 'Aksara ini dibaca apa?',
        options: ['Ma', 'Na', 'Da', 'La'],
        correctAnswer: 'Na',
        explanation: 'Aksara ꦤ dibaca "Na".',
      ),
      QuizQuestion(
        id: 't3',
        aksara: 'ꦕ',
        prompt: 'Aksara ini dibaca apa?',
        options: ['Ca', 'Ja', 'Ya', 'Wa'],
        correctAnswer: 'Ca',
        explanation: 'Aksara ꦕ dibaca "Ca".',
      ),
      QuizQuestion(
        id: 't4',
        aksara: 'ꦫ',
        prompt: 'Aksara ini dibaca apa?',
        options: ['Ga', 'Ba', 'Ra', 'Pa'],
        correctAnswer: 'Ra',
        explanation: 'Aksara ꦫ dibaca "Ra".',
      ),
      QuizQuestion(
        id: 't5',
        aksara: 'ꦏ',
        prompt: 'Aksara ini dibaca apa?',
        options: ['Ka', 'Ha', 'Ra', 'Ta'],
        correctAnswer: 'Ka',
        explanation: 'Aksara ꦏ dibaca "Ka".',
      ),
      QuizQuestion(
        id: 't6',
        aksara: 'ꦢ',
        prompt: 'Aksara ini dibaca apa?',
        options: ['Da', 'Ta', 'Sa', 'Pa'],
        correctAnswer: 'Da',
        explanation: 'Aksara ꦢ dibaca "Da".',
      ),
      QuizQuestion(
        id: 't7',
        aksara: 'ꦠ',
        prompt: 'Aksara ini dibaca apa?',
        options: ['Ka', 'Ha', 'Ra', 'Ta'],
        correctAnswer: 'Ta',
        explanation: 'Aksara ꦠ dibaca "Ta".',
      ),
      QuizQuestion(
        id: 't8',
        aksara: 'ꦱ',
        prompt: 'Aksara ini dibaca apa?',
        options: ['Sa', 'Wa', 'La', 'Pa'],
        correctAnswer: 'Sa',
        explanation: 'Aksara ꦱ dibaca "Sa".',
      ),
      QuizQuestion(
        id: 't9',
        aksara: 'ꦮ',
        prompt: 'Aksara ini dibaca apa?',
        options: ['Wa', 'Ya', 'Ba', 'Ga'],
        correctAnswer: 'Wa',
        explanation: 'Aksara ꦮ dibaca "Wa".',
      ),
      QuizQuestion(
        id: 't10',
        aksara: 'ꦭ',
        prompt: 'Aksara ini dibaca apa?',
        options: ['La', 'Pa', 'Dha', 'Ja'],
        correctAnswer: 'La',
        explanation: 'Aksara ꦭ dibaca "La".',
      ),
    ],
  };

  static const quizLevelInfos = [
    QuizLevelInfo(
      level: QuizLevel.pemula,
      title: 'Pemula',
      subtitle: 'Nglegena dasar',
      starScore: 3,
      bestScore: '8/10',
    ),
    QuizLevelInfo(
      level: QuizLevel.menengah,
      title: 'Menengah',
      subtitle: 'Sandhangan + Wulu',
      starScore: 2,
      bestScore: '6/10',
    ),
    QuizLevelInfo(
      level: QuizLevel.tantanganWaktu,
      title: 'Tantangan Waktu',
      subtitle: '10 soal · 60 detik',
      starScore: 1,
      bestScore: '4/10',
      timeLimitSeconds: 60,
    ),
    QuizLevelInfo(
      level: QuizLevel.master,
      title: 'Master',
      subtitle: 'Pasangan + campur',
      starScore: 0,
      bestScore: '—',
      locked: true,
    ),
  ];

  static List<ProgressEntry> last7DaysAccuracy() {
    final now = DateTime.now();
    final values = [0.75, 0.88, 0.92, 0.80, 0.85, 0.90, 0.84];
    return List.generate(7, (i) {
      final date = now.subtract(Duration(days: 6 - i));
      return ProgressEntry(date: date, accuracy: values[i], active: true);
    });
  }

  static Set<int> activeStreakDaysInMonth(DateTime month) {
    return {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
  }

  static const totalLessonsCompleted = 24;
  static const totalQuizzesCompleted = 12;
  static const overallAccuracy = 0.84;
}
