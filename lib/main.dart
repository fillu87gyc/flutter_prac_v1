import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: RandomWords());
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final List<WordPair> _suggestions = <WordPair>[];
  final _saved = Set<WordPair>(); // NEW
  final TextStyle _biggerFontSize = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Add from here...
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    ); // ... to here.
  }

  void _pushSaved() {
    Fluttertoast.showToast(
        msg: "This is Center Short Toast",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.of(context).push(MaterialPageRoute<void>(
        // ignore: missing_return
        builder: (BuildContext context) {
      final tiles = _saved.map(
        (WordPair pair) {
          return ListTile(
            title: Text(
              pair.asPascalCase,
              style: _biggerFontSize,
            ),
          );
        }, //WordPair
      ); //map
      final divided = ListTile.divideTiles(
        context: context,
        tiles: tiles,
      ).toList();

      return Scaffold(
        appBar: AppBar(
          title: Text('Saved Suggestions'),
        ),
        body: ListView(children: divided),
      );
    }));
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair); // NEW
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFontSize,
      ),
      trailing: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      }, //onTap
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(0),
        itemBuilder: (BuildContext _content, int i) {
          if (i.isOdd) {
            return Divider(
              thickness: 2.0,
            );
          }
          final int index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }
}
