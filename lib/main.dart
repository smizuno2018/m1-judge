import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M-1グランプリ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'M-1グランプリ'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key = const ValueKey('my_home_page'), required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _performers = ['カベポスター', '真空ジェシカ', 'キュウ', 'ヨネダ2000', 'ダイヤモンド', 'ウエストランド', 'さや香', 'ロングコートダディ' , '男性ブランコ'];
  late Map<String, int> _scores;
  // 表示順を並び替えるために使用するキーのリスト
  List<String> _scoreKeys = [];

  // 得点を保存する関数
  Future<void> saveScores(Map<String, int> scores) async {
    final preferences = await SharedPreferences.getInstance();
    for (final performer in scores.keys) {
      preferences.setInt(performer, scores[performer]!);
    }
  }

  // 得点を読み込む関数
  Future<Map<String, int>> loadScores() async {
    final preferences = await SharedPreferences.getInstance();
    final scores = <String, int>{};
    for (final performer in _performers) {
      scores[performer] = preferences.getInt(performer) ?? 70;
    }
    return scores;
  }

  @override
  void initState() {
    super.initState();
    // 初期化時に得点を読み込む
    loadScores().then((scores) {
      setState(() {
        _scores = scores;
        _scoreKeys = _scores.keys.toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[400],
      appBar: AppBar(
        backgroundColor: Colors.red[800],
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _scoreKeys.length,
              itemBuilder: (context, index) {
                final performer = _scoreKeys[index];
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(performer, style: Theme.of(context).textTheme.headline6),
                              Spacer(),
                              Text('${_scores[performer]}点', style: Theme.of(context).textTheme.headline6),
                            ],
                          ),
                          SizedBox(height: 8),
                          Slider(
                            min: 70,
                            max: 100,
                            value: _scores[performer]!.toDouble(),
                            onChanged: (newValue) {
                              setState(() {
                                _scores[performer] = newValue.round();
                                saveScores(_scores);
                              });
                            },
                            activeColor: Colors.red[700],
                            inactiveColor: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            height: 48,
            color: Colors.white,
            child: Center(
              child: FlatButton(
                color: Colors.red[700],
                textColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: const Text('高得点順に並び替え'),
                onPressed: () {
                  setState(() {
                    _scoreKeys.sort((a, b) => _scores[b]!.compareTo(_scores[a]!));
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
