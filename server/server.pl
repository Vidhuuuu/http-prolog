:- module(server, [make_server/1]).
:- use_module(library(socket)).
:- use_module(server/parse_req, [parse_request/2]).

make_server(Port) :-
    tcp_socket(Socket),
    tcp_bind(Socket, Port),
    tcp_listen(Socket, 128),
    format('Started a server on port: ~d~n', [Port]),
    server_loop(Socket).

% ip(127,0,0,1)             Peer
% <socket>(0x561db40068e0)  Client

server_loop(Socket) :-
    tcp_accept(Socket, Client, _Peer),
    format('Connected with ~w~n', [Client]),
    setup_call_cleanup(
        tcp_open_socket(Client, StreamPair),
        handle_client(StreamPair),
        close(StreamPair)
    ),
    server_loop(Socket).

handle_client(StreamPair) :-
    stream_pair(StreamPair, InStream, OutStream),
    read_line_to_string(InStream, Request),
    format('Got: ~w~n', [Request]),
    parse_request(Request, Response),
    format(OutStream, '~s', [Response]),
    flush_output(OutStream).
