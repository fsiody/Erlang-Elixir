%%%-------------------------------------------------------------------
%%% @author helen
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. Apr 2019 15:10
%%%-------------------------------------------------------------------
-module(pollution_server_tests).
-author("helen").

-include_lib("eunit/include/eunit.hrl").



addStation_test() ->
  pollution_server:start(),
  pollution_server:addStation("Station1", {1, 2}),
  ?assertEqual(pollution_server:addStation("Station1", {2, 3}), stationIsAlredyExist),
  ?assertEqual(pollution_server:addStation("Station2", {1, 2}), stationIsAlredyExist).

addValue_test() ->
  Date1 = calendar:local_time(),
  ?assertEqual(pollution_server:addValue("Station100", Date1, "PM10", 12.2), noStation).

getOneValue_test() ->
  {Date, {Hour, Minute, Second}} = calendar:local_time(),
  Date1 = {Date, {Hour, Minute, Second}},
  pollution_server:addStation("Station1", {1, 2}),
  pollution_server:addValue("Station1", Date1, "PM10", 1),
  pollution_server:addValue("Station1", {Date, {Hour+10, Minute, Second }}, "PM10", 99),

  ?assertEqual(pollution_server:getOneValue({1, 2}, Date1, "PM10"), 1),
  ?assertEqual(pollution_server:getStationMean("Station1", "PM10"), 50.0),

  pollution_server:removeValue({1, 2}, Date1, "PM10"),
  pollution_server:removeValue({1, 2}, {Date, {Hour+10, Minute, Second }}, "PM10"),
  ?assertEqual(pollution_server:getStationMean("Station1", "PM10"), noData).


