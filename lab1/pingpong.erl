%%%-------------------------------------------------------------------
%%% @author helen
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. Apr 2019 11:52
%%%-------------------------------------------------------------------
-module(pingpong).
-author("helen").

%% API
-export([start/0,stop/0,play/1,ping/1]).

ping(N)->
  receive
    N ->
      io:format("~B~n",[N]),
      ping ! N-1;
    stop ->
      io:format("Stop~n"),
      ok
  end.

start()->
  P1=spawn(ping),
  register(ping,P1),

  P2=spawn(ping),
  register(pong,P2).

stop()->
  ping ! stop,
  pong ! stop.


play(N)->
  start(),
  ping ! N.









