:- module(head_handler, [serve_head_req/3]).
:- use_module(server/method_handlers/media_types, [media_type/2]).

serve_head_req("/", Version, Response) :-
    serve_head_req("/index.html", Version, Response).
serve_head_req(Path, Version, Response) :-
    atom_concat('static', Path, FilePath),
    (exists_file(FilePath) ->
        file_name_extension(_, Ext, Path),
        atom_concat('.', Ext, PeriodExt),
        media_type(PeriodExt, MediaType),

        size_file(FilePath, FileSize),
        format(string(Response),
        "~s 200 OK\r\nContent-Type: ~w\r\nContent-Length:~d\r\n\r\n",
            [Version, MediaType, FileSize])
    ;
        Response = "HTTP/1.0 404 File Not Found\r\n\r\n"
    ).
