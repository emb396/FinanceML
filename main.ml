module G = Graphics
module T = Types

open Text_check
open Portfolio

let rec loop () = loop ()

let rec wait (start_time:float) (wait_time:float) =
  if Unix.gettimeofday() <= (wait_time +. start_time) then
    wait start_time wait_time
  else ()

let main () =
  ANSITerminal.(print_string [red]
                  "\n\nWelcome to Stock Tracker.\n");
  print_newline();
  (* Text_check.initial_request(); *)

  G.open_graph "";
  G.resize_window 800 500;
  G.set_window_title "Stock Tracker";

  wait (Unix.gettimeofday()) 0.2;

  Portfolio.draw_portfolio_frame();

  let portfolio = Portfolio.create_portfolio () in
  Portfolio.update_screen portfolio

let () = main ()