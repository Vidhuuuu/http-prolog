:- module(parse_req, [parse_request/2]).

parse_request(Request, Response) :-
    (Request = "" ->
        Response = "HTTP/1.0 400 Bad Request\r\n\r\n",
        !
    ;
        (split_string(Request, " \r\n", "", [Method, Path, Version | _]) ->
            handle_method(Method, Path, Version, Response)
        ;
            Response = "HTTP/1.0 400 Bad Request\r\n\r\n",
            !
        )
    ).

handle_method("GET", Path, Version, Response) :-
    serve_get_req(Path, Version, Response).
handle_method(_, _, _, Response) :-
    Response = "HTTP/1.0 405 Method Not Allowed\r\n\r\n",
    !.

serve_get_req("/", Version, Response) :-
    serve_get_req("/index.html", Version, Response).
serve_get_req(Path, Version, Response) :-
    atom_concat('static', Path, FilePath),
    (exists_file(FilePath) ->
        size_file(FilePath, FileSize),
        read_file_to_string(FilePath, FileContent, []),
        format(string(Response),
        "~s 200 OK\r\nContent-Type: text/html\r\nContent-Length:~d\r\n\r\n~s",
            [Version, FileSize, FileContent])
    ;
        Response = "HTTP/1.0 404 File Not Found\r\n\r\n",
        !
    ).
