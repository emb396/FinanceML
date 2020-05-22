open Lwt
open Cohttp
open Cohttp_lwt_unix
open Yojson
open Yojson.Basic.Util
module T = Types


let body (ticker:string) : string Lwt.t =
  Client.get (Uri.of_string ("https://sandbox.iexapis.com/stable/stock/"^ticker^"/book?token=Tsk_d97fe6431846401383f5b8250fac8f80")) >>= fun (resp, body) ->
  body |> Cohttp_lwt.Body.to_string >|= fun body ->
  body

let processed_response (ticker:string) = 
  let response_raw = body ticker in 
  let body1 = Lwt_main.run response_raw in
  let json = Yojson.Basic.from_string body1 in 
  let assoc = Yojson.Basic.Util.to_assoc json in
  let head = List.hd(assoc) in 
  let extracted_json = snd(head) in 
  let close_price = Yojson.Basic.Util.member "close" extracted_json in 
  let symbol = Yojson.Basic.Util.member "symbol" extracted_json in 
  let company_name = Yojson.Basic.Util.member "companyName" extracted_json in 
  let marketCap = Yojson.Basic.Util.member "marketCap" extracted_json in 
  let peRatio = Yojson.Basic.Util.member "peRatio" extracted_json in 
  let ytdChange = Yojson.Basic.Util.member "ytdChange" extracted_json in
  (close_price, symbol, company_name, marketCap, peRatio, ytdChange)


let pastPricesBody ticker range =
  Client.get (Uri.of_string ("https://sandbox.iexapis.com/stable/stock/"^ticker^"/chart/"^range^"?token=Tsk_d97fe6431846401383f5b8250fac8f80")) >>= fun (resp, body) ->
  body |> Cohttp_lwt.Body.to_string >|= fun body ->
  body

let rec extractPricesFromList list = 
  match list with 
  | h::t -> 
    let price = Yojson.Basic.Util.member "close" h in 
    let date = Yojson.Basic.Util.member "date" h in 
    (date,price)::(extractPricesFromList t) 
  | _ -> []

let processPastPrices ticker range = 
  let response_raw = pastPricesBody ticker range in 
  let body1 = Lwt_main.run response_raw in
  let json = Yojson.Basic.from_string body1 in 
  let json_list = Yojson.Basic.Util.to_list json in 
  let price_list = extractPricesFromList json_list in 
  price_list

let extract_price tuple = 
  match tuple with
  | (x,_,_,_,_,_) -> x

let extract_ticker tuple = 
  match tuple with
  | (_,x,_,_,_,_) -> x

let extract_name tuple = 
  match tuple with
  | (_,_,x,_,_,_) -> x

let extract_marketCap tuple = 
  match tuple with
  | (_,_,_,x,_,_) -> x

let extract_peRatio tuple = 
  match tuple with
  | (_,_,_,_,x,_) -> x  

let extract_ytdChange tuple = 
  match tuple with
  | (_,_,_,_,_,x) -> x  

let rec extract_historicalPrices priceList = 
  match priceList with 
  | h::t -> 
    let priceDate = Yojson.Basic.Util.to_string(fst h) in
    let priceFloat = Yojson.Basic.Util.to_number(snd h) in 
    (priceDate, priceFloat)::(extract_historicalPrices t)
  | _ -> []

let rec print_numbers oc list = 
  match list with 
  | [] -> ()
  | h::t -> Printf.fprintf oc "%f\n" (h); print_numbers oc t

let get_lastprice list = 
  let list = List.rev list in 
  let head = List.hd(list) in 
  let price = snd(head) in 
  price


let validate user_resp : T.validation = 
  try 
    let result = processed_response user_resp in 
    let fiveDay = processPastPrices user_resp "5d" in 
    let oneMonth = processPastPrices user_resp "1m" in 
    let oneYear = processPastPrices user_resp "1y" in 
    let twoYear = processPastPrices user_resp "2y" in
    let ticker = Yojson.Basic.Util.to_string(extract_ticker result) in 
    let name = Yojson.Basic.Util.to_string(extract_name result) in 
    let marketCap = Yojson.Basic.Util.to_number(extract_marketCap result) in 
    let peRatio = Yojson.Basic.Util.to_number(extract_peRatio result) in 
    let ytdChange = Yojson.Basic.Util.to_number(extract_ytdChange result) *. (100.00) in  
    let fiveDayPrices = (extract_historicalPrices fiveDay) in 
    let oneMonthPrices = (extract_historicalPrices oneMonth) in
    let oneYearPrices = (extract_historicalPrices oneYear) in
    let twoYearPrices = (extract_historicalPrices twoYear) in
    let lastPrice = get_lastprice fiveDayPrices in 
    Success {
      ticker = ticker;
      name = name;
      price = lastPrice;
      marketCap = marketCap;
      peRatio = peRatio;
      ytdChangePercent = ytdChange;
      fiveDayPrices = fiveDayPrices;
      oneMonthPrices = oneMonthPrices;
      oneYearPrices = oneYearPrices;
      twoYearPrices = twoYearPrices;
    }
  with e -> Failure