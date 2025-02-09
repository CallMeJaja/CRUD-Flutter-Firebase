import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_student_with_firebase/student_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'student_form.dart';

Future<void> main() async {
  /*
  * Collection: mhs
  * fields: nim, nama
  */
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
          options: FirebaseOptions(
              apiKey: dotenv.env['API_KEY_FIREBASE']!,
              appId: dotenv.env['APP_ID']!,
              messagingSenderId: "61722625836",
              projectId: "mahasiswa-3130d"))
      .catchError((onError) => debug("Error Initialize Firebase: $onError"));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Mahasiswa',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Data Mahasiswa'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List studentData = [];

  @override
  void initState() {
    super.initState();
    fetchStudents().then((data) {
      for (var element in data) {
        setState(() {
          studentData.add(element);
        });
      }
      debug(studentData.toString());
    });
  }

  void _confirmDelete(String productId, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi"),
          content: const Text("Apakah Anda yakin ingin menghapus data ini?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Tidak"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await deleteStudent(productId);
                setState(() {
                  studentData.removeAt(index);
                });
              },
              child: const Text("Ya"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(6),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const FormStudent();
                }));
              },
              child: const Text("Tambah Mahasiswa"),
            ),
          ),
          Expanded(
            child: studentData.isEmpty
                ? const Center(
                    child: Text(
                      "Tidak ada data",
                    ),
                  )
                : ListView.builder(
                    itemCount: studentData.length,
                    itemBuilder: (context, index) {
                      var row = studentData[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 6),
                        child: ListTile(
                          leading: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FormStudent(
                                    studentId: row['id'],
                                    student: row,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          title: Row(
                            children: [
                              Icon(Icons.person),
                              SizedBox(width: 6),
                              Text(row['nama']),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.numbers_sharp),
                                  SizedBox(width: 6),
                                  Text(row['nim']),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () => _confirmDelete(row['id'], index),
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
