-module(ex).
-behaviour(gen_server).
-compile(export_all). 
  
start_link() -> 
    gen_server:start_link(?MODULE, [],[]).
checkout(Customer, Movie) -> 
    example:call(?MODULE, {check,Customer,Movie}).
  
lookup(Customer) -> 
    example:cast(?MODULE, {look,Customer}).

init([]) ->
    ok.
 
handle_call({check,Customer,Movie},_From,State) ->
    {reply, _From, State}.

handle_cast({look,Customer},State) ->
    {noreply, State}.

handle_info(_Info,State) ->
    {noreply, State}.

terminate(_Reason,_State) ->
    ok.

code_change(_OldVsn,State, _Extra) ->
    {ok, State}.



