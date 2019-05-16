%%%-------------------------------------------------------------------
%%% @author helen
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. Mar 2019 12:17
%%%-------------------------------------------------------------------
-module(qsort).
-author("helen").

%% API
-export([lessThan/2]).
-export([grtEqThen/2,pollution/0]).

%lessThan([],_)->[];
lessThan(List,Arg) -> [X || X<-List, X<Arg].
grtEqThen(List,Arg) -> [X || X<-List, X>=Arg].


pollution()->
  M = dict:new(),
  M1=dict:store({{1,1},"Name1"},{"dataName1","data1",calendar:local_time()},M),
  M2=dict:store({{1,2},"Name2"},{"dataName2","data2",calendar:local_time()},M1),
  io:fwrite(dict:to_list(M2)).

