-module(list_app_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    % รายละเอียดที่จะให้ start ตัว worker อื่นยังไงบ้าง
    % one_for_one เป็น strategy
    % 5, 10 เป็นเรื่องของความถี่ในการ restart
    % Maximum restart frequency
    % ภายในกี่วิ
    {ok, { {one_for_one, 5, 10}, [{
             list_server,
             {list_server, start_link, []},
             permanent,
             brutal_kill,
             worker,
             [list_server]
             }]} }.
    % ใน list [] จะบอกว่า restart อะไรบ้าง

