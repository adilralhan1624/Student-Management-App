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
      title: 'Student Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const StudentFormPage(),
    );
  }
}

class StudentFormPage extends StatefulWidget {
  const StudentFormPage({super.key});

  @override
  State<StudentFormPage> createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rollController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cgpaController = TextEditingController();

  final String baseUrl = "http://192.168.1.7/student_api";

  bool _isLoading = false;
  List<dynamic> _students = [];
  bool _showStudents = false;

  // ── Gradient Colors ──
  final gradient = const LinearGradient(
    colors: [Color(0xFF1a0033), Color(0xFF6a0dad)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/insert_student.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": _nameController.text.trim(),
          "roll_number": _rollController.text.trim(),
          "email": _emailController.text.trim(),
          "cgpa": _cgpaController.text.trim(),
        }),
      );
      final result = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result["message"],
              style: const TextStyle(color: Colors.white)),
          backgroundColor:
              result["success"] ? Colors.green.shade700 : Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      if (result["success"]) {
        _formKey.currentState!.reset();
        _nameController.clear();
        _rollController.clear();
        _emailController.clear();
        _cgpaController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    setState(() => _isLoading = false);
  }

  Future<void> _fetchStudents() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/fetch_students.php"),
      );
      final result = jsonDecode(response.body);
      if (result["success"]) {
        setState(() {
          _students = result["data"];
          _showStudents = true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    setState(() => _isLoading = false);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.purple),
        prefixIcon: Icon(icon, color: Colors.purpleAccent),
        filled: true,
        fillColor: Colors.white.withOpacity(0.08),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.purple, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Colors.purpleAccent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        errorStyle: const TextStyle(color: Colors.redAccent),
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──
                const SizedBox(height: 20),
                const Center(
                  child: Icon(Icons.school,
                      size: 60, color: Colors.purpleAccent),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    "Student Management",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    "Register & View Students",
                    style: TextStyle(
                        color: Colors.purpleAccent, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 30),

                // ── Form Card ──
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.purple.withOpacity(0.5), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Student Registration",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.purpleAccent,
                              Colors.transparent
                            ]),
                          ),
                        ),
                        const SizedBox(height: 20),

                        _buildTextField(
                          controller: _nameController,
                          label: "Full Name",
                          icon: Icons.person,
                          validator: (v) =>
                              v!.isEmpty ? "Please enter name" : null,
                        ),
                        const SizedBox(height: 14),

                        _buildTextField(
                          controller: _rollController,
                          label: "Roll Number",
                          icon: Icons.badge,
                          validator: (v) =>
                              v!.isEmpty ? "Please enter roll number" : null,
                        ),
                        const SizedBox(height: 14),

                        _buildTextField(
                          controller: _emailController,
                          label: "Email ID",
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v!.isEmpty) return "Please enter email";
                            if (!v.contains("@")) return "Enter valid email";
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        _buildTextField(
                          controller: _cgpaController,
                          label: "CGPA",
                          icon: Icons.grade,
                          keyboardType:
                              const TextInputType.numberWithOptions(
                                  decimal: true),
                          validator: (v) {
                            if (v!.isEmpty) return "Please enter CGPA";
                            final cgpa = double.tryParse(v);
                            if (cgpa == null || cgpa < 0 || cgpa > 10)
                              return "Enter valid CGPA (0-10)";
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // ── Submit Button ──
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF6a0dad),
                                Color(0xFF9b30ff)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.5),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _submitForm,
                            icon: const Icon(Icons.save, color: Colors.white),
                            label: const Text("Submit",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // ── Show Details Button ──
                        OutlinedButton.icon(
                          onPressed: _isLoading ? null : _fetchStudents,
                          icon: const Icon(Icons.list,
                              color: Colors.purpleAccent),
                          label: const Text("Show Details",
                              style: TextStyle(
                                  color: Colors.purpleAccent,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(
                                color: Colors.purpleAccent, width: 1.5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Loading ──
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(
                          color: Colors.purpleAccent),
                    ),
                  ),

                // ── Students List ──
                if (_showStudents && _students.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text(
                    "All Students",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _students.length,
                    itemBuilder: (context, index) {
                      final s = _students[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: Colors.purple.withOpacity(0.4)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.2),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: Colors.purpleAccent,
                            radius: 24,
                            child: Text(
                              s["name"][0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          title: Text(
                            s["name"],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text("🎓 Roll: ${s["roll_number"]}",
                                  style: const TextStyle(
                                      color: Colors.purpleAccent)),
                              Text("📧 ${s["email"]}",
                                  style: const TextStyle(
                                      color: Colors.white70)),
                              Text("⭐ CGPA: ${s["cgpa"]}",
                                  style: const TextStyle(
                                      color: Colors.purpleAccent)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],

                if (_showStudents && _students.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Text("No students found.",
                          style: TextStyle(color: Colors.white54)),
                    ),
                  ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}