-module (ex_server).
-compile(export_all).

start({local,mymodule},mymodule,[],[]) ->
 spawn(fun() -> example:init([]) end).
start_link({local,mymodule},mymodule,[],[]) ->
	spawn_link(fun() -> example:init([]) end).


call(Pid,{check, Customer, Movie}) ->
	gen_server:call(Pid,{check,Customer,Movie}),
	Ref = erlang:monitor(process,Pid),
	ex:handle_call({check, Customer, Movie}, {Ref, Pid}, []).
cast(Pid,{look,Customer}) ->
	gen_server:call(Pid,{look,Customer}),
	ex:handle_cast({look,Customer}, []),
	ok.


