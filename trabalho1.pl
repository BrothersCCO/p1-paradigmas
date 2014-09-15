professor('Patrícia').
professor('Mauro').
professor('Dovicchi').
professor('Ranieri').
professor('Maike').
professores(Z) :- findall(X, professor(X), Z).

aluno(eduardo).
aluno(ranieri).
aluno(maike).
alunos(Z) :- findall(X, aluno(X), Z).

mestrando('Ranieri', 2013).

orientou('Mauro', 'Eduardo').
orientou('Mauro', 'Ranieri').
orientou('Dovicchi', 'Maike').

publicou('Ranieri', 'A importância dos dinossauros kawaii-desu', 2014).
publicou('Maike', 'A importância dos dinossauros kawaii-desu', 2014).

publicou('Eduardo', 'Como o amor pode afetar as libélulas', 2013).
publicou('Ranieri', 'Como o amor pode afetar as libélulas', 2013).

publicou('Dovicchi', 'Fotos da tua mãe pelada', 2013).
publicou('Mauro', 'Fotos da tua mãe pelada', 2013).
publicou('Ranieri', 'Fotos da tua mãe pelada', 2013).

orientandos(X, Y) :- findall(Z, orientou(X, Z), Y).
publicacoes(X, Y) :- findall(Z, publicou(X, Z, _), Y).

qtd_orientandos(X, Y) :- orientandos(X, Z), length(Z, Y).
qtd_publicacoes(X, Y) :- publicacoes(X, Z), length(Z, Y).

menos_orientandos(<, X, Y) :- qtd_orientandos(X, A), qtd_orientandos(Y, B), A > B.
menos_orientandos(>, X, Y) :- qtd_orientandos(X, A), qtd_orientandos(Y, B), A < B.
menos_orientandos(=, X, Y) :- qtd_orientandos(X, A), qtd_orientandos(Y, B), A = B.

menos_publicacoes(<, X, Y) :- qtd_publicacoes(X, A), qtd_publicacoes(Y, B), A > B.
menos_publicacoes(>, X, Y) :- qtd_publicacoes(X, A), qtd_publicacoes(Y, B), A < B.
menos_publicacoes(=, X, Y) :- qtd_publicacoes(X, A), qtd_publicacoes(Y, B), A = B.

professor_com_mais_orientandos(Z) :-
	professores(Y),	predsort(menos_orientandos, Y, [Z | _]).

orientando_com_mais_publicacoes_por_professor(X, Y) :-
	orientandos(X, A), predsort(menos_publicacoes, A, [Y | _]).

nao_tem_orientandos(Z) :- qtd_orientandos(Z, A), A = 0, !.
professores_sem_orientandos(Z) :-
	professores(A), include(nao_tem_orientandos, A, B), length(B, Z).

media_orientandos(Z) :-
	professores(A), length(A, X),
	maplist(qtd_orientandos, A, B),
	sumlist(B, Y),
	Z is Y / X.

se_forma_ate(X, Y) :-
	mestrando(X, A),
	B is Y,
	B > A, !.

coautorado(X) :-
	professores(A),
	findall(Y, publicou(Y, X, _), B),
	intersection(A, B, Y),
	length(Y, Z),
	Z >= 2, !.

questao12(Z) :-
	findall(X, publicou(_, X, _), C),
	include(coautorado, C, Y),
	sort(Y, Z).

contem_professor(X) :-
	professores(A),
	intersection(A, X, B),
	length(B, C),
	C > 0, !.

media_anual(X, Y) :-
	professores(A),
	findall(Y, publicou(Y, _, X), B),
	include(contem_professor, B, C),
	length(C, D),
	length(A, E),
	Y is D / E.