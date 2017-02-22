-module (example).
-behaviour (gen_server).
-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
-export([start/0,enter/0,checkout/3,lookup/2,return/1]).


start() ->
	 gen_server:start_link(?MODULE,[],[]).
	

enter() ->
	gen_server:start_link(?MODULE,[],[]). %%we can create more then one gen_servers by changing the registartion name of the pid

checkout(N,Customer, Movie) -> 
    gen_server:call(N, {check,Customer,Movie}).

lookup(N,Customer) -> 
    gen_server:cast(N, {look,Customer}).

return(N) ->
	gen_server:stop(N).

init(State) ->
    {ok,State}.
 
handle_call({check,Customer,Movie},_From,State) ->
   
    {reply,{Customer,Movie},State}.

handle_cast({look,Customer},_State) ->
    {noreply,Customer}.

handle_info(_Info,State) ->
    {noreply, State}.

terminate(_Reason,_State) ->
    ok.

code_change(_OldVsn,State, _Extra) ->
    {ok, State}.

