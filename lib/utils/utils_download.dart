import 'package:flutter/cupertino.dart';
import 'package:naapos/data/database_helper.dart';
import 'package:naapos/data/entities.dart';
import 'package:naapos/utils/utils.dart';
import 'package:naapos/utils/utils_invoice.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

List<Item> items = [];
List<Invoice> invoices = [];

class DownloadHelpers {
  static void emailItemData(DatabaseHelper dbHelper, String emailId) async {
    items = [];
    final allRows = await dbHelper.queryITAllRows();

    //Create a list of items
    allRows.forEach((row) => _addItemToList(row));
    //Convert list of items to CSV
    String emailBody = HelperMethods.convertItemsListToCSV(items);
    String emailSubject = "Item catalog";

    print(emailBody);

    //Eamil the item data csv
    HelperMethods.emailData(emailBody, emailId, emailSubject);
  }

  static void _addItemToList(Map<String, Object> row) {
    Item item = new Item();
    item.code = int.parse(row["code"]);
    item.itemDetail = row["itemDetail"];
    item.tax = row["tax"];
    item.unitPrice = row["unitPrice"];
    items.add(item);
  }

  static void emailInvoiceData(
      DatabaseHelper dbHelper, String emailId, int startInv, int endInv) async {
    invoices = [];

    print(startInv.toString() + ":" + endInv.toString());

    final allRows = await dbHelper.queryIVInvoiceRange(startInv, endInv);

    //Create a list of items
    allRows.forEach((row) => _addInvoiceToList(row));
    //Convert list of items to CSV
    String emailBody = HelperMethods.convertInvoicesListToCSV(invoices);
    String emailSubject =
        "Invoices between " + startInv.toString() + " and " + endInv.toString();

    print(emailBody);

    //Eamil the item data csv
    HelperMethods.emailData(emailBody, emailId, emailSubject);
  }

  static void _addInvoiceToList(Map<String, Object> row) {
    Invoice invoice = new Invoice();

    invoice.invoiceNumber = row["invoiceNumber"];
    invoice.invoiceDateTime = row["invoiceDateTime"];
    invoice.operatorId = row["operatorId"];
    invoice.invoiceAmount = double.parse(row["invoiceAmount"]);
    invoice.invoiceTax = double.parse(row["invoiceTax"]);
    invoice.invoiceQuantity = int.parse(row["invoiceQuantity"]);
    invoice.storeId = row["storeId"];

    invoices.add(invoice);
  }
}
