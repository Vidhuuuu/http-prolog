:- module(media_types, [media_type/2]).

media_type('.html', 'text/html').
media_type('.txt', 'text/plain').
media_type(_, 'application/octet-stream').
