clear all; close all; clc


x1 = optimvar('x1','LowerBound',0);
x2 = optimvar('x2','LowerBound',0);
x3 = optimvar('x3','LowerBound',0);

prob = optimproblem();

prob.Objective = 8*x1 + 11*x2 + 4*x3;

prob.Constraints.c1 = 5*x1 + 7*x2 >= 5;
prob.Constraints.c2 = 3*x1 + 7*x3 >= 4;

prob.Constraints.c100 = x3 >= 1;
prob.Constraints.c101 = x2 <= 0;


%% rozwiązanie

%solution = linprog(f, -A, -B, [], [], x_ograniczenie_dolne, x_ograniczenie_gorne);

problem = prob2struct(prob);
[solution, wskaznik_jakosci] = linprog(problem);

disp(prob.Variables)
disp(solution)

disp("f = " + string(wskaznik_jakosci));


