import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:short_tales/screens/widgets/single_pdf.dart';

class PDFScreen extends StatefulWidget {
  PDFScreen({Key? key, required this.pdfUrls, required this.selected})
      : super(key: key);
  List pdfUrls;
  int selected;

  @override
  State<PDFScreen> createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  var controller;
  List<Widget> _pages = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<Widget> p = [];
    for (int i = 0; i < widget.pdfUrls.length; i++) {
      p.add(SinglePDF(url: widget.pdfUrls[i].toString()));
    }
    setState(() {
      _pages = p;
      controller = PageController(initialPage: widget.selected - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //color: Colors.black,
        height: MediaQuery.of(context).size.height,
        child: PageView(
          controller: controller,
          children: _pages,
        ),
      ),
    );
  }
}
