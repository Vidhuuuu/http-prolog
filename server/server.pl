:- module(server, [make_server/1]).
:- use_module(library(socket)).

make_server(Port) :-
    tcp_socket(Socket),
    tcp_bind(Socket, Port),
    tcp_listen(Socket, 128),
    format('Started a server on port: ~d~n', [Port]),
    server_loop(Socket).

server_loop(Socket) :-
    tcp_accept(Socket, Client, Peer),
    format('Connected with ~w~n', [Peer]),
    setup_call_cleanup(
        tcp_open_socket(Client, InStream, OutStream),
        handle_client(InStream, OutStream),
        (close(InStream), close(OutStream))
    ),
    server_loop(Socket).

handle_client(InStream, OutStream) :-
    read_line_to_string(InStream, Request),
    format('Got: ~w~n', [Request]),
    format(OutStream, 'HTTP/1.0 200 OK~n', []),
    format(OutStream, 'Content-Type: text/plain~n', []),
    format(OutStream, 'Content-Length: 2~n~n', []),
    format(OutStream, 'OK~n', []),
    flush_output(OutStream).
