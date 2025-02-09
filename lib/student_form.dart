import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'main.dart';
import 'student_firestore.dart';

class FormStudent extends StatefulWidget {
  const FormStudent({super.key, this.student, this.studentId});

  final Map<String, dynamic>? student;
  final String? studentId;

  @override
  State<FormStudent> createState() => _FormStudentState();
}

class _FormStudentState extends State<FormStudent> {
  late TextEditingController _nimController;
  late TextEditingController _nameController;

  bool _validate = false;

  @override
  void dispose() {
    _nimController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _nimController = TextEditingController(text: widget.student?['nim'] ?? '');
    _nameController =
        TextEditingController(text: widget.student?['nama'] ?? '');

    super.initState();
  }

  Future<void> _saveStudent() async {
    if (widget.student != null) {
      await updateStudent(
        widget.studentId,
        _nimController.text,
        _nameController.text,
      );
    } else {
      await addStudent(
        _nimController.text,
        _nameController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Form Mahasiswa"),
      ),
      body: Container(
        margin: const EdgeInsets.all(6),
        child: Column(
          children: [
            TextField(
              controller: _nimController,
              decoration: InputDecoration(
                labelText: "NIM",
                border: const OutlineInputBorder(),
                errorText: _validate && _nimController.text.isEmpty
                    ? "NIM harus di isi."
                    : null,
              ),
              maxLength: 15,
              inputFormatters: [
                FilteringTextInputFormatter(RegExp('[0-9]'), allow: true)
              ],
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "NAMA",
                border: const OutlineInputBorder(),
                errorText: _validate && _nameController.text.isEmpty
                    ? "Nama harus di isi."
                    : null,
              ),
              maxLength: 30,
              inputFormatters: [
                FilteringTextInputFormatter(RegExp('[a-z A-Z]'), allow: true)
              ],
            ),
            ElevatedButton(
              onPressed: () async => {
                if (_nimController.text.isEmpty || _nameController.text.isEmpty)
                  {
                    setState(() {
                      _validate = true;
                    })
                  }
                else
                  {
                    setState(() {
                      _validate = false;
                    }),
                    _saveStudent(),
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text(
                          "Informasi",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Text(
                          "Berhasil ${widget.student == null ? "menambahkan" : "memperbarui"} data ${_nameController.value.text}",
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyApp(),
                                ),
                              );
                            },
                            child: const Text("OK"),
                          )
                        ],
                      ),
                    ),
                  },
              },
              child: Text(widget.student == null ? "SIMPAN" : "EDIT"),
            )
          ],
        ),
      ),
    );
  }
}
