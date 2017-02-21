-module (genserver).
-compile(export_all).



start(Module, InitialState, []) ->
	gen_server:start(Module,InitialState, []),
	spawn(fun() -> init(Module, InitialState,[]) end).
 
start_link(Module,InitialState, []) ->
	gen_server:start_link(Module, InitialState, []),
	spawn_link(fun() -> init(Module, InitialState,[]) end).

call(ServerRef,Request,50000) ->
	gen_server:call(ServerRef,Request,50000),
	Ref = erlang:monitor(process,ServerRef),
	ServerRef ! {sync, self(), Ref, Request}.

cast(ServerRef,Request) ->
	gen_server:cast(ServerRef,Request),
	ServerRef ! {async,Request},
	ok.

reply({ServerRef, Ref}, Reply) ->
	gen_server:reply({ServerRef, Ref}, Reply),
	ServerRef ! {Ref, Reply}.
 
init(Module, InitialState,Timeout) ->
	gen_server:enter_loop(Module, Module:init(InitialState),Timeout).
 
enter_loop(Module,State, 50000) ->
	io:format("loop received ~p~n", [State]),

	receive
		{async,Request} ->
			enter_loop(Module, Module:handle_cast(Request, State),50000);
		{sync,ServerRef, Ref,Request} ->
			enter_loop(Module, Module:handle_call(Request, {ServerRef, Ref}, State), 50000)
	end.