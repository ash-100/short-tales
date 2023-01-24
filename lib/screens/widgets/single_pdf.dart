import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:short_tales/controllers/pdf_controller.dart';

class SinglePDF extends StatefulWidget {
  SinglePDF({Key? key, required this.url}) : super(key: key);
  String url;

  @override
  State<SinglePDF> createState() => _SinglePDFState();
}

class _SinglePDFState extends State<SinglePDF> {
  String _localFile = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PDFController.loadPdf(widget.url).then((value) {
      setState(() {
        _localFile = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _localFile != ""
        ? PDFView(
            defaultPage: 0,
            filePath: _localFile,
          )
        : Center(
            child: CircularProgressIndicator(),
          );
    // return Center(
    //   child: Text(widget.url),
    // );
  }
}
