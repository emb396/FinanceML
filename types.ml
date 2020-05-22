type stock = {
  ticker: string;
  name: string;
  price: float;
  marketCap: float;
  peRatio: float;
  ytdChangePercent: float;
  fiveDayPrices: (string * float) list;
  oneMonthPrices: (string * float) list;
  oneYearPrices: (string * float) list;
  twoYearPrices: (string *  float) list;
}

type portfolio = {
  stocks: stock list;
  selected: int;
  time_period:int;
}

type validation =
  | Success of stock
  | Failure