//Item entity is used in multiple places - while creating an invoice, managing product catalog and dashboards
class Item {
  int code;
  String itemDetail;
  String qty;
  String tax;
  String unitPrice;
  String transactionPrice;

  Item(
      {this.code,
      this.itemDetail,
      this.qty,
      this.tax,
      this.unitPrice,
      this.transactionPrice});

  void setItem(String slNo, int code, String itemDetail, String qty, String tax,
      String unitPrice, String transactionPrice) {
    this.code = code;
    this.itemDetail = itemDetail;
    this.qty = qty;
    this.tax = tax;
    this.unitPrice = unitPrice;
    this.transactionPrice = transactionPrice;
  }

  @override
  String toString() {
    String delimiter = " ### ";
    return code.toString() +
        delimiter +
        itemDetail +
        delimiter +
        qty +
        delimiter +
        tax +
        delimiter +
        unitPrice +
        delimiter +
        transactionPrice;
    ;
  }
}

class Invoice {
  //List of transactions to be included in the invoice. Each transaction comprises of the item details and total amount for the item.
  String transactionsCSV;
  String invoiceDateTime;
  String operatorId;
  String storeId;
  int invoiceNumber;

  Invoice(
      {this.transactionsCSV,
      this.invoiceDateTime,
      this.operatorId,
      this.storeId,
      this.invoiceNumber});

  void setItem(String transactionsCSV, String invoiceDateTime,
      String operatorId, String storeId, int invoiceNumber) {
    this.transactionsCSV = transactionsCSV;
    this.invoiceDateTime = invoiceDateTime;
    this.operatorId = operatorId;
    this.storeId = storeId;
    this.invoiceNumber = invoiceNumber;
  }

  @override
  String toString() {
    String delimiter = " ### ";
    return invoiceNumber.toString() +
        delimiter +
        transactionsCSV +
        delimiter +
        invoiceDateTime +
        delimiter +
        operatorId +
        delimiter +
        storeId;
  }
}
