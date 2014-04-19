- module(test).

% public ให้คนอื่นรู้จัก
% จำนวน paramter
- export([ hello/0,
           hello/1,
           factorial/1,
           sum/1,
           sum_tail_recur/2,
           avg/1,
           count/1,
           command/1,
           double_list/1,
           map/2,
           foldr/3,
           foldl/3,
           process_loop/0,
           list_process/1 ]).

% มี constructor ด้วย
% list ของ parameter
% List1 = spawn(test, list_process, [[]]).
% List1 ! {put, 5}.
% List1 ! print
list_process(List) ->
  receive
    {push, Val} ->
      NewList = [Val|List],
      list_process(NewList);
    print ->
      io:format("~p~n", [List]),
      % ปริ้นเสร็จก็กลับไปรอเหมือนเดิม
      list_process(List);
    % List1 ! {push, 5}.
    % ส่ง pid คนเรียกไป
    % List1 ! {self(), pop}.
    % ใน shell ให้ flush().มันจะพ่นของที่อยู่ใน mailbox ออกมา
    {Caller, pop} ->
      [Val | NewList] = List,
      Caller ! Val,
      list_process(NewList)
  end.

% P1 = spawn(test, process_loop, []).
% โปรเซสจะไม่ตายเพราะมันมี receive
% P1 ! hello.
% f(P1).
% register(p3, spawn(test, process_loop, [])).
% p3 ! hello.
% erlang:unregister(p3).
process_loop() ->
  receive
    % รอรับ pattern อะไรมาก็รับ
    Message ->
      io:format("~s~n", [Message]),
      process_loop()
  end.

double_list([]) -> [];
double_list([H|L]) -> [H*2 | double_list(L)].

% F = fun(X) -> X*2 end.
% test:map(fun(X) -> X*2 end, [1,2,3]).
% lists:map(fun(X) -> X*2 end, [1,2,3]).
% lists:map(fun test:avg/1, [[1,2]]).
% anon fn
% higher order fn / closure
% Big data ex.
% given a list [a,b,c,d,e].
% lists:map(fun(W) -> {W,1} end, [a,b,c,d,e]).
map(_, []) -> [];
map(F, [H|T]) -> [ F(H) | map(F,T)].

% test:foldl(fun(A, B) -> A+B end, [1,2,3]).
% result should be 6

% recursive stop at 2 params, result F(X,Y)
%foldr(F, [X,Y]) -> F(X,Y);
% test:foldr(fun(A, B) -> A-B end, [1,2,3,4]).
% ่ใส่ค่าเริ่มต้น 0
% lists:foldr(fun(A,B) -> A-B end, 0, [1,2,3,4]).
%foldr(F, [H|T]) -> F(H, foldr(F,T)).
foldr(F, Acc, [Y]) -> F(Y, Acc);
foldr(F, Acc, [H|T]) -> foldr(F, F(Acc, H), T).

% ?
foldl(_,_,_) -> none_imp.
%foldl(F, [X,Y]) -> F(X,Y);
%foldl(F, [H1,H2|T]) -> F(F(H1,H2), foldl(F,T)).
% ส่ง message
command(Message) ->
  % case ตามด้วยชื่อค่าที่เราเอามาเทียบ
  case Message of
    % ใส่ guard when ตรงนี้ได้
    {avg, L} -> avg(L);
    {sum, L} -> sum(L)
  end.

% when คือ guard ของ fn
factorial(0) -> 1;
factorial(1) -> 1;
factorial(N) when (N > 0) and is_integer(N) ->
  N * factorial(N - 1).

%sum([]) -> 0;
%sum([H|T]) -> H + sum(T).

% optimize recursive using tail recursive
sum_tail_recur([], Acc) -> Acc;
sum_tail_recur([H|T], Acc) ->
  sum_tail_recur(T, (Acc + H)).

sum(L) -> sum_tail_recur(L, 0).

% _ to not got warning for head
count([]) -> 0;
count([_|T]) -> count(T)+1.

avg(L) ->
  if
    % มีสอง pattern
    % =/= not equal
    L =/= [] ->
      sum(L) / count(L);
    % เคสอื่นๆ/else
    true ->
      error
  end.

% func_name(Parameter_Parameter)
hello() ->
  % print fn
  % ~n คือ \n
  io:format("Hello World, Erlang.~n").

% pattern จนกว่าจะถึงตัวสุดท้ายจึงใส่จุด
hello(joe) ->
  io:format("Hello World, Joe.~n");

hello(mike) ->
  io:format("Hello World, Mike.~n").
