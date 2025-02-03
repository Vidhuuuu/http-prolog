:- module(parse_req, [parse_request/2]).

parse_request(Request, Response) :-
    split_string(Request, " \r\n", "", [Method, Path, _Version | _]),
    (Method == "GET" ->
        serve_get_req(Path, Response)
    ;
        Response = "HTTP/1.0 405 Method Not Allowed\r\n\r\n"
    ).

serve_get_req(Path, Response) :-
    atom_concat('static', Path, FilePath),
    (exists_file(FilePath) ->
        size_file(FilePath, FileSize),
        read_file_to_string(FilePath, FileContent, []),
        format(string(Response),
        "HTTP/1.0 200 OK\r\nContent-Type: text/html\r\nContent-Length:~d\r\n\r\n~s",
            [FileSize, FileContent])
    ;
        Response = "HTTP/1.0 404 File Not Found\r\n\r\n"
    ).
