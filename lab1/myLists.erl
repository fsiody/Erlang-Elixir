%%%-------------------------------------------------------------------
%%% @author helen
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. Mar 2019 12:24
%%%-------------------------------------------------------------------
-module(myLists).
-author("helen").

%% API
-export([contains/2]).
-export([duplicateElements/1]).
-export([sumFloats/1]).



contains([], _) -> false;
contains([H|_],H) -> true;
contains([_|T],X) -> contains(T,X).


duplicateElements(A) -> A++A.

sumFloats([])->0;
sumFloats([H|T])-> sumFloats(T)+H.