-module(list_server).
-behavior(gen_server).
-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).
-define(SERVER, ?MODULE).

% คล้ายๆ struct
-record(state, {}).

% genserver:start_link().
% call มาจาก module genserver
% --------------------------vMsg
% gen_server:call(genserver, hello).
% ----------------^ชื่อที่ register

start_link() ->
  %--------------------------------------v|moduleCallback|voptions
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).
  %-----------------------------^RegisterName------^initArgs
  %initArgs วิ่งหา init เพื่อกำหนด state เริ่มต้น

init([]) ->
  {ok, []}.

% gen_server:call(genserver, get_all).
% ถ้า exception คือ process ตายแล้ว
% ให้ start_link ใหม่นะครัช
handle_call(Request, _From, State) ->
  % กลไล receive เขียนอยู่ใน call อยู่แล้ว
  case Request of
    get_all ->
      {reply, State, State};
    _Else ->
      {reply, {return, Request}, State}
  end.

% genserver:start_link().
% gen_server:cast(genserver, {push, hello}).
handle_cast(Request, State) ->
  case Request of
    {push, Val} ->
      NewState = [Val|State],
      {noreply, NewState};
      % msg อะไรก็ได้ที่ไม่ใช้ push
    _Else ->
      {noreply, State}
  end.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.
