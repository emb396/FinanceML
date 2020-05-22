(** [stock]  is a type representing a stock's information and price data*)
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

(** [portfolio] represents a collection of stocks *)
type portfolio = {
  stocks: stock list;
  selected: int;
  time_period:int;
}

(**[validation] represents whether a API call for certain stock info was successful or not*)
type validation =
  | Success of stock
  | Failure