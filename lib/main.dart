import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bhasha Translator',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const TranslatorScreen(),
    );
  }
}

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final TextEditingController _textController = TextEditingController();
  String _translatedText = "";
  String _from = "en";
  String _to = "hi";

  Future<void> translateText() async {
    final url = Uri.parse("https://libretranslate.de/translate");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "q": _textController.text,
        "source": _from,
        "target": _to,
        "format": "text"
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _translatedText = jsonDecode(response.body)["translatedText"];
      });
    } else {
      setState(() {
        _translatedText = "Error: ${response.statusCode}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🗣️ Bhasha Translator"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter text",
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: _from,
                  items: const [
                    DropdownMenuItem(value: "en", child: Text("English")),
                    DropdownMenuItem(value: "hi", child: Text("Hindi")),
                    DropdownMenuItem(value: "ta", child: Text("Tamil")),
                    DropdownMenuItem(value: "bn", child: Text("Bengali")),
                    DropdownMenuItem(value: "gu", child: Text("Gujarati")),
                  ],
                  onChanged: (val) {
                    setState(() => _from = val!);
                  },
                ),
                const Icon(Icons.arrow_forward),
                DropdownButton<String>(
                  value: _to,
                  items: const [
                    DropdownMenuItem(value: "hi", child: Text("Hindi")),
                    DropdownMenuItem(value: "en", child: Text("English")),
                    DropdownMenuItem(value: "ta", child: Text("Tamil")),
                    DropdownMenuItem(value: "bn", child: Text("Bengali")),
                    DropdownMenuItem(value: "gu", child: Text("Gujarati")),
                  ],
                  onChanged: (val) {
                    setState(() => _to = val!);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: translateText,
              child: const Text("Translate"),
            ),
            const SizedBox(height: 20),
            Text(
              _translatedText,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
