:- assertz(course(cmput325)).
:- assertz(course(cmput175)).
:- assertz(course(cmput201)).
:- assertz(course(cmput204)).

:- assertz(prerequisite(cmput204, cmput325)).
:- assertz(prerequisite(cmput175, cmput201)).
:- assertz(prerequisite(cmput175, cmput204)).
