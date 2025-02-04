:- module(parse_req, [parse_request/2]).
:- use_module(server/method_handlers/get_handler, [serve_get_req/3]).
:- use_module(server/method_handlers/head_handler, [serve_head_req/3]).

parse_request(Request, Response) :-
    (Request = "" ->
        Response = "HTTP/1.0 400 Bad Request\r\n\r\n"
    ;
        (split_string(Request, " \r\n", "", [Method, Path, Version | _]) ->
            handle_method(Method, Path, Version, Response)
        ;
            Response = "HTTP/1.0 400 Bad Request\r\n\r\n"
        )
    ).

handle_method("GET", Path, Version, Response) :-
    serve_get_req(Path, Version, Response).
handle_method("HEAD", Path, Version, Response) :-
    serve_head_req(Path, Version, Response).
handle_method(_, _, _, Response) :-
    Response = "HTTP/1.0 405 Method Not Allowed\r\n\r\n".
