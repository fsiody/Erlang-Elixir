%%%-------------------------------------------------------------------
%%% @author helen
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. Mar 2019 22:16
%%%-------------------------------------------------------------------
-module('ONP').
-author("helen").

%% API
-export([onp/1]).
-export([getONPList/1]).
-export([onpRek/1]).
-export([argToF/1]).
-export([printArgs/1]).
-export([printRes/1]).



argToF(Arg)->
  ArgI = (catch list_to_integer(Arg)),
  ArgF = (catch list_to_float(Arg)),
  if
    is_float(ArgF) -> ArgF;
    is_integer(ArgI) -> ArgI/1.0;
    true->Arg
  end.

getONPList([])->[];
getONPList([H|T])-> [argToF(H)|getONPList(T)].

printArgs([]) -> io:fwrite("~n");
printArgs([H|T]) ->
  if
    is_list(H) -> io:fwrite(H++" ");
    true -> io:fwrite(float_to_list(H)++" ")
  end,
  printArgs(T).


printRes(H) ->
  io:fwrite("~n ~n ~n"),
  if
    is_list(H) -> io:fwrite(H);
    true ->
      io:fwrite(float_to_list(H)++"~n")
  end.


onpRek(Args)->
  printArgs(Args),
  N=length(Args),
  if
    N==2 ->
      [A|[B|_]]=Args,
      if
        ((is_float(A)) and (B=="sin")) -> [math:sin(A)|[]];
        ((is_float(A)) and (B=="cos")) -> [math:cos(A)|[]];
        ((is_float(A)) and (B=="tg")) -> [math:tan(A)|[]];
        ((is_float(A)) and (B=="tan")) -> [math:tan(A)|[]];
        ((is_float(A)) and (B=="sqrt")) -> [math:sqrt(A)|[]];

        is_float(B) -> "error ~n";
        true -> Args
      end;
    N>2->
      [A|[B|[Op|T]]]=Args,
      if
        ((is_float(A)) and (B=="sin")) -> onpRek([math:sin(A)|[Op|T]]);
        ((is_float(A)) and (B=="cos")) -> onpRek([math:cos(A)|[Op|T]]);
        ((is_float(A)) and (B=="tg")) -> onpRek([math:tan(A)|[Op|T]]);
        ((is_float(A)) and (B=="tan")) -> onpRek([math:tan(A)|[Op|T]]);
        ((is_float(A)) and (B=="sqrt")) -> onpRek([math:sqrt(A)|[Op|T]]);


        not(is_float(A) and is_float(B))->Args;
        is_float(Op) ->
          C=onpRek([B|[Op|T]]),
          if
            C=="error ~n" -> C;
            true -> onpRek( [ A | C ] )
          end;
        Op=="+" -> onpRek([A+B|T]);
        Op=="-" -> onpRek([A-B|T]);
        Op=="*" -> onpRek([A*B|T]);
        Op=="/" -> onpRek([A/B|T]);
        Op=="^" -> onpRek([math:pow(A,B)|T]);
        Op=="sin" -> onpRek([A|[math:sin(B)|T]]);
        Op=="cos" -> onpRek([A|[math:cos(B)|T]]);
        Op=="tg" -> onpRek([A|[math:tan(B)|T]]);
        Op=="tan" -> onpRek([A|[math:tan(B)|T]]);
        Op=="sqrt" -> onpRek([A|[math:sqrt(B)|T]])
      end;
    true->Args
  end.


onp([])->0;
onp(A)->
  X=string:tokens(A," "),
  Args=getONPList(X),
  Res=onpRek(Args),
  if
    Res=="error ~n" -> io:fwrite("~n ~n" ++ Res++"~n ~n ");
    true -> [FinalRes|_]=Res,
      printRes(FinalRes)
  end.

