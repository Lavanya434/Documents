
%%-record(state, {server , name="" , to_go=0}).
%-record(state,{events,clients}).
%-record(event, {name="",description="", pid,timeout }).

-record(cat, {name, color=green, description}).
-record(books, {name, author, id}).