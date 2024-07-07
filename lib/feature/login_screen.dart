// import 'package:coach_web/model/auth_model.dart';
// import 'package:coach_web/service/api_service.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'main_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   bool isRegister = false;
//   bool isPasswordVisible = false;
//   final ApiService apiService = ApiService();
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController fullNameController = TextEditingController();
//   String? selectedRole;

//   void toggleForm() {
//     setState(() {
//       isRegister = !isRegister;
//     });
//   }

//   void togglePasswordVisibility() {
//     setState(() {
//       isPasswordVisible = !isPasswordVisible;
//     });
//   }

//   Future<void> _handleRegister() async {
//     final user = User(
//       username: usernameController.text,
//       password: passwordController.text,
//       fullName: fullNameController.text,
//       role: selectedRole,
//     );
//     final response = await apiService.register(user);
//     if (response.statusCode == 201) {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Success'),
//           content: Text('Account registered successfully.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 toggleForm();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     } else {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Error'),
//           content: Text('Failed to register account.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   Future<void> _handleLogin() async {
//     final response = await apiService.login(
//       usernameController.text,
//       passwordController.text,
//     );
//     if (response.statusCode == 200) {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => MainScreen()),
//       );
//     } else {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Error'),
//           content: Text('Invalid username or password.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 60, right: 60),
//               child: Menu(
//                 isRegister: isRegister,
//                 onToggle: toggleForm,
//               ),
//             ),
//             Body(
//               isRegister: isRegister,
//               toggleForm: toggleForm,
//               usernameController: usernameController,
//               passwordController: passwordController,
//               fullNameController: fullNameController,
//               selectedRole: selectedRole,
//               onRoleChanged: (value) {
//                 setState(() {
//                   selectedRole = value;
//                 });
//               },
//               onRegister: _handleRegister,
//               onLogin: _handleLogin,
//               isPasswordVisible: isPasswordVisible,
//               togglePasswordVisibility: togglePasswordVisibility,
//             ),
//             SizedBox(height: 50),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Menu extends StatelessWidget {
//   final bool isRegister;
//   final VoidCallback onToggle;

//   const Menu({required this.isRegister, required this.onToggle});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 30),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Row(
//             children: [
//               _menuItem(
//                   title: 'Masuk', isActive: !isRegister, onToggle: onToggle),
//               _menuItem(
//                   title: 'Daftar', isActive: isRegister, onToggle: onToggle),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _menuItem(
//       {required String title,
//       required bool isActive,
//       required VoidCallback onToggle}) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 75),
//       child: GestureDetector(
//         onTap: onToggle,
//         child: MouseRegion(
//           cursor: SystemMouseCursors.click,
//           child: Column(
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: isActive ? Colors.deepPurple : Colors.grey,
//                 ),
//               ),
//               const SizedBox(
//                 height: 6,
//               ),
//               isActive
//                   ? Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 2),
//                       decoration: BoxDecoration(
//                         color: Colors.deepPurple,
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     )
//                   : const SizedBox(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class Body extends StatelessWidget {
//   final bool isRegister;
//   final VoidCallback toggleForm;
//   final TextEditingController usernameController;
//   final TextEditingController passwordController;
//   final TextEditingController fullNameController;
//   final String? selectedRole;
//   final ValueChanged<String?> onRoleChanged;
//   final VoidCallback onRegister;
//   final VoidCallback onLogin;
//   final bool isPasswordVisible;
//   final VoidCallback togglePasswordVisibility;

//   Body({
//     required this.isRegister,
//     required this.toggleForm,
//     required this.usernameController,
//     required this.passwordController,
//     required this.fullNameController,
//     required this.selectedRole,
//     required this.onRoleChanged,
//     required this.onRegister,
//     required this.onLogin,
//     required this.isPasswordVisible,
//     required this.togglePasswordVisibility,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         const Text(
//           'Selamat Datang Di',
//           style: TextStyle(
//             fontSize: 45,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const Text(
//           'Aplikasi Sistem Pendukung Keputusan Pemilihan Pemain Inti Tim Futsal',
//           style: TextStyle(
//             fontSize: 30,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         Image.asset('assets/images/logo_white.png', width: 200, height: 200),
//         const SizedBox(
//           height: 30,
//         ),
//         Container(
//           width: 320,
//           child: isRegister ? _formRegister() : _formLogin(),
//         ),
//         const SizedBox(height: 30),
//         Text(
//           isRegister ? "Sudah Mempunyai Akun?" : "Anda Belum Mempunyai Akun?",
//           style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),
//         GestureDetector(
//           onTap: toggleForm,
//           child: Text(
//             isRegister ? "Masuk Disini!" : "Daftar Disini!",
//             style: const TextStyle(
//                 color: Colors.deepPurple, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _formLogin() {
//     return Column(
//       children: [
//         TextField(
//           controller: usernameController,
//           decoration: InputDecoration(
//             hintText: 'Enter email or Phone number',
//             hintStyle: TextStyle(color: Colors.grey),
//             filled: true,
//             fillColor: Colors.blueGrey[50],
//             labelStyle: const TextStyle(fontSize: 12),
//             contentPadding: const EdgeInsets.only(left: 30),
//             enabledBorder: OutlineInputBorder(
//               borderSide: const BorderSide(color: Colors.blueGrey),
//               borderRadius: BorderRadius.circular(15),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderSide: const BorderSide(color: Colors.blueGrey),
//               borderRadius: BorderRadius.circular(15),
//             ),
//           ),
//           style: TextStyle(color: Colors.black),
//         ),
//         const SizedBox(height: 30),
//         TextField(
//           controller: passwordController,
//           obscureText: !isPasswordVisible,
//           decoration: InputDecoration(
//             hintText: 'Password',
//             hintStyle: TextStyle(color: Colors.grey),
//             suffixIcon: GestureDetector(
//               onTap: togglePasswordVisibility,
//               child: Icon(
//                 isPasswordVisible
//                     ? Icons.visibility
//                     : Icons.visibility_off_outlined,
//                 color: Colors.grey,
//               ),
//             ),
//             filled: true,
//             fillColor: Colors.blueGrey[50],
//             labelStyle: const TextStyle(fontSize: 12),
//             contentPadding: const EdgeInsets.only(left: 30),
//             enabledBorder: OutlineInputBorder(
//               borderSide: const BorderSide(color: Colors.blueGrey),
//               borderRadius: BorderRadius.circular(15),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderSide: const BorderSide(color: Colors.blueGrey),
//               borderRadius: BorderRadius.circular(15),
//             ),
//           ),
//           style: TextStyle(color: Colors.black),
//         ),
//         const SizedBox(height: 40),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(30),
//             boxShadow: [
//               const BoxShadow(
//                 color: Colors.deepPurple,
//                 spreadRadius: 10,
//                 blurRadius: 20,
//               ),
//             ],
//           ),
//           child: ElevatedButton(
//             child: Container(
//                 width: double.infinity,
//                 height: 50,
//                 child: const Center(child: Text("Sign In"))),
//             onPressed: onLogin,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.deepPurple,
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 40),
//       ],
//     );
//   }

//   Widget _formRegister() {
//     final List<String> roles = ['Pelatih', 'Asisten Pelatih', 'Pemain'];

//     return Column(
//       children: [
//         TextField(
//           controller: usernameController,
//           decoration: InputDecoration(
//             hintText: 'Enter email or Phone number',
//             hintStyle: TextStyle(color: Colors.grey),
//             filled: true,
//             fillColor: Colors.blueGrey[50],
//             labelStyle: const TextStyle(fontSize: 12),
//             contentPadding: const EdgeInsets.only(left: 30),
//             enabledBorder: OutlineInputBorder(
//               borderSide: const BorderSide(color: Colors.blueGrey),
//               borderRadius: BorderRadius.circular(15),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderSide: const BorderSide(color: Colors.blueGrey),
//               borderRadius: BorderRadius.circular(15),
//             ),
//           ),
//           style: TextStyle(color: Colors.black),
//         ),
//         const SizedBox(height: 30),
//         TextField(
//           controller: passwordController,
//           obscureText: !isPasswordVisible,
//           decoration: InputDecoration(
//             hintText: 'Password',
//             hintStyle: TextStyle(color: Colors.grey),
//             suffixIcon: GestureDetector(
//               onTap: togglePasswordVisibility,
//               child: Icon(
//                 isPasswordVisible
//                     ? Icons.visibility
//                     : Icons.visibility_off_outlined,
//                 color: Colors.grey,
//               ),
//             ),
//             filled: true,
//             fillColor: Colors.blueGrey[50],
//             labelStyle: const TextStyle(fontSize: 12),
//             contentPadding: const EdgeInsets.only(left: 30),
//             enabledBorder: OutlineInputBorder(
//               borderSide: const BorderSide(color: Colors.blueGrey),
//               borderRadius: BorderRadius.circular(15),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderSide: const BorderSide(color: Colors.blueGrey),
//               borderRadius: BorderRadius.circular(15),
//             ),
//           ),
//           style: TextStyle(color: Colors.black),
//         ),
//         const SizedBox(height: 30),
//         TextField(
//           controller: fullNameController,
//           decoration: InputDecoration(
//             hintText: 'Full Name',
//             hintStyle: TextStyle(color: Colors.grey),
//             filled: true,
//             fillColor: Colors.blueGrey[50],
//             labelStyle: const TextStyle(fontSize: 12),
//             contentPadding: const EdgeInsets.only(left: 30),
//             enabledBorder: OutlineInputBorder(
//               borderSide: const BorderSide(color: Colors.blueGrey),
//               borderRadius: BorderRadius.circular(15),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderSide: const BorderSide(color: Colors.blueGrey),
//               borderRadius: BorderRadius.circular(15),
//             ),
//           ),
//           style: TextStyle(color: Colors.black),
//         ),
//         const SizedBox(height: 30),
//         DropdownButtonFormField<String>(
//           decoration: InputDecoration(
//             hintText: 'Role',
//             hintStyle: TextStyle(color: Colors.grey),
//             filled: true,
//             fillColor: Colors.blueGrey[50],
//             labelStyle: const TextStyle(fontSize: 12),
//             contentPadding: const EdgeInsets.only(left: 30),
//             enabledBorder: OutlineInputBorder(
//               borderSide: const BorderSide(color: Colors.blueGrey),
//               borderRadius: BorderRadius.circular(15),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderSide: const BorderSide(color: Colors.blueGrey),
//               borderRadius: BorderRadius.circular(15),
//             ),
//           ),
//           items: roles
//               .map((role) => DropdownMenuItem(
//                     value: role,
//                     child: Text(role, style: TextStyle(color: Colors.black)),
//                   ))
//               .toList(),
//           onChanged: onRoleChanged,
//           value: selectedRole,
//           style: TextStyle(
//               color: selectedRole != null ? Colors.black : Colors.grey),
//         ),
//         const SizedBox(height: 40),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(30),
//             boxShadow: [
//               const BoxShadow(
//                 color: Colors.deepPurple,
//                 spreadRadius: 10,
//                 blurRadius: 20,
//               ),
//             ],
//           ),
//           child: ElevatedButton(
//             child: Container(
//                 width: double.infinity,
//                 height: 50,
//                 child: const Center(child: Text("Register"))),
//             onPressed: onRegister,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.deepPurple,
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 40),
//       ],
//     );
//   }
// }
