-module(date).
-compile(export_all).
-record(state , {events,clients}).
-record(event, {name =" ", description=" ",pid,timeout}).

 
valid_time(H,M,S) when  H >= 0, H < 24,
						 M >= 0, M < 60,
						 S >= 0, S < 60 -> true;
valid_time(_,_,_) -> false.

loop(S = #state{events= Name, clients= Name2}) ->
receive 
 {Pid, MsgRef, {add, Name, Description, TimeOut}} ->
 	case valid_time(N) of
        true ->
        EventPid = event:start_link(Name, TimeOut),
        NewEvents = orddict:store(Name,#event{name=Name,description=Description,pid=EventPid,timeout=TimeOut},S#state.events),
		Pid ! {MsgRef, ok},
		loop(S#state{events=NewEvents});
		false ->
		Pid ! {MsgRef, {error, bad_timeout}},
		loop(S)
	end
end.


loop2() ->
	N = valid_time(H=21,,M=32,S=32).
