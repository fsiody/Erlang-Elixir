%%%-------------------------------------------------------------------
%%% @author helen
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. Apr 2019 13:48
%%%-------------------------------------------------------------------
-module(incrementator).
-behavior(gen_server).
-author("helen").

%% API
-export([start_link/0, increment/1, get/1, close/1]).
-export([init/1, handle_call/3, handle_cast/2, terminate/2]).

start_link() ->
