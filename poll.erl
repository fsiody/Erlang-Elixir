getMovingMean(Id,Dataname,Monitor)->
  Station=getStation(Monitor,Id),
  Now=calendar:local_time(),
  case Station of
    {error,noStation}->Station;
    _->#{Station:=StationData}=Monitor,
      MyData=[X#data.data *(24-getH(calendar:time_difference(X#data.time,Now))) || X<- StationData, X#data.dataname==Dataname, getD(calendar:time_difference(Now,X#data.time)) == 0 ],
      Val=[24-getH(calendar:time_difference(Now,X#data.time)) || X<- StationData, X#data.dataname==Dataname, getD(calendar:time_difference(Now,X#data.time)) ==0],
      case length(MyData) of
        0->{error,noData};
        _->lists:sum(MyData)/lists:sum(Val)
      end
  end.