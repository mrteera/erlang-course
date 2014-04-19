-module(broadcast).

-export([server/1, client/1]).

% Client1 = spawn(broadcast, client, [server]).
% Client2 = spawn(broadcast, client, [server]).
% Client3 = spawn(broadcast, client, [server]).
% Server ! {connect, Client1}.
% Server ! {connect, Client2}.
% Server ! {connect, Client3}.
% f(Server), Server = spawn(broadcast, server, [[]]).
% Server ! {message, hello}.
% Client1 ! {message, hello}.

client(Server) ->
  receive
  {connected, ServerPID} ->
    client(ServerPID);

  {notify, Message} ->
      io:format("Received Message : ~s~n", [Message]),
      client(Server);

  {broadcast, Message} ->
      Server ! {message, Message},
      client(Server)
  end.

server(Clients) ->
  receive
    {connect, Client} ->
      NewClients = [Client|Clients],
      Client ! {connected, self()},
      server(NewClients);

    {message, Message} ->
      lists:foreach(
        fun(Client) ->
            Client ! {notify, Message}
        end,
        Clients
       ),
      server(Clients)
  end.
