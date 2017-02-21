-module(new).
-compile(export_all).

%%record(state, {server, name="", to_go=0}).



%%loop(S= #state{server=Server}) ->
%%	receive 
%%		{Server, Ref , cancel} ->
%%			Server ! {Ref, ok}
%
%5	after S#state.to_go*1000 ->
%5		Server ! {done, S#state.name}
%5	end.



%%go() ->
 
  %% receive
     %%%Pid, Msg} ->
       %%io:format("~w~n",[Msg])
   %%end,
   %Pid ! stop.


%%loop() ->

  %% receive
    %% {From, Msg} ->
      %%  From ! {self(), received},
        %%loop();
     %%{From, Ref, stop} ->
     % From ! {self(), Ref, done}%
   %%end.


%go() ->
 % register(echo, spawn(new, loop, [])),
  %echo ! {self(), hello},
  %receive
    %{_Pid, Msg} ->
     % io:format("~w~n",[Msg])
  %end.


%loop() ->
 % receive
  %  {From, Msg} ->
   %  From ! {self(), Msg},
    %loop();
    %stop ->
    %true
  %end.

start() -> gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
checkout(Who, Book) -> gen_server:call(?MODULE, {checkout, Who, Book}).	
lookup(Book) -> gen_server:call(?MODULE, {lookup, Book}).
return(Book) -> gen_server:call(?MODULE, {return, Book}).

init([]) ->
	Library = dict:new(),
	{ok, Library}.

handle_call({checkout, Who, Book}, _From, Library) ->
	Response = case dict:is_key(Book, Library) of
		true ->
			NewLibrary = Library,
			{already_checked_out, Book};
		false ->
			NewLibrary = dict:append(Book, Who, Library),
			ok
	end,
	{reply, Response, NewLibrary};

handle_call({lookup, Book}, _From, Library) ->
	Response = case dict:is_key(Book, Library) of
		true ->
			{who, lists:nth(1, dict:fetch(Book, Library))};
		false ->
			{not_checked_out, Book}
	end,
	{reply, Response, Library};

handle_call({return, Book}, _From, Library) ->
	NewLibrary = dict:erase(Book, Library),
	{reply, ok, NewLibrary};

handle_call(_Message, _From, Library) ->
	{reply, error, Library}.

handle_cast(_Message, Library) -> {noreply, Library}.
handle_info(_Message, Library) -> {noreply, Library}.
terminate(_Reason, _Library) -> ok.
code_change(_OldVersion, Library, _Extra) -> {ok, Library}.


  


