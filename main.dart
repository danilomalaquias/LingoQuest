import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LingoQuestApp());
}

const Color ink = Color(0xFF202447);
const Color purple = Color(0xFF6657D9);
const Color orange = Color(0xFFFFA34D);
const Color mint = Color(0xFF55C7A5);
const Color canvas = Color(0xFFF5F4FC);

class LingoQuestApp extends StatelessWidget {
  const LingoQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LingoQuest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: canvas,
        colorScheme: ColorScheme.fromSeed(seedColor: purple),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: canvas,
          foregroundColor: ink,
          elevation: 0,
          centerTitle: false,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class World {
  const World(this.title, this.subtitle, this.emoji, this.color, this.lessons);
  final String title;
  final String subtitle;
  final String emoji;
  final Color color;
  final int lessons;
}

const worlds = [
  World('First Steps', 'Comece sua jornada', '👋', Color(0xFFFFDCA8), 5),
  World('About Me', 'Fale sobre você', '🧑‍🚀', Color(0xFFDCD7FF), 6),
  World('Everyday Life', 'Seu dia a dia em inglês', '☀️', Color(0xFFC9F0E4), 6),
  World("Let's Go Shopping", 'Explore lojas e mercados', '🛍️', Color(0xFFFFD6DF), 5),
  World('Traveling', 'Viaje sem medo', '✈️', Color(0xFFCDE7FF), 6),
  World("Let's Talk!", 'Converse com confiança', '💬', Color(0xFFFFE6A8), 7),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int xp = 0;
  int completed = 0;
  int streak = 1;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      xp = prefs.getInt('xp') ?? 0;
      completed = prefs.getInt('completed') ?? 0;
      streak = prefs.getInt('streak') ?? 1;
      loading = false;
    });
  }

  Future<void> _openLesson() async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => LessonScreen(onComplete: _addXp),
    ));
    _loadProgress();
  }

  Future<void> _addXp(int points) async {
    final prefs = await SharedPreferences.getInstance();
    xp += points;
    completed += 1;
    await prefs.setInt('xp', xp);
    await prefs.setInt('completed', completed);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              sliver: SliverList.list(children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: purple,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text('🦊', style: TextStyle(fontSize: 28)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('LINGOQUEST',
                              style: TextStyle(
                                  color: purple,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                  fontSize: 13)),
                          Text('Sua aventura começa aqui!',
                              style: TextStyle(
                                  color: ink,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 17)),
                        ],
                      ),
                    ),
                    _StatPill(icon: '🔥', value: '$streak'),
                    const SizedBox(width: 7),
                    _StatPill(icon: '⭐', value: '$xp'),
                  ],
                ),
                const SizedBox(height: 25),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7164E8), Color(0xFF5145BD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: purple.withValues(alpha: .22),
                        blurRadius: 18,
                        offset: const Offset(0, 9),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Expanded(
                            child: Text('MISSÃO DO DIA',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.3,
                                    fontSize: 11)),
                          ),
                          Text('⏱ 3 MIN',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11)),
                        ],
                      ),
                      const SizedBox(height: 9),
                      const Text('Um café em Londres ☕',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 23)),
                      const SizedBox(height: 6),
                      const Text(
                        'Aprenda a cumprimentar alguém e pedir seu primeiro café em inglês.',
                        style: TextStyle(color: Colors.white, height: 1.35),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _openLesson,
                          style: FilledButton.styleFrom(
                            backgroundColor: orange,
                            foregroundColor: ink,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          child: const Text('COMEÇAR A AVENTURA  →',
                              style: TextStyle(fontWeight: FontWeight.w900)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Sua jornada',
                        style: TextStyle(
                            color: ink,
                            fontSize: 20,
                            fontWeight: FontWeight.w900)),
                    Text('$completed lições concluídas',
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 13),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: (completed / 35).clamp(0.0, 1.0),
                    minHeight: 9,
                    backgroundColor: const Color(0xFFE5E2F5),
                    color: mint,
                  ),
                ),
                const SizedBox(height: 22),
                const Text('EXPLORE OS MUNDOS',
                    style: TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        fontSize: 11)),
                const SizedBox(height: 12),
                ...worlds.asMap().entries.map((entry) {
                  final index = entry.key;
                  final world = entry.value;
                  final unlocked = index == 0 || completed >= index * 2;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 11),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: unlocked
                          ? (index == 0
                              ? _openLesson
                              : () => ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Novas aventuras deste mundo chegam em uma próxima atualização!'),
                                    ),
                                  ))
                          : null,
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFECEAF5)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                color: world.color,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Text(world.emoji,
                                    style: const TextStyle(fontSize: 27)),
                              ),
                            ),
                            const SizedBox(width: 13),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(world.title,
                                      style: const TextStyle(
                                          color: ink,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 15)),
                                  const SizedBox(height: 3),
                                  Text(world.subtitle,
                                      style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12)),
                                  const SizedBox(height: 7),
                                  Text('${world.lessons} pequenas aventuras',
                                      style: const TextStyle(
                                          color: purple,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                            Icon(
                              unlocked
                                  ? Icons.arrow_forward_ios_rounded
                                  : Icons.lock_rounded,
                              color: unlocked ? purple : Colors.black26,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F7F1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Row(
                    children: [
                      Text('💡', style: TextStyle(fontSize: 25)),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Dica do explorador: errar faz parte da aventura. Tente, descubra e siga em frente!',
                          style: TextStyle(
                              color: ink,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              height: 1.35),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.icon, required this.value});
  final String icon;
  final String value;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 13)),
            const SizedBox(width: 4),
            Text(value,
                style: const TextStyle(
                    color: ink, fontWeight: FontWeight.w900, fontSize: 12)),
          ],
        ),
      );
}

class Question {
  const Question(this.prompt, this.options, this.answer, this.explanation,
      this.phrase);
  final String prompt;
  final List<String> options;
  final int answer;
  final String explanation;
  final String phrase;
}

const questions = [
  Question(
    'Você acabou de chegar ao café. Como diz “Olá!”?',
    ['Goodbye!', 'Hello!', 'Please!', 'Sorry!'],
    1,
    '“Hello!” é uma forma comum e amigável de dizer “Olá!”.',
    'Hello!',
  ),
  Question(
    'O atendente pergunta: “How are you?” O que significa?',
    ['Qual é seu nome?', 'Onde você mora?', 'Como você está?', 'Quanto custa?'],
    2,
    '“How are you?” significa “Como você está?”.',
    'How are you?',
  ),
  Question(
    'Como você responde “Estou bem, obrigado”?',
    ['I am fine, thanks.', 'My name is Alex.', 'See you later.', 'A coffee, please.'],
    0,
    '“I am fine, thanks” é uma resposta natural e educada.',
    'I am fine, thanks.',
  ),
  Question(
    'Você quer pedir um café. Qual frase usar?',
    ['Where is the hotel?', 'A coffee, please.', 'I am twenty.', 'Good night!'],
    1,
    '“A coffee, please” significa “Um café, por favor”.',
    'A coffee, please.',
  ),
  Question(
    'Antes de sair, como você agradece?',
    ['Thank you!', 'Good morning!', 'What time is it?', 'Excuse me!'],
    0,
    '“Thank you!” significa “Obrigado(a)!”.',
    'Thank you!',
  ),
];

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key, required this.onComplete});
  final Future<void> Function(int points) onComplete;
  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final FlutterTts tts = FlutterTts();
  int index = 0;
  int? selected;
  int correct = 0;
  bool finished = false;
  bool saved = false;

  Future<void> _speak(String phrase) async {
    try {
      await tts.setLanguage('en-US');
      await tts.setSpeechRate(0.43);
      await tts.speak(phrase);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Áudio indisponível neste dispositivo.')),
        );
      }
    }
  }

  Future<void> _next() async {
    if (selected == null) return;
    if (selected == questions[index].answer) correct++;
    if (index < questions.length - 1) {
      setState(() {
        index++;
        selected = null;
      });
    } else {
      setState(() => finished = true);
      if (!saved) {
        saved = true;
        await widget.onComplete(20 + correct * 5);
      }
    }
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (finished) {
      final stars = correct >= 4 ? 3 : (correct >= 2 ? 2 : 1);
      return Scaffold(
        appBar: AppBar(leading: const BackButton()),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(26),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🎉', style: TextStyle(fontSize: 76)),
                const SizedBox(height: 14),
                const Text('Missão concluída!',
                    style: TextStyle(
                        color: ink, fontSize: 27, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Text('Você acertou $correct de ${questions.length} questões.',
                    style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 14),
                Text(List.filled(stars, '⭐').join(), style: const TextStyle(fontSize: 35)),
                const SizedBox(height: 10),
                Text('+${20 + correct * 5} XP',
                    style: const TextStyle(
                        color: purple, fontSize: 24, fontWeight: FontWeight.w900)),
                const SizedBox(height: 22),
                const Text(
                  'Mandou bem, explorador! Cada frase nova é mais um passo na sua jornada.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: ink, height: 1.4),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: purple,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text('VOLTAR AO MAPA'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final q = questions[index];
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('First Steps',
            style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Center(
              child: Text('${index + 1}/${questions.length}',
                  style: const TextStyle(
                      color: purple, fontWeight: FontWeight.w900)),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (index + 1) / questions.length,
                  minHeight: 8,
                  color: mint,
                  backgroundColor: const Color(0xFFE5E2F5),
                ),
              ),
              const SizedBox(height: 28),
              const Text('MISSÃO 01 · NO CAFÉ',
                  style: TextStyle(
                      color: purple,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1)),
              const SizedBox(height: 10),
              Text(q.prompt,
                  style: const TextStyle(
                      color: ink,
                      fontSize: 23,
                      height: 1.2,
                      fontWeight: FontWeight.w900)),
              const SizedBox(height: 22),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDEAFF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Text('🦊', style: TextStyle(fontSize: 38)),
                    const SizedBox(width: 13),
                    const Expanded(
                      child: Text(
                        'Vamos lá! Escolha a melhor resposta para continuar a conversa.',
                        style: TextStyle(
                            color: ink, fontWeight: FontWeight.w600, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ...q.options.asMap().entries.map((entry) {
                final isSelected = selected == entry.key;
                final isAnswer = q.answer == entry.key;
                Color border = const Color(0xFFE7E5F0);
                Color fill = Colors.white;
                if (selected != null && isSelected) {
                  border = isAnswer ? mint : const Color(0xFFE47D78);
                  fill = isAnswer
                      ? const Color(0xFFE5F7F0)
                      : const Color(0xFFFFEFED);
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: selected == null
                        ? () => setState(() => selected = entry.key)
                        : null,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      decoration: BoxDecoration(
                        color: fill,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: border, width: isSelected ? 2 : 1),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(entry.value,
                                style: const TextStyle(
                                    color: ink, fontWeight: FontWeight.w700)),
                          ),
                          if (selected != null && isSelected)
                            Icon(
                              isAnswer ? Icons.check_circle : Icons.cancel,
                              color: isAnswer ? mint : Colors.redAccent,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              if (selected != null) ...[
                const SizedBox(height: 3),
                Text(
                  selected == q.answer ? 'Muito bem! ${q.explanation}' : q.explanation,
                  style: const TextStyle(
                      color: ink, fontSize: 12, height: 1.35),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => _speak(q.phrase),
                    icon: const Icon(Icons.volume_up_rounded),
                    label: const Text('Ouvir pronúncia'),
                  ),
                ),
              ],
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: selected == null ? null : _next,
                  style: FilledButton.styleFrom(
                    backgroundColor: purple,
                    disabledBackgroundColor: const Color(0xFFD7D3ED),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(index == questions.length - 1
                      ? 'CONCLUIR MISSÃO'
                      : 'CONTINUAR'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
