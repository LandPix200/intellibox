// ignore_for_file: prefer_const_constructors

import 'package:async_button_builder/async_button_builder.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intellibox/modules/apis/ninja.dart';
import 'package:intellibox/modules/devinette/model.dart';
import 'package:intellibox/utils/theme.dart';

class DevinettePage extends StatefulWidget {
  const DevinettePage({super.key});

  @override
  State<DevinettePage> createState() => _DevinettePageState();
}

Devinette? devinette;

class _DevinettePageState extends State<DevinettePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          if (devinette != null)
            Expanded(
                child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  devinette!.title.toUpperCase(),
                  style: GoogleFonts.aBeeZee(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  devinette!.question,
                  style: GoogleFonts.aBeeZee(
                    fontSize: 18,
                    color: Colors.amber,
                  ),
                ),
                Divider(),
                Text(
                  devinette!.answer,
                  style: GoogleFonts.aBeeZee(
                    color: Colors.green,
                  ),
                ),
              ],
            )),
          AsyncButtonBuilder(
            child: MainButton(
              text: 'Générer',
            ),
            onPressed: () async {
              await _generate();
            },
            builder: (context, child, callback, buttonState) {
              return GestureDetector(
                onTap: callback,
                child: child,
              );
            },
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Future<void> _generate() async {
    Devinette? d = await Ninja.getDevinette(1);
    if (d != null) {
      await Devinette.translated(d).then((value) {
        setState(() {
          devinette = value;
        });
      });
    }
  }
}

class MainButton extends StatelessWidget {
  const MainButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
  });

  final String text;
  final Widget? icon;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return GFButton(
      icon: icon,
      onPressed: onPressed,
      text: text,
      color: Scolors.primary,
      splashColor: Scolors.bgColor.withOpacity(0.5),
      textStyle: GoogleFonts.aBeeZee(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Scolors.bgColor,
      ),
      fullWidthButton: true,
      size: 45,
    );
  }
}
