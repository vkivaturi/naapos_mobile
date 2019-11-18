//Item entity is used in multiple places - while creating an invoice, managing product catalog and dashboards
class Item {
  String slNo;
  int code;
  String itemDetail;
  String qty;
  String tax;
  String unitPrice;
  String transactionPrice;

  Item(
      {this.slNo,
      this.code,
      this.itemDetail,
      this.qty,
      this.tax,
      this.unitPrice,
      this.transactionPrice});

  void setItem(String slNo, int code, String itemDetail, String qty, String tax,
      String unitPrice, String transactionPrice) {
    this.slNo = slNo;
    this.code = code;
    this.itemDetail = itemDetail;
    this.qty = qty;
    this.tax = tax;
    this.unitPrice = unitPrice;
    this.transactionPrice = transactionPrice;
  }
}

class Invoice {
  //List of transactions to be included in the invoice. Each transaction comprises of the item details and total amount for the item.
  List<Map<String, Object>> transactions;
  DateTime invoiceDateTime;
  String operatorId;
  String storeId;
  int invoiceNumber;

  Invoice(
      {this.transactions,
      this.invoiceDateTime,
      this.operatorId,
      this.storeId,
      this.invoiceNumber});

  void setItem(List<Map<String, Object>> transactions, DateTime invoiceDateTime,
      String operatorId, String storeId, int invoiceNumber) {
    this.transactions = transactions;
    this.invoiceDateTime = invoiceDateTime;
    this.operatorId = operatorId;
    this.storeId = storeId;
    this.invoiceNumber = invoiceNumber;
  }
}
