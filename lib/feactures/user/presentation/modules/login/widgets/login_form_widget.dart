import 'package:flutter/material.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool rememberUser = true;
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [

          /// Usuario
          TextField(
            controller: userController,
            decoration: InputDecoration(
              hintText: "Usuario",
              prefixIcon: const Icon(Icons.person_outline),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 18),

          /// Contraseña
          TextField(
            controller: passwordController,
            obscureText: obscurePassword,
            decoration: InputDecoration(
              hintText: "Contraseña",
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                  });
                },
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 15),

          /// Recordar usuario
          Row(
            children: [
              Checkbox(
                value: rememberUser,
                activeColor: const Color(0xff0A4DBF),
                onChanged: (value) {
                  setState(() {
                    rememberUser = value!;
                  });
                },
              ),
              const Text("Recordar usuario"),
            ],
          ),

          const SizedBox(height: 8),

          /// Botón
          SizedBox(
            width: double.infinity,
            height: 55,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff0A3D91),
                    Color(0xff1A73E8),
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                icon: const Icon(Icons.login),
                label: const Text(
                  "INGRESAR",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                onPressed: () {},
              ),
            ),
          ),

          const SizedBox(height: 15),

          TextButton(
            onPressed: () {},
            child: const Text(
              "¿Olvidó su contraseña?",
              style: TextStyle(
                color: Color(0xff0A4DBF),
              ),
            ),
          ),

          const Divider(height: 40),

          /// Características
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [

              _FeatureItem(
                icon: Icons.verified_user_outlined,
                title: "Información\nsegura",
              ),

              _FeatureItem(
                icon: Icons.lock_outline,
                title: "Acceso\nconfiable",
              ),

              _FeatureItem(
                icon: Icons.access_time,
                title: "Respuesta\noportuna",
              ),
            ],
          ),

          const SizedBox(height: 25),

          Text(
            "Versión 2.0.0",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const _FeatureItem({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xffEAF2FF),
            child: Icon(
              icon,
              color: Color(0xff0A4DBF),
              size: 26,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}