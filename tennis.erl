-module(tennis).

-compile(export_all).
% 1 state is 1 fn
%-export([tennis/1]).

start_game(Score) ->
  io:format("Love All~"),
  % รอ event ที่เกิดขึ้น
  receive
    a_point ->
      score_15_0();
    b_point ->
      score_0_15();
  end.

score_15_0() ->
  io:format("Fifteen Love~n"),
  receive
    a_point ->
tennis({0,0}) -> "Love All";
tennis({15,0}) -> "Fifteen Love";
tennis({30, 0}) -> "Thirty Love";
tennis({40, 0}) -> "Forty Love";
tennis({win,0}) -> "Player 1 Win";

tennis({0,15}) -> "Love Fifteen";
tennis({15,15}) -> "Thirty Love";
tennis({30,30}) -> "Forty Love";
tennis({40,30}) -> "Player 1 Win";
