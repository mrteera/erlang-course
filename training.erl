-module(training).

-export([loop/0, loop2/0]).

loop() ->
  % receive ครั้งนึง พอมีใครยิง msg มาหาให้ process ตาย
  % erl> P1 = erlang:spawn_link(training, loop, []).
  % erl> P2 = erlang:spawn_link(training, loop2, []).
  % P1 ! {link, P2}.
  % P1 ! die
  % erlang:is_process_alive(P1).
  % erlang:is_process_alive(P2).
  receive
    % link ภายในโปรเซส
    {link, PID} ->
      link(PID),
      loop();
    _ ->
      exit("DIE")
      %io:format("DIE~n")
      % die
  end.

loop2() ->
  process_flag(trap_exit, true),
  receive
    {link, PID} ->
      link(PID),
      loop2();
    % รอรับ msg die เพื่อ kill ตัวเอง
    die ->
      exit("DIE");
    % pattern ดักไว้เพื่อเวลา P1 ตายแล้วมี msg ยิงมาหา P2
    % จะดูได้ว่า ยิง msg อะไรมาตอน P1 ตาย
    ExitMessage ->
      io:format("~p~n", [ExitMessage]),
      loop2()
  end.
