%%%-------------------------------------------------------------------
%%% @author helen
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. Apr 2019 12:24
%%%-------------------------------------------------------------------
-module(pollution).
-author("helen").
-include_lib("eunit/include/eunit.hrl").

%% API
-export([createMonitor/0, addStation/3, addValue/5, removeValue/4, getOneValue/4,
  getStationMean/3, getDailyMean/3, isAlreadyExist/2, getStation/2, getMovingMean/3]).

-record(station, {coord, name}).
-record(data, {dataname, data, time}).

createMonitor() -> #{}.

isAlreadyExist(Monitor, Parametr) when is_list(Parametr) ->
  lists:any(fun(X) -> X#station.name == Parametr end, maps:keys(Monitor));
isAlreadyExist(Monitor, Parametr) when is_tuple(Parametr) ->
  lists:any(fun(X) -> X#station.coord == Parametr end, maps:keys(Monitor)).

addStation(StationName, Coord, Monitor) ->
  case isAlreadyExist(Monitor, StationName) orelse isAlreadyExist(Monitor, Coord) of
    true -> {error, stationIsAlredyExist};
    _ -> Monitor#{#station{coord = Coord, name = StationName}=>[]}
  end.

getStation(Monitor, Parametr) when is_list(Parametr) ->
  Res = fun
          (Curr, _) when Curr#station.name == Parametr -> Curr;
          (_, Acc) -> Acc
        end,
  lists:foldl(Res, {error, noStation}, maps:keys(Monitor));
getStation(Monitor, Parametr) when is_tuple(Parametr) ->
  Res = fun
          (Curr, _) when Curr#station.coord == Parametr -> Curr;
          (_, Acc) -> Acc
        end,
  lists:foldl(Res, {error, noStation}, maps:keys(Monitor)).



addValue(Id, Time, DataName, Data, Monitor) ->
  Station = getStation(Monitor, Id),
  case Station of
    {error, noStation} -> Station;
    _ -> #{Station:=StationData} = Monitor,
      Monitor#{Station=>lists:append(StationData, [#data{dataname = DataName, data = Data, time = Time}])}
  end.


removeValue(Id, Time, DataName, Monitor) ->
  Station = getStation(Monitor, Id),
  case Station of
    {error, noStation} -> Station;
    _ -> #{Station:=StationData} = Monitor,
      NewStationData = lists:dropwhile(fun(X) ->
        X#data.time == Time andalso X#data.dataname == DataName end, StationData),
      Monitor#{Station=>NewStationData}
  end.

getOneValue(Id, Time, DataName, Monitor) ->
  Station = getStation(Monitor, Id),
  case Station of
    {error, noStation} -> Station;
    _ -> #{Station:=StationData} = Monitor,
      Res = fun
              (Curr, _) when Curr#data.time == Time andalso Curr#data.dataname == DataName -> Curr;
              (_, Acc) -> Acc
            end,
      (lists:foldl(Res, {error, noData}, StationData))#data.data
  end.

getStationMean(Id, Dataname, Monitor) ->
  Station = getStation(Monitor, Id),
  case Station of
    {error, noStation} -> Station;
    _ -> #{Station:=StationData} = Monitor,
      MyData = [X#data.data || X <- StationData, X#data.dataname == Dataname],
      case length(MyData) of
        0 -> {error, noData};
        _ -> lists:sum(MyData) / length(MyData)
      end
  end.


getDailyMean(Time, Dataname, Monitor) ->
  Data = lists:append(maps:values(Monitor)),
  MyData = [X#data.data || X <- Data, X#data.dataname == Dataname, isOk(X#data.time, Time) == ok],
  case length(MyData) of
    0 -> {error, noData};
    _ -> lists:sum(MyData) / length(MyData)
  end.

getH({_, {H, _, _}}) -> H.
isOk(T1, T2) ->
  {D, _} = (calendar:time_difference(T1, T2)),
  case D of
    1 -> ok;
    0 -> ok;
    _ -> no
  end.



getMovingMean(Id, Dataname, Monitor) ->
  Station = getStation(Monitor, Id),
  Now = calendar:local_time(),
  case Station of
    {error, noStation} -> Station;
    _ -> #{Station:=StationData} = Monitor,
      MyData = [X#data.data * (24 - getH(calendar:time_difference(X#data.time, Now))) || X <- StationData, X#data.dataname == Dataname, isOk(X#data.time, Now) == ok],
      Val = [24 - getH(calendar:time_difference(X#data.time, Now)) || X <- StationData, X#data.dataname == Dataname, isOk(X#data.time, Now) == ok],
      lists:sum(MyData) / lists:sum(Val)
  end.

