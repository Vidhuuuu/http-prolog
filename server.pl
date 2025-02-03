:- use_module(library(socket)).

make_server(Port) :-
    tcp_socket(Socket),
    tcp_bind(Socket, Port),
    tcp_listen(Socket, 128),
    format('Started a server on port: ~d~n', [Port]).
