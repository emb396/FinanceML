open OUnit2
open Types
open Portfolio

let book_json = Yojson.Basic.from_file "dummydata_book.json"
let fiveday_json = Yojson.Basic.from_file "dummydata_5d.json"
let onemonth_json = Yojson.Basic.from_file "dummydata_1m.json" 
let oneyear_json = Yojson.Basic.from_file "dummydata_1y.json"
let twoyear_json = Yojson.Basic.from_file "dummydata_2y.json"

let process_dummy_data_prices json = 
  let json_list = Yojson.Basic.Util.to_list json in 
  let price_list = Text_check.extractPricesFromList json_list in 
  price_list

let pricelist_5d = Text_check.extract_historicalPrices(process_dummy_data_prices fiveday_json)
let pricelist_1m = Text_check.extract_historicalPrices(process_dummy_data_prices onemonth_json)
let pricelist_1y = Text_check.extract_historicalPrices(process_dummy_data_prices oneyear_json)
let pricelist_2y = Text_check.extract_historicalPrices(process_dummy_data_prices twoyear_json)

let test_tuple1 = (1, 2, 3, 4, 5, 6)
let test_tuple2 = ("a", "b", "c", "d", "e", "f")
let test_tuple3 = (11, "33", "4", 6, 8, 100)

let make_extract_price_test name tuple expected_output = 
  name >:: (fun _ -> assert_equal (expected_output) (Text_check.extract_price tuple))

let make_extract_ticker_test name tuple expected_output = 
  name >:: (fun _ -> assert_equal (expected_output) (Text_check.extract_ticker tuple))

let make_extract_name_test name tuple expected_output = 
  name >:: (fun _ -> assert_equal (expected_output) (Text_check.extract_name tuple))

let make_extract_market_cap_test name tuple expected_output = 
  name >:: (fun _ -> assert_equal (expected_output) (Text_check.extract_marketCap tuple))

let make_extract_peRatio_test name tuple expected_output = 
  name >:: (fun _ -> assert_equal (expected_output) (Text_check.extract_peRatio tuple)) 

let make_extract_ytdChange_test name tuple expected_output = 
  name >:: (fun _ -> assert_equal (expected_output) (Text_check.extract_ytdChange tuple)) 

let make_last_price_test name (priceList: ('a * 'b) list) expected_output = 
  name >:: (fun _ -> assert_equal (expected_output) (Text_check.get_lastprice priceList)) 

let tests = [
  (make_extract_price_test "extract_price 1" test_tuple1 1);
  (make_extract_price_test "extract_price 2" test_tuple2 "a");
  (make_extract_price_test "extract_price 3" test_tuple3 11);

  (make_extract_ticker_test "extract_ticker 1" test_tuple1 2);
  (make_extract_ticker_test "extract_ticker 2" test_tuple2 "b");
  (make_extract_ticker_test "extract_ticker 3" test_tuple3 "33");

  (make_extract_name_test "extract_name 1" test_tuple1 3);
  (make_extract_name_test "extract_name 2" test_tuple2 "c");
  (make_extract_name_test "extract_name 3" test_tuple3 "4");

  (make_extract_market_cap_test "extract_market_cap 1" test_tuple1 4);
  (make_extract_market_cap_test "extract_market_cap 2" test_tuple2 "d");
  (make_extract_market_cap_test "extract_market_cap 3" test_tuple3 6);

  (make_extract_peRatio_test "extract_peRatio 1" test_tuple1 5);
  (make_extract_peRatio_test "extract_peRatio 2" test_tuple2 "e");
  (make_extract_peRatio_test "extract_peRatio 3" test_tuple3 8);

  (make_extract_ytdChange_test "extract_ytdChange 1" test_tuple1 6);
  (make_extract_ytdChange_test "extract_ytdChange 2" test_tuple2 "f");
  (make_extract_ytdChange_test "extract_ytdChange 3" test_tuple3 100);

  (make_last_price_test "last_price test 1" pricelist_5d 310.13);
  (make_last_price_test "last_price test 2" pricelist_1m 310.13);
  (make_last_price_test "last_price test 3" pricelist_1y 310.13)
]

let suite = "search test suite" >::: List.flatten[tests]

let _ = run_test_tt_main suite