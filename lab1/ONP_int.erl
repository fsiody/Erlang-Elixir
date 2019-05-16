%%%-------------------------------------------------------------------
%%% @author helen
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. Mar 2019 20:10
%%%-------------------------------------------------------------------
-module('ONP_int').
-author("helen").

%% API
-export([onp/1]).
-export([argToInt/1]).
-export([getONPList/1]).
-export([onpRek/1]).




argToInt(Arg)->
  ArgInt = (catch list_to_integer(Arg)),
  if
    is_integer(ArgInt) -> ArgInt;
    true->Arg
  end.

getONPList([])->[];
getONPList([H|T])-> [argToInt(H)|getONPList(T)].

printArgs([]) -> io:fwrite("~n");
printArgs([H|T]) ->
  if
    is_list(H) -> io:fwrite(H++" ");
    true -> io:fwrite(integer_to_list(H)++" ")
  end,
  printArgs(T).


printRes(H) ->
  if
    is_list(H) -> io:fwrite(H);
    true -> io:fwrite(integer_to_list(H)++" int:( ~n")
  end.


onpRek(Args)->
  printArgs(Args),
  N=length(Args),
  if
    N==2 ->
      [A|[B|_]]=Args,
      if
        is_integer(B) -> "error ~n";
        true -> Args
      end;
    N>2->
      [A|[B|[Op|T]]]=Args,
      if
        not(is_integer(A) and is_integer(B))->Args;
        is_integer(Op) ->
          C=onpRek([B|[Op|T]]),
          if
            C=="error ~n" -> C;
            true -> onpRek( [ A | C ] )
          end;
        Op=="+" -> onpRek([A+B|T]);
        Op=="-" -> onpRek([A-B|T]);
        Op=="*" -> onpRek([A*B|T]);
        Op=="/" -> onpRek([A/B|T]);
        true -> io:fwrite(Op),
          io:fwrite("!!!!~n")
      end;
    true->Args
  end.


onp([])->0;
onp(A)->
  X=string:tokens(A," "),
  Args=getONPList(X),
  printRes(onpRek(Args)).

