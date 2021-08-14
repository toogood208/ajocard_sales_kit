class Ajo {
  double _mpos({int sales = 0}) {
    double mpos = 21500;
    double mposSales = mpos * sales;
    return mposSales;
  }

  double _cards({int sales = 0}) {
    double cards = 268.75;
    double cardSales = cards * sales;
    return cardSales;
  }

  double _delivery({String location = "Within Lagos"}) {
    double deliveryCost;
    location = location.toLowerCase();

    if (location == "within lagos") {
      deliveryCost = 1500;
    } else if (location == "outside lagos") {
      deliveryCost = 3500;
    } else {
      deliveryCost = 0;
    }

    return deliveryCost;
  }

  calculate({int m = 0, int c = 0, String d = "within lagos"}) {
    var mpos = _mpos(sales: m);
    var cards = _cards(sales: c);
    var delivery = _delivery(location: d);
    var total = mpos + cards + delivery;

    return "NGN $total";
  }
}
