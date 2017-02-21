-module (genclient).
-compile(export_all).
-record(cat, {name= cat1, color=green, description}).
-behavior(gen_server).

start_link() -> 
	genserver:start_link(?MODULE, []).

order_cat(Pid, Name, Color, Description) ->
	genserver:call(Pid, {order, Name, Color, Description}).

return_cat(Pid, Cat = #cat{}) ->
	genserver:cast(Pid, {return, Cat}).
 
close_shop(Pid) ->
	genserver:call(Pid, terminate).

init([]) -> [].

handle_call({order, Name, Color, Description}, _From, Cats) ->
	if Cats =:= [] ->
			{reply, make_cat(Name, Color, Description), Cats},
			io:format("cats recieved");
		Cats =/= [] ->
			{reply, hd(Cats), tl(Cats)}
	end;
handle_call(terminate, _From, Cats) ->
	{stop, normal, ok, Cats}.
 
handle_cast({return, Cat = #cat{}}, Cats) ->
	{noreply, [Cat|Cats]}.



make_cat(Name, Col, Desc) ->
	#cat{name=Name, color=Col, description=Desc}.
 
terminate(normal, Cats) ->
	io:format("terminate cats ~p~n", [Cats]),
	[io:format("~p was set free.~n",[C#cat.name]) || C <- Cats],
	ok.