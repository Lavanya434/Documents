-module(one).
-compile(export_all).
-record(state, {events,clients}).
-record(event, {name ="", description="",pid,timeout }).

%%-define(PI,3.14).

loop(S = #state{events=Name,clients=Value}) ->

	receive 
		{Pid,Msgref, {subscribe,Client}} ->
			Ref = erlang:monitor(process,Client),
			NewClients = orddict:store(Ref, Client, S#state.clients),
			Pid ! {Msgref, ok},
			loop(S#state{clients=NewClients});

		{Pid, MsgRef, {add, Name, Description, TimeOut}} ->
			EventPid = event:start_link(Name, TimeOut),
			NewEvents = orddict:store(Name, #event{name=Name, description=Description, pid=EventPid, timeout=TimeOut}, S#state.events),
			Pid ! {MsgRef, ok},		
			loop(S#state{events=NewEvents})

	end.


loop2() ->
	Input = #state{events=orddict:new(),clients=orddict:new()},
	loop(Input).