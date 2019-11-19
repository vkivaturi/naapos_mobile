import 'package:flutter/cupertino.dart';
import 'package:naapos/database_helper.dart';
import 'package:naapos/entities.dart';
import 'package:naapos/utils.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class InvoiceHelpers {

  //Insert invoice into database table
  static void insert(Invoice invoice, dbHelper, BuildContext context) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnIVinvoiceNumber: invoice.invoiceNumber,
      DatabaseHelper.columnIVtransactions: invoice.transactionsCSV,
      DatabaseHelper.columnIVoperatorId: invoice.operatorId,
      DatabaseHelper.columnIVinvoiceDateTime: invoice.invoiceDateTime,
      DatabaseHelper.columnIVstoreId: invoice.storeId,
      DatabaseHelper.columnIVinvoiceAmount: invoice.invoiceAmount,
      DatabaseHelper.columnIVinvoiceTax: invoice.invoiceTax,
      DatabaseHelper.columnIVinvoiceQuantity: invoice.invoiceQuantity,
    };
    print(row.toString());
    final id = await dbHelper.insertIV(row);

    HelperMethods.showMessage(context, Colors.green,
        "Invoice created succesfully : " + invoice.invoiceNumber.toString());
  }

  //Build invoice entity
  static Invoice buildInvoice(List<Item> items){

    final invDateFormat = new DateFormat('yyyy-MM-dd HH:mm');
    final invNumberFormat = new DateFormat('yyyyMMddHHmmss');

    var now = DateTime.now();

    Invoice invoice = new Invoice();

    //Create CSV version of the list of items, including the line item level calculated price.
    invoice.transactionsCSV = HelperMethods.convertItemsListToCSV(items);

    invoice.invoiceDateTime = invDateFormat.format(now);
    invoice.storeId = "STORE-001";
    invoice.operatorId = "OP-999";
    invoice.invoiceNumber = int.parse(invNumberFormat.format(now));

    return invoice;
  }

}