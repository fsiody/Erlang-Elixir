%%%-------------------------------------------------------------------
%%% @author helen
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. Apr 2019 12:09
%%%-------------------------------------------------------------------
-module(pollution_tests).
-author("helen").

-include_lib("eunit/include/eunit.hrl").


addStation_test() ->
  Monitor = pollution:createMonitor(),
  Monitor1 = pollution:addStation("Station1", {1, 2},Monitor),
  ?assertEqual(pollution:addStation("Station1", {2, 3},Monitor1), {error,stationIsAlredyExist}),
  ?assertEqual(pollution:addStation("Station2", {1, 2},Monitor1), {error,stationIsAlredyExist}).

addValue_test() ->
  Date1 = calendar:local_time(),
  Monitor = pollution:createMonitor(),

  ?assertEqual(pollution:addValue("Station1", Date1, "PM10", 12.2,Monitor), {error,noStation}).

getOneValue_test() ->
  {Date, {Hour, Minute, Second}} = calendar:local_time(),
  Date1 = {Date, {Hour, Minute, Second}},
  Monitor = pollution:createMonitor(),
  Monitor1 = pollution:addStation("Station1", {1, 2},Monitor),
  Monitor2 = pollution:addValue("Station1", Date1, "PM10", 1,Monitor1),
  Monitor4 = pollution:addValue("Station1", {Date, {Hour+10, Minute, Second }}, "PM10", 99,Monitor2),

  ?assertEqual(pollution:getOneValue({1, 2}, Date1, "PM10",Monitor4), 1),
  ?assertEqual(pollution:getStationMean("Station1", "PM10",Monitor4), 50.0),

  Monitor5 = pollution:removeValue({1, 2}, Date1, "PM10",Monitor4),
  Monitor6 = pollution:removeValue({1, 2}, {Date, {Hour+10, Minute, Second }}, "PM10",Monitor5),
  ?assertEqual(pollution:getStationMean("Station1", "PM10",Monitor6), {error,noData}).

