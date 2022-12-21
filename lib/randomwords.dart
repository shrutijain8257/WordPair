import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class randomWords extends StatefulWidget {
  @override
  randomWordsState createState() => randomWordsState();
}

class randomWordsState extends State<randomWords> {
  final randomWords = <WordPair>[];
  final savedWord = Set<WordPair>();

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, item) {
        if (item.isOdd) return Divider();

        final index = item ~/ 2;
        if (index >= randomWords.length) {
          randomWords.addAll(generateWordPairs().take(10));
        }

        return _buildRow(randomWords[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = savedWord.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: TextStyle(fontSize: 18.0),
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            savedWord.remove(pair);
          } else {
            savedWord.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = savedWord.map((WordPair pair) {
            return ListTile(
              title: Text(
                pair.asPascalCase,
                style: TextStyle(fontSize: 16.0),
              ),
            );
          });
          final List<Widget> divided =
              ListTile.divideTiles(context: context, tiles: tiles).toList();

          return Scaffold(
            appBar: AppBar(title: Text('Saved WordPairs')),
            body: ListView(
              children: divided,
            ),
          );
        },
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WordPair Generator'),
        actions: <Widget>[
          IconButton(
            onPressed: _pushSaved,
            icon: Icon(Icons.list),
          )
        ],
      ),
      body: _buildList(),
    );
  }
}
