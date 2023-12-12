import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:project_belanjakan/model/transaction.dart';
import 'package:project_belanjakan/model/user.dart';
import 'package:project_belanjakan/view/receipt/custom_row_invoice.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:project_belanjakan/view/receipt/preview_screen.dart';
import 'package:project_belanjakan/view/receipt/item_doc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Future<void> createPdf(
    User user, Transaction transaction, BuildContext context) async {
  final doc = pw.Document();
  final now = DateTime.now();
  final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

  final pdfTheme = pw.PageTheme(
    pageFormat: PdfPageFormat.a4,
    buildBackground: (pw.Context context) {
      return pw.Container(
        decoration: pw.BoxDecoration(
          border: pw.Border.all(
            color: PdfColor.fromHex('#FFBD59'),
            width: 1.w,
          ),
        ),
      );
    },
  );

  List<CustomRow> generatElements() {
    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ');
    List<CustomRow> elements = [];
    elements.add(
        CustomRow('Item Name', 'Item Price', 'Amount', 'Sub Total Product'));
    int total = 0;
    for (DetailTransaction item in transaction.listDetails!) {
      elements.add(CustomRow(
          item.name,
          currencyFormat.format(item.price),
          item.amount.toString(),
          currencyFormat.format(item.price * item.amount).toString()));
      total += item.price * item.amount;
    }
    elements.add(CustomRow(
      "Diskon",
      "",
      "",
      '- ${currencyFormat.format(total * transaction.discount / 100)}',
    ));
    elements.add(CustomRow(
      "Total",
      "",
      "",
      currencyFormat
          .format((total - (total * transaction.discount / 100)))
          .toString(),
    ));
    return elements;
  }

  final List<CustomRow> elements = generatElements();
  pw.Widget table = itemColumn(elements);

  doc.addPage(
    pw.MultiPage(
      pageTheme: pdfTheme,
      header: (pw.Context context) {
        return headerPDF();
      },
      build: (pw.Context context) {
        return [
          pw.Center(
            child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Container(
                    margin:
                        pw.EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
                  ),
                  personalDataFromInput(user, transaction.address),
                  pw.SizedBox(height: 3.h),
                  barcodeGaris(transaction.createdAt),
                  pw.SizedBox(height: 3.h),
                  contentOfInvoice(table),
                  barcodeKotak(transaction.createdAt),
                  pw.SizedBox(height: 1.h),
                ]),
          ),
        ];
      },
      footer: (pw.Context context) {
        return pw.Container(
            color: PdfColor.fromHex('#FFBD59'),
            child: footerPDF(formattedDate));
      },
    ),
  );

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PreviewScreen(doc: doc),
    ),
  );
}

pw.Header headerPDF() {
  return pw.Header(
    margin: pw.EdgeInsets.zero,
    outlineColor: PdfColors.amber50,
    outlineStyle: PdfOutlineStyle.normal,
    level: 5,
    decoration: pw.BoxDecoration(
      shape: pw.BoxShape.rectangle,
      gradient: pw.LinearGradient(
        colors: [PdfColor.fromHex('#FCDF8A'), PdfColor.fromHex('#F38381')],
        begin: pw.Alignment.topLeft,
        end: pw.Alignment.bottomRight,
      ),
    ),
    child: pw.Center(
      child: pw.Text(
        '-Receipt-',
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12.sp),
      ),
    ),
  );
}

pw.Padding personalDataFromInput(User user, String address) {
  return pw.Padding(
    padding: pw.EdgeInsets.symmetric(horizontal: 5.h, vertical: 1.h),
    child: pw.Table(
      border: pw.TableBorder.all(),
      children: [
        pw.TableRow(
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
              child: pw.Text(
                'Name',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10.sp,
                ),
              ),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
              child: pw.Text(
                user.name,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
              child: pw.Text(
                'Phone Number',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10.sp,
                ),
              ),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
              child: pw.Text(
                user.phone,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
              child: pw.Text(
                'Email',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold, fontSize: 10.sp),
              ),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
              child: pw.Text(
                user.email,
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold, fontSize: 10.sp),
              ),
            ),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
              child: pw.Text(
                'Address',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold, fontSize: 10.sp),
              ),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
              child: pw.Text(
                address,
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold, fontSize: 10.sp),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

pw.Padding contentOfInvoice(pw.Widget table) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(8.0),
    child: pw.Column(children: [
      pw.Text(
          'Dear Customer, thank you for buying our product, we hope the products can make your day.'),
      pw.SizedBox(height: 3.h),
      table,
      pw.SizedBox(height: 5.h),
      pw.Text('Thanks for your trust, and till the next time.'),
      pw.SizedBox(height: 2.h),
      pw.Text('Kind regards,'),
      pw.SizedBox(height: 2.h),
      pw.Text('Belanjakan'),
    ]),
  );
}

pw.Padding barcodeKotak(String id) {
  return pw.Padding(
      padding: pw.EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
      child: pw.Center(
          child: pw.BarcodeWidget(
              barcode: pw.Barcode.qrCode(
                  errorCorrectLevel: BarcodeQRCorrectionLevel.high),
              data: id,
              width: 15.w,
              height: 15.h)));
}

pw.Container barcodeGaris(String id) {
  return pw.Container(
    child: pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 2.h, horizontal: 1.h),
      child: pw.BarcodeWidget(
          barcode: Barcode.code128(escapes: true),
          data: id,
          width: 10.w,
          height: 5.h),
    ),
  );
}

pw.Center footerPDF(String formattedDate) {
  return pw.Center(
      child: pw.Text('Created At $formattedDate',
          style: pw.TextStyle(fontSize: 10.sp, color: PdfColors.blue)));
}
