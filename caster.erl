-module (caster).
-compile(export_all).

start(Module, State) ->
	spawn(fun() -> init(Module, State) end).

start_link(Module, State) ->
	spawn_link(fun() -> init(Module, State) end).

call(Pid, Msg) ->
	Ref = erlang:monitor(process, Pid),
	Pid ! {syn, self(), Ref, Msg}.

cast(Pid, Msg) ->
	Pid ! {asyn, Msg},
	ok.
init(Module, State) -> 
	enter_loop(Module, Module:init(State)).

enter_loop(Module, State) ->
	io:format([State]),
	receive 
		{syn, Pid, Ref, Msg} -> 
			Module:handle_call(Msg, {Pid,Ref}, State);
		{asyn, Msg} ->
			Module:handle_cast(Msg, State)
		
	end.

reply({Pid,Ref}, Reply) ->
	Pid ! {Ref,Reply}.
