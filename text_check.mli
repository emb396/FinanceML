(**
   Handles and represents data from the various API calls made to the IEX
   trading API.
*)


(** The module that represents the Types file. *)
module T = Types

(** [body ticker] makes an API call to the IEX Exchange API to grab data based
    on the stock [ticker] desired. *)
val body: string -> string Lwt.t

(** [processed_response ticker] processes the API call and returns a tuple of
    processed stats/info on the stock. *)
val processed_response: string -> (Yojson.Basic.t * Yojson.Basic.t * Yojson.Basic.t * Yojson.Basic.t * Yojson.Basic.t * Yojson.Basic.t)

(** [pastPricesBody ticker range] makes a separate API call, getting historic
    data from [range] for stock [ticker]. *)
val pastPricesBody: string -> string -> string Lwt.t

(** [extractPricesFromList list] extracts historic price data from [list]. *)
val extractPricesFromList: Yojson.Basic.t list -> (Yojson.Basic.t * Yojson.Basic.t) list

(** [processPastPrices ticker range] turns the API call into a more useable
    format from [range] and stock [ticker]. *)
val processPastPrices: string -> string -> (Yojson.Basic.t * Yojson.Basic.t) list

(** [extract_price tuple] extracts the price info from the [tuple]. *)
val extract_price: ('a * 'b * 'c * 'd * 'e * 'f) -> 'a

(** [extract_ticker tuple] extracts the ticker info from [tuple]. *)
val extract_ticker: ('a * 'b * 'c * 'd * 'e * 'f) -> 'b

(** [extract_name tuple] extracts the name from [tuple]. *)
val extract_name: ('a * 'b * 'c * 'd * 'e * 'f) -> 'c

(** [extract_marketCap tuple] extracts the marketCap info from [tuple]. *)
val extract_marketCap: ('a * 'b * 'c * 'd * 'e * 'f) -> 'd

(** [extract_peRatio tuple] extracts the peRatio from [tuple]. *)
val extract_peRatio: ('a * 'b * 'c * 'd * 'e * 'f) -> 'e

(** [extract_ytdChange tuple] extracts the ytdChange from [tuple]. *)
val extract_ytdChange: ('a * 'b * 'c * 'd * 'e * 'f) -> 'f

(** [extract_historicalPrices priceList] extracts historicalPrices from
    [priceList]. *)
val extract_historicalPrices: (Yojson.Basic.t * Yojson.Basic.t) list -> (string * float) list

(** [print_numbers oc list]  allows printing of floats in a list format to [oc]
    prints from [list]. *)
val print_numbers: out_channel -> float list -> unit

(** [get_lastprice list] gets the last price of a stock from a [list]. *)
val get_lastprice: ('a * 'b) list -> 'b

(** [validate user_resp] validates that [user_resp] is a valid call to the API
    for info. *)
val validate: string -> T.validation