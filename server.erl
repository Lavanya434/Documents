-module(server).
-compile(export_all).
-record(cat, {name, color=green, description}).
 
start_link() -> 
	client:start_link(?MODULE, []).

order_cat(Pid, Name, Color, Description) ->
	client:call(Pid, {order, Name, Color, Description}).
 
return_cat(Pid, Cat = #cat{}) ->
	client:cast(Pid, {return, Cat}).
 
close_shop(Pid) ->
	client:call(Pid, terminate).

init([]) -> []. 
 
handle_call({order, Name, Color, Description}, From, Cats) ->
	if Cats =:= [] ->
			client:reply(From, make_cat(Name, Color, Description)),
			Cats;
		Cats =/= [] ->
			client:reply(From, hd(Cats)),
			tl(Cats)
	end;
 
handle_call(terminate, From, Cats) ->
	client:reply(From, ok),
	terminate(Cats).
 
handle_cast({return, Cat = #cat{}}, Cats) ->
	[Cat|Cats].

make_cat(Name, Col, Desc) ->
	#cat{name=Name, color=Col, description=Desc}.
 
terminate(Cats) ->
	[io:format("~p was set free.~n",[C#cat.name]) || C <- Cats],
	exit(normal).