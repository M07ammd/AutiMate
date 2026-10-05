/*import 'package:flutter/material.dart';
import '../../../services/api_service.dart';

class VerificationEmailScreen extends StatefulWidget {
  const VerificationEmailScreen({super.key});

  @override
  State<VerificationEmailScreen> createState() =>
      _VerificationEmailScreenState();
}

class _VerificationEmailScreenState extends State<VerificationEmailScreen> {
  final List<TextEditingController> codeControllers =
  List.generate(6, (_) => TextEditingController());

  String getCode() {
    return codeControllers.map((e) => e.text).join();
  }

  @override
  Widget build(BuildContext context) {
    final String email =
        ModalRoute.of(context)?.settings.arguments as String? ?? "";

    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          const SizedBox(height: 50),

          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          const SizedBox(height: 10),

          const Text(
            "Verification Email",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D3557),
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "Please enter the code we just sent to your email",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.black54),
          ),

          const SizedBox(height: 40),
          Wrap(
            alignment: WrapAlignment.center,
            children: List.generate(6, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: 45,
                height: 55,
                child: TextField(
                  controller: codeControllers[index],
                  maxLength: 1,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(counterText: ""),
                ),
              );
            }),
          ),

          const SizedBox(height: 20),

          GestureDetector(
            onTap: () async {
              await ApiService.requestOtp(email);
              print("RESEND OTP ✔️");
            },
            child: const Text(
              "Resend",
              style: TextStyle(
                color: Color(0xFF1D3557),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 40),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  String code = getCode();

                  if (email.isEmpty) return;

                  try {
                    var response = await ApiService.verifyOtp(
                      email: email,
                      code: code,
                    );

                    print("VERIFY RESPONSE 👉 ${response.data}");

                    String resetToken = response.data["resetToken"];

                    Navigator.pushNamed(
                      context,
                      "/updatePassword",
                      arguments: resetToken,
                    );
                  } catch (e) {
                    print("VERIFY ERROR ❌ $e");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF45BB89),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import '../../../services/api_service.dart';

class VerificationEmailScreen extends StatefulWidget {
  const VerificationEmailScreen({super.key});

  @override
  State<VerificationEmailScreen> createState() =>
      _VerificationEmailScreenState();
}

class _VerificationEmailScreenState extends State<VerificationEmailScreen> {
  final List<TextEditingController> codeControllers =
  List.generate(6, (_) => TextEditingController());

  final List<FocusNode> focusNodes =
  List.generate(6, (_) => FocusNode());

  bool loading = false;
  String? error;

  String getCode() {
    return codeControllers.map((e) => e.text).join();
  }

  bool isCodeValid() {
    return getCode().length == 6 && !getCode().contains(" ");
  }

  @override
  void dispose() {
    for (var c in codeControllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String email =
        ModalRoute.of(context)?.settings.arguments as String? ?? "";

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 50),

          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          const SizedBox(height: 10),

          const Text(
            "Verification Email",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D3557),
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "Please enter the code we just sent to your email",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.black54),
          ),

          const SizedBox(height: 40),

          Wrap(
            alignment: WrapAlignment.center,
            children: List.generate(6, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: 45,
                height: 55,
                child: TextField(
                  controller: codeControllers[index],
                  focusNode: focusNodes[index],
                  maxLength: 1,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,

                  onChanged: (value) {
                    setState(() => error = null);

                    if (value.isNotEmpty) {
                      if (index < 5) {
                        FocusScope.of(context)
                            .requestFocus(focusNodes[index + 1]);
                      } else {
                        focusNodes[index].unfocus();
                      }
                    } else {
                      if (index > 0) {
                        FocusScope.of(context)
                            .requestFocus(focusNodes[index - 1]);
                      }
                    }
                  },

                  decoration: InputDecoration(
                    counterText: "",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: error != null ? Colors.red : Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: error != null
                            ? Colors.red
                            : const Color(0xFF45BB89),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 10),

          if (error != null)
            Text(
              error!,
              style: const TextStyle(color: Colors.red),
            ),

          const SizedBox(height: 20),

          GestureDetector(
            onTap: () async {
              await ApiService.requestOtp(email);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("OTP Resent ✔️")),
              );
            },
            child: const Text(
              "Resend",
              style: TextStyle(
                color: Color(0xFF1D3557),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 40),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: loading
                    ? null
                    : () async {
                  String code = getCode();

                  if (!isCodeValid()) {
                    setState(() {
                      error = "Enter full 6-digit code";
                    });
                    return;
                  }

                  setState(() => loading = true);

                  try {
                    var response = await ApiService.verifyOtp(
                      email: email,
                      code: code,
                    );

                    String resetToken =
                    response.data["resetToken"];

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Verified ✔️"),
                      ),
                    );

                    Navigator.pushNamed(
                      context,
                      "/updatePassword",
                      arguments: resetToken,
                    );
                  } catch (e) {
                    setState(() {
                      error = "Invalid code";
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Verification failed"),
                      ),
                    );
                  }

                  setState(() => loading = false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF45BB89),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: loading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text(
                  "Continue",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}