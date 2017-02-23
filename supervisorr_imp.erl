-module (supervisorr_imp).
-behaviour(supervisor).
 
-export([start_link/1]).
-export([init/1]).
 
start_link(Type) ->
supervisor:start_link({local,?MODULE}, ?MODULE, Type).
 
init(lenient) ->
	init({one_for_one, 3, 60});
init(angry) ->
	init({rest_for_one, 2, 60});
init(jerk) ->
	init({one_for_all, 1, 60});

init({RestartStrategy, MaxRestart, MaxTime}) ->
	{ok, {{RestartStrategy, MaxRestart, MaxTime},
	[{singer,{supervisorss, start_link, [singer, bad]},permanent, 1000, worker, [supervisorss]},
	{bass,{supervisorss, start_link, [bass, good]},temporary, 1000, worker, [supervisorss]}]}}.
