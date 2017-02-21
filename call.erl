-module (call).
-compile(export_all).
-behavior(gen_server).
-record(cats, {name,color,description}).

start_link() ->
	gen_serevr:start_link(?MODULE,[],[]).

cat_info(ServerRef,Name,Color,Description, Timeout) ->
	genserver:call(ServerRef, {syn,Name,Color,Description}, Timeout) .

get_book(ServerRef, C= #cats{}) ->
	genserver:cast(asyn,ServerRef,C).

handle_call({syn,Name,Color,Description}, From,State) ->
	if State =:= [] ->
			caster:reply(From,make_fun(Name,Color,Description));
		State =/= [] ->
			io:format("state is not empty")
	end.
handle_cast(Request, State) ->
	{noreplay, State}.

handle_info(50000,Request) ->
	io:formt("some message", [Request]),
	{noreplay, ok}.

init(InitialState) -> [].

code_change(_Prev, State, _Extra) ->
	{ok, State}.

terminate(normal,ServerRef) ->
	{ok, ServerRef}.

make_fun(Name,Color,Description) ->
	#cats{name=Name, color=Color, description=Description}.