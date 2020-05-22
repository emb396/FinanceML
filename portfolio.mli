(** Representation of the portfolio to be displayed and used.
    This module represents the data stored in the portfolio and how this data is
    changed. It handles creating the portfolio with various different
    stocks and changing data within the portfolio, like the stocks shown or the
    time scale used for the graphs.
*)


(** The module that represents the Graphics library. *)
module G = Graphics

(** The module that represents the Types file. *)
module T = Types

(** [tab_height] is the height of each stock tab on the side bar. *)
val tab_height: int

(** [bar_width] is the width of the side bar. *)
val bar_width: int

(** [create_portfolio u] is a portfolio with all necessary values initialized. *)
val create_portfolio: unit -> T.portfolio

(** [draw_searchbar u] draws the search bar. *)
val draw_searchbar: unit -> unit

(** [draw_background u] draws the background and the buttons. *)
val draw_background: unit -> unit

(** [draw_portfolio_frame u] draws one time the background, search bar, and
    temporary text. *)
val draw_portfolio_frame: unit -> unit

(** [draw_sidetab stock counter] draws an individual tab for an individual
    stock. *)
val draw_sidetab: T.stock -> int -> unit

(** [draw_sidebar portfolio counter] draws the tabs for each stock in the
    portfolio. *)
val draw_sidebar: T.portfolio -> int -> unit

(** [get_nth stocklist selected] is the [selected]th element in [stocklist]. *)
val get_nth: T.stock list -> int -> T.stock

(** [max_number_list list] is the max float value in [list]. *)
val max_number_list: float list -> float

(** [draw_graph_points plist maxVal oX oY inc counter] draws lines between the
    datapoints in plist, with the maximum value at [maxval] and origin at
    ([oX],[oY]), with an x increment of [inc]. *)
val draw_graph_points: float list -> float -> int -> int -> float -> int -> unit

(** [extract_pricelist infolist newlist] is the list of floats extracted from
    the list of (string * float)s. *)
val extract_pricelist: (string * float) list -> float list -> float list

(** [extract_datelist infolist newlist] is the list of strings extracted from
    the list of (string * float)s. *)
val extract_datelist: (string * float) list -> string list -> string list

(** [draw_graph stock timepd] draws the axes of the graph, as well as the data
    points, with the time scale dependant on the value of [timepd]. *)
val draw_graph: T.stock -> int -> unit

(** [draw_viewpage portfolio selected] draws the information relevant to the
    stock selected from the portfolio [portfolio]. *)
val draw_viewpage: T.portfolio -> int -> T.portfolio

(** [draw_help_screen portfolio] draws the help screen page. *)
val draw_help_screen: T.portfolio -> T.portfolio

(** [draw_portfolio portfolio] draws the search bar and the side bar. *)
val draw_portfolio: T.portfolio -> unit

(** [stock_inlist stocklist stock] is true if [stock] is in [stocklist] and
    false otherwise. *)
val stock_inlist: T.stock list -> T.stock -> bool

(** [add_ticker portfolio str] is the portfolio [portfolio] with the stock with
    ticker [str]. *)
val add_ticker: T.portfolio -> string -> T.portfolio

(** [search_bar portfolio str] is the portfolio [portfolio] with [str] in the
    search bar. *)
val search_bar: T.portfolio -> string -> T.portfolio

(** [key_press portfolio] is portfolio [portfolio] after certain key presses. *)
val key_press: T.portfolio -> T.portfolio

(** [selected_value clickloc portfolio] is the index of the selected stock tab. *)
val selected_value: int -> T.portfolio -> int

(** [refresh_helper old_stock] is the stock with updated values from [old_stock],
    but with the same ticker*)
val refresh_helper: T.stock -> T.stock

(** [refresh_stocks stocklist] is the stocklist with updated values from 
    [stocklist] but with the same ticker. *)
val refresh_stocks: T.stock list -> T.stock list -> T.stock list

(** [refresh portfolio] is the portfolio [portfolio] with all stock values
    refreshed. *)
val refresh: T.portfolio -> T.portfolio

(** [adjust_time_period portfolio timepd] is the portfolio [portfolio] with
    time_scale [timepd] for the graph displays. *)
val adjust_time_period: T.portfolio -> int -> T.portfolio

(** [mouse_press portfolio] is the portfolio [portfolio] after certain mouse
    presses. *)
val mouse_press: T.portfolio -> T.portfolio

(** [update portfolio] is the updated portfolio [portfolio] after certain mouse
    and key presses. *)
val update: T.portfolio -> T.portfolio

(** [update_screen portfolio] loops constantly and updated the screen portfolio. *)
val update_screen: T.portfolio -> unit