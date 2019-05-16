%%%-------------------------------------------------------------------
%%% @author Veronika
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. Март 2019 13:07
%%%-------------------------------------------------------------------
-module(vy).
-author("Veronika").

%% API
-export([factorial/1, power/2,contains/2,duplicateElements/1,sumFloats/1,sumFloatsO/2,onp/1]).

factorial(0) -> 1;
factorial(N) -> N * factorial(N-1).

power(_,0) -> 0;
power(A,1) -> A;
power(A,B) -> A * power(A, B - 1).

contains([], A) -> false;
contains([H|T], A) -> (H==A) or contains(T,A).

duplicateElements([]) -> [];
duplicateElements([H|T]) -> [H|[H|duplicateElements(T)]].

sumFloats([]) -> 0.0;
sumFloats([H|T]) -> H + sumFloats(T).

sumFloatsO([], Sum) -> Sum;
sumFloatsO([H|T], Sum) -> sumFloatsO(T, Sum + H).

onp(W) ->
  L=string:tokens(W," "),
  count([],L).

count([H|T], []) ->
  if
    T==[] -> H;
    true -> error("Wrong!")
  end;
count([H1,H2|T], ["+"|TL]) -> count([(H2+H1)|T], [TL]);
count([H1|[H2|T]], ["-"|TL]) -> count([(H2-H1)|T], [TL]);
count([H1|[H2|T]], ["*"|TL]) -> count([(H2*H1)|T], [TL]);
count([H1|[H2|T]], ["/"|TL]) -> count([(H2/H1)|T], [TL]);
count(Stack, [H|T]) -> count([list_to_integer(H)|Stack], T).