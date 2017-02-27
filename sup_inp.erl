-module (sup_inp).
-compile(export_all).
-behavior(supervisor).
-export([start_link/1,init/1]).





start_link([Role,Skill]) ->
    supervisor:start_link({local,?MODULE}, ?MODULE, [Role,Skill]).

init([Role,Skill]) ->
     RestartStrategy = {simple_one_for_one,1,20},
     ChildSpec = {supervisorss, {supervisorss, start_link, [Role,Skill]},permanent,600, worker, [supervisorss]},
     Children = [ChildSpec],
     {ok, {RestartStrategy, Children}}.





