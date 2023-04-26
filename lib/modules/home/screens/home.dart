// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intellibox/models/tool/tool.dart';
import 'package:intellibox/modules/global/global_tool_page.dart';
import 'package:intellibox/utils/logic.dart';
import 'package:intellibox/utils/store.dart';
import 'package:intellibox/utils/theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("IntelliBox"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(_buildHeadText),
            Divider(
              color: Colors.grey.shade800,
            ),
            Expanded(
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                children: AppStore.tools
                    .map((e) => ToolCard(
                          tool: e,
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _buildHeadText =>
      "Des tonnes d'outils afin d'ameliorer ta productivité";
}

class ToolCard extends StatelessWidget {
  const ToolCard({
    super.key,
    required this.tool,
  });

  final Tool tool;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (tool.page == null) {
          return;
        }
        Nav.push(context, GlobalToolPage(tool: tool));
      },
      child: GFCard(
        elevation: 0,
        padding: EdgeInsets.all(2),
        color: Scolors.bgColor,
        colorFilter: ColorFilter.mode(
          Colors.black.withOpacity(0.6),
          BlendMode.darken,
        ),
        // title: GFListTile(
        //   margin: EdgeInsets.all(0),
        //   padding: EdgeInsets.all(0),
        //   color: Colors.transparent,
        //   title:
        // ),

        content: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Text(tool.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.aBeeZee(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ),
        showOverlayImage: true,
        imageOverlay: Image.asset(
          tool.image,
          width: 100,
          height: 100,
        ).image,
      ),
    );
  }
}
