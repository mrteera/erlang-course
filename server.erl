-module(server).

-export([start/0, parent/0, child/1]).

% server:start().
% to start parent process
start() ->
  spawn(?MODULE, parent, []).

parent() ->
  process_flag(trap_exit, true),
  P1 = spawn_link(?MODULE, child, [none]),
  P2 = spawn_link(?MODULE, child, [P1]),
  P3 = spawn_link(?MODULE, child, [P2]),

  receive
    % msg patern ตอน P1 ! die
    {'EXIT', KILLID, _ } ->
      % check before, after pid
      io:format("~p~n", [KILLID]),
      parent()
  end.

child(none) ->
  %none_imp.
  receive
  after 5000 -> % 5000 milisecond
      exit("DIE")
  end;

child(Link) ->
  link(Link),
  receive
  after 5000 -> % 5000 milisecond
      exit("DIE")
  end.
