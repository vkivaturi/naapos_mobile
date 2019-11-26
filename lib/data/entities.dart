
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

  void setItem(int code, String itemDetail, String qty, String tax,
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
//  String transactionsCSV;
  String invoiceDateTime;
  String operatorId;
  String storeId;
  int invoiceNumber;
  double invoiceAmount;
  int invoiceQuantity;
  double invoiceTax;

  Invoice(
      {
//        this.transactionsCSV,
      this.invoiceDateTime,
      this.operatorId,
      this.storeId,
      this.invoiceNumber,
      this.invoiceAmount,
      this.invoiceQuantity,
      this.invoiceTax});

  void setItem(
      String transactionsCSV,
      String invoiceDateTime,
      String operatorId,
      String storeId,
      int invoiceNumber,
      double invoiceAMount,
      int invoiceQuantity,
      double invoiceTax) {
 //   this.transactionsCSV = transactionsCSV;
    this.invoiceDateTime = invoiceDateTime;
    this.operatorId = operatorId;
    this.storeId = storeId;
    this.invoiceNumber = invoiceNumber;
    this.invoiceAmount = invoiceAmount;
    this.invoiceQuantity = invoiceQuantity;
    this.invoiceTax = invoiceTax;
  }

  @override
  String toString() {
    String delimiter = " ### ";
    return invoiceNumber.toString() +
        delimiter +
        invoiceAmount.toString() +
        delimiter +
        invoiceQuantity.toString() +
        delimiter +
        invoiceTax.toString() +
        delimiter +
//        transactionsCSV +
        delimiter +
        invoiceDateTime +
        delimiter +
        operatorId +
        delimiter +
        storeId;
  }
}

//Below entity classes are used in charts
class TopItemsSold {
  final String item;
  final int sales;

  TopItemsSold(this.item, this.sales);
}
class TopOrdersSold {
  final int invoiceNumber;
  final double invoiceAmount;

  TopOrdersSold(this.invoiceNumber, this.invoiceAmount);
}
class OrderValueTimeline {
  final String weekDay;
  final double invoiceAmount;

  OrderValueTimeline(this.weekDay, this.invoiceAmount);
}
class OrderCountTimeline {
  final String weekDay;
  final int orderCount;

  OrderCountTimeline(this.weekDay, this.orderCount);
}