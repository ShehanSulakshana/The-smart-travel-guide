
:- use_module('knowledge_base/blocked').
:- use_module('logic/graph').
:- use_module('logic/search').
:- use_module('logic/display').

travel(Start, Goal) :-
    nl, writeln('======================================================'),
    format(' SMART ROUTE SEARCH: ~w  ==>  ~w~n', [Start, Goal]),
    writeln('======================================================'),nl,

    (   blocked_road(_, _)
    ->  writeln('\n[!] DETECTED BLOCKED ROADS. REROUTING VIA ALTERNATIVES...'),
        show_blocked_roads, nl
    ;   true
    ),

    writeln('#-- ALGORITHM COMPARISON ---------------------------#'),nl,
    ( bfs(Start, Goal, PathB), path_cost(PathB, DistB)
    ->  display_route_info('BFS', PathB, DistB)
    ;   writeln('  [!] BFS: No route available.')
    ),

    ( dfs(Start, Goal, PathD), path_cost(PathD, DistD)
    ->  display_route_info('DFS', PathD, DistD)
    ;   writeln('  [!] DFS: No route available.')
    ),

    ( astar(Start, Goal, PathA, DistA)
    ->  display_route_info('A* Search', PathA, DistA), nl,
        show_optimal_path(PathA, DistA)
    ;   writeln('  [!] A*: No route available.')
    ),

    ( show_attractions(Goal) -> true ; true ),
    ( show_best_hotel(Goal) -> true ; true ),
    ( show_nearest_hospital(Goal) -> true ; true ),
    writeln('\n# **********************************************').


start :- main_menu.

/* Menu */
main_menu :-
    repeat,
    nl,
    writeln('#======================================================#'),
    writeln('>>>>          THE SMART TRAVEL GUIDE AGENT          <<<<'),
    writeln('#======================================================#'),
    writeln(''),
    writeln('[1]. Find Route  '),
    writeln('[2]. Show Tourist Attractions'),
    writeln('[3]. Find Nearest Hotel'),
    writeln('[4]. Find Nearest Hospital'),
    writeln('[5]. Show Blocked Roads'),
    writeln('[6]. EXIT'),
    writeln(''),
    write('[?]~ Select Option: '),
    read(Choice),
    process_choice(Choice),
    Choice = 0,
    !.

process_choice(1) :-
    nl, write('[?]~ Enter Start Location : '), read(Start),
    write('[?]~ Enter Destination    : '), read(Goal),
    travel(Start, Goal).

process_choice(2) :-
    nl, write('[?]~ Enter Location: '), read(Loc),
    ( show_attractions(Loc) -> true ; writeln('[-] No attraction data found.') ).

process_choice(3) :-
    nl, write('[?]~ Enter Location: '), read(Loc),
    ( show_best_hotel(Loc) -> true ; writeln('[-] No hotel data found.') ).

process_choice(4) :-
    nl, write('[?]~ Enter Location: '), read(Loc),
    ( show_nearest_hospital(Loc) -> true ; writeln('[-] No hospital data found.') ).

process_choice(5) :-
    show_blocked_roads.

process_choice(0) :-
    writeln('\n[*] Exiting program. Safe travels!').

process_choice(Choice > 6) :-
    writeln('\n[!] Invalid Option! Pick 1, 2, 3, 4, 5, or 0.').
