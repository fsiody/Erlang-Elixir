%%%-------------------------------------------------------------------
%%% @author Veronika
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Апр. 2019 23:12
%%%-------------------------------------------------------------------
-module(pollution).
-author("Veronika").

%% API
-export([createMonitor/0,addStation/3, addValue/5, getStationByIdentificator/2, removeValue/4, getOneValue/4, getStationMean/3,numberOfElements/1]).
-record(station,{name, coordinates}).
-record(measurement,{station, value, type, date}).
-record(monitor,{stations, measurements}).

createMonitor() -> #monitor{stations = [], measurements = []}.

addStation(#monitor{stations = Stations, measurements = Measurements}, Name, Coordinates) ->
  Station = #station{name=Name,coordinates = Coordinates},
  case lists:any((fun(Station) -> (Station#station.name == Name) orelse (Station#station.coordinates == Coordinates)end), Stations) of
    true -> throw("Station is already exist.");
    false -> #monitor{stations = [Station|Stations], measurements = Measurements}
  end.


getStationByIdentificator(Id, Stations) ->
  Station = [Station || Station <- Stations, Station#station.name == Id orelse Station#station.coordinates == Id],
  case Station of
    [] -> throw("Station does not exist.");
    [H|T] -> H
  end.


addValue(Identyficator, Date, Type, Value, #monitor{stations = Stations, measurements = Measurements}) ->
  case lists:any((fun(Station) -> (Station#station.name == Identyficator) orelse (Station#station.coordinates == Identyficator)end), Stations) of
    true ->
      case lists:any((fun(Measurement) -> (Measurement#measurement.date == Date) andalso (Measurement#station.name == Identyficator
        orelse Measurement#station.coordinates == Identyficator) andalso (Measurement#measurement.type == Type) end), Measurements) of
        true -> throw("Measurement is already exist.");
        false -> Measurement = #measurement{station = getStationByIdentificator(Identyficator, Stations), value = Value,
          type = Type, date = Date},
        #monitor{stations = Stations, measurements = [Measurement|Measurements]}
      end;
    false -> throw("Station does not exist.")
  end.

removeValue(Identificator, Date, Type, #monitor{stations = Stations, measurements = Measurements}) ->
  Station = getStationByIdentificator(Identificator, Stations),
  NewMeasurements = [Measurement || Measurement <- Measurements, not((Measurement#measurement.date == Date) andalso
    (Measurement#measurement.type == Type) andalso (Measurement#measurement.station == Station))],
  #monitor{stations = [Stations], measurements = [NewMeasurements]}.

getOneValue(Identificator, Type, Date, #monitor{stations = Stations, measurements = Measurements}) ->
  Station = getStationByIdentificator(Identificator, Stations),
  NewMeasurements = [Measurement || Measurement <- Measurements, (Measurement#measurement.date == Date) andalso
    (Measurement#measurement.type == Type) andalso (Measurement#measurement.station == Station)],
  case NewMeasurements of
    [] -> "Not found.";
    [H|T] -> H
  end.

numberOfElements(List) ->
  case List of
    [] -> 0;
    [H|T] -> 1 + numberOfElements(T)
  end.

getStationMean(Identificator, Type, #monitor{stations = Stations, measurements = Measurements}) ->
  Values = [Measurement#measurement.value||Measurement <- Measurements],
  case Values of
    [] -> 0;
    _ -> Sum = fun(X,Y) -> X+Y end,
      SumElements = lists:foldl(Sum, 0, Values),
      Mean = SumElements / numberOfElements(Values)
  end.


