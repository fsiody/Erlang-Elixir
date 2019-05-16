%%%-------------------------------------------------------------------
%%% @author helen
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. Mar 2019 12:07
%%%-------------------------------------------------------------------
-module(file1).
-author("helen").

%% API
-export([power/2]).

power(Arg,0)->1;
power(Arg,1) -> Arg;
power(Arg,Pow) -> Arg * power(Arg,Pow-1).
