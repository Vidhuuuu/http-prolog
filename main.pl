:- use_module(server/server, [make_server/1]).

main(Port) :-
    make_server(Port).
