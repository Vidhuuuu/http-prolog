:- module(get_handler, [serve_get_req/3]).
:- use_module(server/method_handlers/media_types, [media_type/2]).

serve_get_req("/", Version, Response) :-
    serve_get_req("/index.html", Version, Response).
serve_get_req(Path, Version, Response) :-
    atom_concat('static', Path, FilePath),
    (exists_file(FilePath) ->
        file_name_extension(_, Ext, Path),
        atom_concat('.', Ext, PeriodExt),
        media_type(PeriodExt, MediaType),

        size_file(FilePath, FileSize),
        read_file_to_string(FilePath, FileContent, []),
        format(string(Response),
        "~s 200 OK\r\nContent-Type: ~w\r\nContent-Length:~d\r\n\r\n~s",
            [Version, MediaType, FileSize, FileContent])
    ;
        Response = "HTTP/1.0 404 File Not Found\r\n\r\n"
    ).
