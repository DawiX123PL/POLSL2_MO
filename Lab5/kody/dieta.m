clear all; close all; clc


produkt = [
        optimvar('x01_brokul',              'LowerBound',0);
        optimvar('x02_biala_kielbasa',      'LowerBound',0);
        optimvar('Ax03_jablko',             'LowerBound',0);
        optimvar('x04_marchew',             'LowerBound',0);
        optimvar('x05_mleko',               'LowerBound',0);
        optimvar('x06_poledwica',           'LowerBound',0);
        optimvar('Bx07_pomarancza',         'LowerBound',0);
        optimvar('x08_ser_bialy',           'LowerBound',0);
        optimvar('x09_ser_zolty',           'LowerBound',0);
        optimvar('x10_szynka_pieczona',     'LowerBound',0);
    ]


cena = [
        7.00
        10.00
        4.00
        1.59
        2.00
        3.49
        4.29
        4.09
        2.19
        13.95
    ]

kalorie = [
        330
        3360
        730
        270
        440
        154
        456
        303
        316
        1495
    ]


prob = optimproblem();

prob.Objective = cena' * produkt;

prob.Constraints.c1 = kalorie' * produkt >= 1000;
prob.Constraints.c2 = kalorie' * produkt <= 4000;



%% rozwiązanie

%solution = linprog(f, -A, -B, [], [], x_ograniczenie_dolne, x_ograniczenie_gorne);

problem = prob2struct(prob);
[solution, wskaznik_jakosci] = linprog(problem);

disp(prob.Variables)
disp(solution)

disp("f = " + string(wskaznik_jakosci));


