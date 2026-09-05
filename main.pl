
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

