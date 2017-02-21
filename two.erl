-module (two).
-compile(export_all).


-record (info, {events, clients}).

loop(S = #state{events=orddict:new(), clients=orddict:new()}) ->


	receive ->
		{Pid, Ref, {subscribe, Client}} ->
		
			Ref = erlang:monitor(process, Client),

			NewClients = orddict:store(Ref, Client, S#state.Clients),
		
		pid ! {Ref, ok}.