module G = Graphics
module T = Types

let tab_height : int = 30
let bar_width : int = 200

let create_portfolio () : T.portfolio = {
  stocks = [];
  selected = 0;
  time_period = 1;
}

let draw_searchbar () = 
  G.set_color (G.rgb 50 50 50);
  G.fill_rect 0 (G.size_y()-50) bar_width 50;
  G.set_color (G.rgb 150 150 150);
  G.moveto 15 (G.size_y()-32);
  G.set_text_size 100;
  G.draw_string ("CLICK HERE TO SEARCH")

let draw_background () =
  G.set_color (G.rgb 30 30 30);
  G.fill_rect 0 0 (G.size_x()) (G.size_y());
  G.set_color (G.rgb 40 40 40);
  G.fill_rect 0 0 bar_width (G.size_y());

  G.set_color (G.rgb 255 0 0);
  G.fill_rect (G.size_x()-50) (G.size_y()-50) 50 50;
  G.set_color (G.rgb 255 255 255);
  G.moveto (G.size_x()-38) (G.size_y()-32);
  G.set_text_size 100;
  G.draw_string ("EXIT");

  G.set_color (G.rgb 255 255 255);
  G.fill_rect (G.size_x()-50) (0) 50 50;
  G.set_color (G.rgb 0 0 0);
  G.moveto (G.size_x()-38) (18);
  G.set_text_size 100;
  G.draw_string ("HELP");
  G.set_color (G.rgb 150 150 150);

  G.set_color (G.rgb 0 0 255);
  G.fill_rect (G.size_x()-50) 50 50 50;
  G.set_color (G.rgb 150 150 150);
  G.moveto (G.size_x()-45) (68);
  G.set_text_size 100;
  G.draw_string ("REFRESH");

  G.set_color (G.rgb 60 60 60);
  G.fill_rect (G.size_x()-30) 200 30 30;
  G.set_color (G.rgb 255 255 255);
  G.moveto (G.size_x()-20) (210);
  G.draw_string ("2y");

  G.set_color (G.rgb 60 60 60);
  G.fill_rect (G.size_x()-30) 240 30 30;
  G.set_color (G.rgb 255 255 255);
  G.moveto (G.size_x()-20) (250);
  G.draw_string ("1y");

  G.set_color (G.rgb 60 60 60);
  G.fill_rect (G.size_x()-30) 280 30 30;
  G.set_color (G.rgb 255 255 255);
  G.moveto (G.size_x()-20) (290);
  G.draw_string ("1m");

  G.set_color (G.rgb 60 60 60);
  G.fill_rect (G.size_x()-30) 320 30 30;
  G.set_color (G.rgb 255 255 255);
  G.moveto (G.size_x()-20) (330);
  G.draw_string ("5d");

  G.set_color (G.rgb 150 150 150)

let draw_portfolio_frame () = 
  draw_background ();

  G.moveto (bar_width+170) (250);
  G.set_color (G.rgb 150 150 150);
  G.draw_string ("ENTER A STOCK INTO THE SEARCH BAR TO VIEW");

  draw_searchbar() 

let draw_sidetab (stock:T.stock) (counter:int) : unit= 
  let counter1 = counter+1 in
  let yAnchor = (G.size_y()-50-(tab_height*counter1)) in
  G.set_color (G.rgb 150 150 150);
  G.set_line_width 3;
  G.draw_poly [|(0, yAnchor); (bar_width, yAnchor); (bar_width, yAnchor+tab_height); (0, yAnchor+tab_height)|];
  G.set_color (G.rgb 70 70 70);
  G.fill_rect 0 yAnchor bar_width tab_height;
  G.set_color (G.rgb 150 150 150);
  G.moveto 15 (yAnchor+10);
  G.set_text_size 100;
  G.draw_string (stock.ticker);
  G.moveto 75 (yAnchor+10);
  G.draw_string ("$" ^ Float.to_string (stock.price))

let rec draw_sidebar (portfolio:T.portfolio) (counter:int) : unit =
  let stocklist : T.stock list = portfolio.stocks in
  match stocklist with
  | h :: t ->
    draw_sidetab h counter;
    draw_sidebar {
      stocks = t;
      selected = portfolio.selected;
      time_period = portfolio.time_period;
    } (counter+1)
  | x -> ()

let rec get_nth (stocklist:T.stock list) (selected:int) : T.stock =
  match stocklist with
  | h :: t when selected > 1 -> get_nth t (selected-1)
  | h :: t when selected = 1 -> h
  | _ -> get_nth stocklist 1

let rec max_number_list (list: float list) : float=
  match list with 
  | [x] -> x
  | x::xs -> max x (max_number_list xs)
  | _ -> 0.0

let rec draw_graph_points (plist:float list) (maxval:float) (oX:int) (oY:int) (inc:float) (counter:int) : unit =
  match plist with
  | [x] -> ()
  | h::t -> 
    G.moveto (Int.of_float(Float.of_int(oX)+.Float.of_int(counter)*.inc)) (oY+(Int.of_float(250.0*.h/.maxval)));
    G.lineto (Int.of_float(Float.of_int(oX)+.Float.of_int((counter+1))*.inc)) (oY+(Int.of_float(250.0*.List.nth t 0/.maxval)));
    draw_graph_points t maxval oX oY inc (counter+1);
  | _ -> ()

let rec extract_pricelist (infoList:(string * float) list) (newList:float list) : float list =
  match infoList with
  | h::t -> extract_pricelist t ((snd h)::newList)
  | _ -> newList

let rec extract_datelist (infoList:(string * float) list) (newList:string list) : string list =
  match infoList with
  | h::t -> extract_datelist t ((fst h)::newList)
  | _ -> newList

let draw_graph (stock:T.stock) (timepd:int) : unit =
  let infolist = 
    if timepd = 0 then stock.fiveDayPrices
    else if timepd = 1 then stock.oneMonthPrices
    else if timepd = 2 then stock.oneYearPrices
    else stock.twoYearPrices in
  let price_list : float list = List.rev (extract_pricelist infolist []) in
  let date_list : string list = List.rev (extract_datelist infolist []) in
  let maxval : float = max_number_list price_list in
  let originX : int = bar_width+60 in
  let originY : int = 40 in
  let increment : float = (400.0 /. (Float.of_int((List.length price_list) - 1))) in

  G.set_line_width 1;
  G.moveto originX originY;
  G.lineto originX (originY+270);
  G.moveto originX originY;
  G.lineto (originX+420) originY;

  G.moveto (originX-20) (originY-20);
  G.draw_string (List.nth date_list 0);
  G.moveto (originX+370) (originY-20);
  G.draw_string (List.nth date_list (List.length(date_list)-1));
  G.moveto (originX-50) (originY+245);
  G.draw_string ("$" ^ Float.to_string maxval);
  G.moveto (originX-30) (originY-5);
  G.draw_string ("$0.0");

  G.moveto (originX-3) (originY+250);
  G.lineto (originX+3) (originY+250);
  G.moveto (originX-3) (originY);
  G.lineto (originX+3) (originY);
  G.moveto (originX+400) (originY-3);
  G.lineto (originX+400) (originY+3);
  G.moveto (originX) (originY-3);
  G.lineto (originX) (originY+3);

  draw_graph_points price_list maxval originX originY increment 0;
  ()

let draw_viewpage (portfolio:T.portfolio) (selected:int) : T.portfolio = 
  match selected with
  | 0 ->
    portfolio
  | x ->
    draw_background();
    let stock : T.stock = get_nth portfolio.stocks x in
    G.set_text_size 100;
    G.moveto (bar_width+40) (G.size_y()-50);
    G.draw_string (stock.name ^ " (" ^ stock.ticker ^ ")");
    G.moveto (bar_width+40) (G.size_y()-55);
    G.draw_string ("____________________________________________________________");
    G.moveto (bar_width+40) (G.size_y()-80);
    G.draw_string ("PRICE: $" ^ Float.to_string stock.price);
    G.moveto (bar_width+40) (G.size_y()-100);
    G.draw_string ("MARKET CAP: $" ^ Float.to_string stock.marketCap);
    G.moveto (bar_width+40) (G.size_y()-120);
    G.draw_string ("PRICE-TO-EARNING RATIO: " ^ Float.to_string stock.peRatio);
    G.moveto (bar_width+40) (G.size_y()-140);
    G.draw_string ("YTD Change: " ^ Float.to_string stock.ytdChangePercent ^ "%");
    draw_graph stock portfolio.time_period;
    {
      stocks = portfolio.stocks;
      selected = selected;
      time_period = portfolio.time_period;
    }

let draw_help_screen (portfolio:T.portfolio) : T.portfolio =
  draw_background();
  G.set_text_size 100;
  G.set_text_size 100;
  G.moveto (bar_width+40) (G.size_y()-50);
  G.draw_string ("HELP SCREEN");
  G.moveto (bar_width+40) (G.size_y()-55);
  G.draw_string ("____________________________________________________________");
  G.moveto (bar_width+40) (G.size_y()-80);
  G.draw_string ("CLICK ON THE SEARCH BAR TO TYPE IN A TICKER");
  G.moveto (bar_width+40) (G.size_y()-100);
  G.draw_string ("TO CANCEL THE SEARCH PRESS THE ESCAPE KEY OR CLICK AWAY");
  G.moveto (bar_width+40) (G.size_y()-120);
  G.draw_string ("TO SUBMIT THE SEARCH PRESS THE ENTER KEY");
  G.moveto (bar_width+40) (G.size_y()-140);
  G.draw_string ("IF THE TICKER IS VALID, THE STOCK WILL BE ADDED TO YOUR PORTFOLIO");
  G.moveto (bar_width+40) (G.size_y()-160);
  G.draw_string ("VIEW DIFFERENT STOCKS IN YOUR PORTFOLIO BY CLICKING ON THEM IN THE SIDEBAR");
  portfolio

let draw_portfolio (portfolio:T.portfolio) : unit =
  (* G.clear_graph (); *)
  draw_searchbar();
  draw_sidebar portfolio 0

let rec stock_inlist (stocklist:T.stock list) (stock:T.stock) : bool =
  match stocklist with
  | h :: t when h.ticker = stock.ticker -> true
  | h :: t -> stock_inlist t stock
  | _ -> false

let add_ticker (portfolio:T.portfolio) (str:string) : T.portfolio =
  let returned = Text_check.validate str in
  match returned with
  | Success x -> if stock_inlist portfolio.stocks x then portfolio
    else {
      stocks = x :: portfolio.stocks;
      selected = portfolio.selected;
      time_period = portfolio.time_period;
    }
  | Failure -> portfolio

let rec search_bar (portfolio:T.portfolio) (str:string) : T.portfolio =
  G.set_color (G.rgb 50 50 50);
  G.fill_rect 0 (G.size_y()-50) bar_width 50;
  G.set_color (G.rgb 150 150 150);
  G.moveto 15 (G.size_y()-32);
  G.set_text_size 100;
  G.draw_string (str);

  let check = Graphics.button_down () in 
  if (check) then let (mouse_pos : int*int) = G.mouse_pos() in
    match mouse_pos with
    | (x, y) when x>bar_width || y<G.size_y()-50 -> portfolio
    | _ -> search_bar portfolio (str)
  else
    let str_len = String.length(str) < 5 in
    let check = Graphics.key_pressed () in 
    if (check) then let (key : char) = G.read_key () in 
      match key with 
      | x when Char.code(x) >= 65 && Char.code(x) <= 90 && str_len -> search_bar portfolio (str ^ String.make 1 x)
      | x when Char.code(x) >= 97 && Char.code(x) <= 122 && str_len -> search_bar portfolio (str ^ String.make 1 (Char.chr(Char.code(x)-32)))
      | x when Char.code(x) = 27 -> portfolio
      | x when Char.code(x) = 8 && String.length(str) > 0-> search_bar portfolio (String.sub str 0 (String.length(str)-1))
      | x when Char.code(x) = 13 -> add_ticker portfolio (str)
      | _ -> search_bar portfolio (str)
    else search_bar portfolio (str)

let key_press (portfolio:T.portfolio) : T.portfolio =
  let check = Graphics.key_pressed () in 
  if (check) then let (key : char) = G.read_key () in 
    match key with 
    | 'q' -> exit 0
    | _ -> portfolio
  else portfolio

let selected_value (clickloc:int) (portfolio:T.portfolio): int =
  let y_below_search : float = Float.of_int((G.size_y()-50)-clickloc) in
  let value : int=Int.of_float(Float.ceil(y_below_search /. (Float.of_int(tab_height)))) in
  if value > List.length(portfolio.stocks) then 0
  else value

let refresh_helper (old_stock:T.stock) : T.stock =
  let str = old_stock.ticker in
  let returned = Text_check.validate str in
  match returned with
  | Success x -> x
  | Failure -> old_stock

let rec refresh_stocks (stocklist:T.stock list) (newStocklist:T.stock list) : T.stock list =
  match stocklist with 
  | h :: t -> refresh_stocks t ((refresh_helper h):: newStocklist)
  | _ -> newStocklist

let refresh (portfolio:T.portfolio) : T.portfolio =
  draw_viewpage {
    stocks = List.rev(refresh_stocks portfolio.stocks []);
    selected = portfolio.selected;
    time_period = portfolio.time_period
  } portfolio.selected

let adjust_time_period (portfolio:T.portfolio) (timepd:int): T.portfolio =
  draw_viewpage {
    stocks = portfolio.stocks;
    selected = portfolio.selected;
    time_period = timepd
  } portfolio.selected

let mouse_press (portfolio:T.portfolio) : T.portfolio =
  let check = Graphics.button_down () in 
  if (check) then let (mouse_pos : int*int) = G.mouse_pos() in
    match mouse_pos with
    | (x, y) when x<=bar_width && y>=G.size_y()-50 -> 
      search_bar portfolio "";
    | (x, y) when x>=G.size_x()-50 && y>=G.size_y()-50 -> 
      exit 0;
    | (x, y) when x>=G.size_x()-50 && y<=50 -> 
      draw_help_screen portfolio;
    | (x, y) when x<=bar_width && y<G.size_y()-50 -> 
      draw_viewpage portfolio (selected_value y portfolio);
    | (x, y) when x>=G.size_x()-50 && y>50 && y<= 100 -> 
      refresh portfolio;
    | (x, y) when x>=G.size_x()-30 && y>200 && y<= 230 -> 
      adjust_time_period portfolio 3;
    | (x, y) when x>=G.size_x()-30 && y>240 && y<= 270 -> 
      adjust_time_period portfolio 2;
    | (x, y) when x>=G.size_x()-30 && y>280 && y<= 310 -> 
      adjust_time_period portfolio 1;
    | (x, y) when x>=G.size_x()-30 && y>320 && y<= 350 -> 
      adjust_time_period portfolio 0;
    | _ -> portfolio
  else portfolio

let update (portfolio:T.portfolio) : T.portfolio = 
  key_press(mouse_press(portfolio))

let rec update_screen (portfolio:T.portfolio) : unit = 
  draw_portfolio portfolio;
  draw_sidebar portfolio 0;
  update_screen (update portfolio);