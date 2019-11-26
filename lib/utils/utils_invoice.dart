import 'package:flutter/cupertino.dart';
import 'package:naapos/data/database_helper.dart';
import 'package:naapos/data/entities.dart';
import 'package:naapos/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class InvoiceHelpers {
  //Insert invoice into database table
  static void insert(
      Invoice invoice, List<Item> items, dbHelper, BuildContext context) async {
    // row to insert in invoice table
    Map<String, dynamic> row = {
      DatabaseHelper.columnInvoiceNumber: invoice.invoiceNumber,
      DatabaseHelper.columnOperatorId: invoice.operatorId,
      DatabaseHelper.columnInvoiceDateTime: invoice.invoiceDateTime,
      DatabaseHelper.columnStoreId: invoice.storeId,
      DatabaseHelper.columnInvoiceAmount: invoice.invoiceAmount,
      DatabaseHelper.columnInvoiceTax: invoice.invoiceTax,
      DatabaseHelper.columnInvoiceQuantity: invoice.invoiceQuantity,
    };

    final id = await dbHelper.insertIV(row);

    int trnNumber = 1;
    // rows to insert in transaction table
    for (var item in items) {

      Map<String, dynamic> row = {
        DatabaseHelper.columnTransactionNumber: trnNumber++,
        DatabaseHelper.columnInvoiceNumber: invoice.invoiceNumber,
        DatabaseHelper.columnCode: item.code,
        DatabaseHelper.columnItemDetail: item.itemDetail,
        DatabaseHelper.columnTax: item.tax,
        DatabaseHelper.columnUnitPrice: item.unitPrice,
        DatabaseHelper.columnTransactionPrice: item.transactionPrice,
        DatabaseHelper.columnInvoiceQuantity: item.qty,
      };

      final id = await dbHelper.insertTR(row);

    }

    HelperMethods.showMessage(context, Colors.green,
        "Invoice created succesfully : " + invoice.invoiceNumber.toString());
  }

  //Build invoice entity
  static Invoice buildInvoice(
      List<Item> items, double invTotalAmt, int invQuantity, double invTax) {
    final invDateFormat = new DateFormat('yyyy-MM-dd HH:mm');
    final invNumberFormat = new DateFormat('yyyyMMddHHmmss');

    var now = DateTime.now();

    Invoice invoice = new Invoice();

    //Create CSV version of the list of items, including the line item level calculated price.
//    invoice.transactionsCSV = HelperMethods.convertItemsListToCSV(items);

    invoice.invoiceDateTime = invDateFormat.format(now);
    invoice.storeId = "STORE-001";
    invoice.operatorId = "OP-999";
    invoice.invoiceNumber = int.parse(invNumberFormat.format(now));
    invoice.invoiceAmount = invTotalAmt;
    invoice.invoiceQuantity = invQuantity;
    invoice.invoiceTax = invTax;

    return invoice;
  }

  //Convert invoices into a csv string. This is used for emailing
//  static String convertInvoicesListToCSV(List<Invoice> invoices) {
//    List<List<dynamic>> rows = List<List<dynamic>>();
//
//    for (var invoice in invoices) {
//      List<dynamic> row = List();
//
//      row.add(invoice.invoiceNumber);
//      row.add(invoice.operatorId);
//      row.add(invoice.invoiceAmount);
//      row.add(invoice.invoiceDateTime);
//      row.add(invoice.storeId);
//      row.add(invoice.invoiceTax);
//      row.add(invoice.invoiceQuantity);
////      row.add(invoice.transactionsCSV);
//
//      rows.add(row);
//    }
  //Delimiter used here is "," while the one used inside transaction is "^"
//    return ListToCsvConverter(fieldDelimiter: ",").convert(rows);
//  }

  //Send email with the dump of invoices in email body
//  static void emailInvoice(String invoicesCSV, String emailId) async {
//    final Email email = Email(
//      body: invoicesCSV,
//      subject: 'Invoices list extract',
//      recipients: [emailId],
//      isHTML: false,
//    );
//
//    await FlutterEmailSender.send(email);
//  }
}
