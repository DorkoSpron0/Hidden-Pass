import 'package:flutter/material.dart';
import 'dart:math';



class PasswordForm extends StatefulWidget {
  const PasswordForm({Key? key}) : super(key: key);

  @override
  State<PasswordForm> createState() => _PasswordFormState();
}


class _PasswordFormState extends State<PasswordForm> {

  //LE puse valores por defecto tomando commo ejemplo Bitwarden
  bool _showPassword = false;
  double _sliderValue = 15;
  bool _numeros = true;
  bool _simbolos = false;
  bool _minusculas = true;
  bool _mayusculas = true;


  @override
  Widget build(BuildContext context) {
  
    final focusNode = FocusNode();

    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: <Widget>[
          const Text('Nombre', style: TextStyle(color: Colors.white)), 
        TextFormField(
          onTapOutside: (event) {focusNode.unfocus();},
          focusNode:focusNode,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white),
              ),
            hintText: 'Nombre de la cuenta', 
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: const Color(0xFF575757),
            

          ),
        ),

          const Text('Sitio web', style: TextStyle(color: Colors.white)),
          TextFormField(
            onTapOutside: (event) {focusNode.unfocus();},
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white),
              ),
              hintText: 'Ingresa el URL de la pagina',
              hintStyle: const TextStyle(color: Colors.grey), 
              filled: true,
              fillColor: const Color(0xFF575757),
            ),
          ),
          const SizedBox(height: 16.0),
          const Text('Email', style: TextStyle(color: Colors.white)),
          TextFormField(
            onTapOutside: (event) {focusNode.unfocus();},
            style: const TextStyle(color: Colors.white),
            
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white),
              ),
              hintText: 'tucorreo@gmail.com',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF575757),
              
              
            ),
          ),
          const SizedBox(height: 24.0), 
          const Text('Contraseña', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  onTapOutside: (event) {focusNode.unfocus();},
                  style: const TextStyle(color: Colors.white),
                  obscureText: !_showPassword,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white),
              ),
                    hintText: 'GhYjmJUynNJ.Mhn',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFF575757),

                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
                icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
              ),
            ],
          ),

          const SizedBox(height: 18),
          const Text('Caracteres', style: TextStyle(color: Colors.white)),
          Slider(
            value: _sliderValue,
            min: 8,
            max: 30,
            divisions: 22, 
            label: _sliderValue.round().toString(),
            activeColor: Colors.blue, 
            inactiveColor: Colors.grey, 
            onChanged: (double value) {
              setState(() {
                _sliderValue = value;
              });
            },
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, 
            children: [
              Row(children: [
                Checkbox(
                  value: _numeros,
                  onChanged: (bool? value) {
                    setState(() {
                      _numeros = value!;
                    });
                  },
                ),
                const Text('Numeros', style: TextStyle(color: Colors.white)),
              ]),
              Row(children: [
                Checkbox(
                  value: _simbolos,
                  onChanged: (bool? value) {
                    setState(() {
                      _simbolos = value!;
                    });
                  },
                ),
                const Text('Simbolos  ', style: TextStyle(color: Colors.white)),
              ]),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Checkbox(
                  value: _minusculas,
                  onChanged: (bool? value) {
                    setState(() {
                      _minusculas = value!;
                    });
                  },
                ),
                const Text('Minúsculas', style: TextStyle(color: Colors.white)),
              ]),
              Row(children: [
                Checkbox(
                  value: _mayusculas,
                  onChanged: (bool? value) {
                    setState(() {
                      _mayusculas = value!;
                    });
                  },
                ),
                const Text('Mayúscula', style: TextStyle(color: Colors.white)),
              ]),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              // Acción al guardar
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, 
              minimumSize: const Size.fromHeight(50), 
            ),
            child: const Text('Generar contraseña', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // Acción al generar contraseña
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, 
              minimumSize: const Size.fromHeight(50), 
            ),
            child: const Text('Guardar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}