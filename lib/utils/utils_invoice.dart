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
      List<Item> items, double invTotalAmt, int invQuantity, double invTax, String operatorId, String storeId) {
    final invDateFormat = new DateFormat('yyyy-MM-dd HH:mm');
    final invNumberFormat = new DateFormat('yyyyMMddHHmmss');

    var now = DateTime.now();

    Invoice invoice = new Invoice();

    invoice.invoiceDateTime = invDateFormat.format(now);
    invoice.storeId = storeId != null ? storeId : "Store-0";
    invoice.operatorId = operatorId != null ? operatorId : "Operator-0";
    invoice.invoiceNumber = int.parse(invNumberFormat.format(now));
    invoice.invoiceAmount = invTotalAmt;
    invoice.invoiceQuantity = invQuantity;
    invoice.invoiceTax = invTax;

    return invoice;
  }

}
