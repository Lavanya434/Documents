-module (cast).
-compile(export_all).

start_link(Module, State) ->
	spawn_link(fun() -> init(Module, State) end).

call(Pid, Msg) ->
	Ref = erlang:monitor(process, Pid),
	Pid ! {syn, Ref, Msg}.

cast(Pid, Msg) ->
	Pid ! {asyn, Msg},
	ok.
init(Module, State) -> 
	loop(Module, State).

loop(Module, State) ->
	receive 
		{syn, Ref, Msg} -> 
			Module:handle_call(Msg, Ref, State);
		{asyn, Msg} ->
			Module:handle_cast(Msg, State)
	end.
