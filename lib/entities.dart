class Item {
  String slNo;
  int code;
  String itemDetail;
  String qty;
  String tax;
  String unitPrice;

  Item(
      {this.slNo,
        this.code,
        this.itemDetail,
        this.qty,
        this.tax,
        this.unitPrice});

  void setItem(String slNo, int code, String itemDetail, String qty,
      String tax, String unitPrice) {
    this.slNo = slNo;
    this.code = code;
    this.itemDetail = itemDetail;
    this.qty = qty;
    this.tax = tax;
    this.unitPrice = unitPrice;
  }
}
