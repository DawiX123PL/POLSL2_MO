clear all; close all; clc

% problem P0

x1 = optimvar('x1','LowerBound',0);
x2 = optimvar('x2','LowerBound',0);
x3 = optimvar('x3','LowerBound',0);
x4 = optimvar('x4','LowerBound',0);
x5 = optimvar('x5','LowerBound',0);
x6 = optimvar('x6','LowerBound',0);
x7 = optimvar('x7','LowerBound',0);

prob = optimproblem();

prob.Objective = x1 + 8*x2 + 4*x3 + 6*x4 + 9*x5 + x6 + 9*x7;

prob.Constraints.c1 = 4*x2 + 2*x4 >= 94;
prob.Constraints.c2 = 6*x1 + x4 >= 70;
prob.Constraints.c3 = 2*x2 + 3*x5 + 4*x6 >= 73;
prob.Constraints.c4 = x3 + 8*x6 >= 86;

prob.Constraints.c100 = x1 >= 12;
prob.Constraints.c101 = x2 <= 23;
prob.Constraints.c102 = x6 >= 11;



%% rozwiązanie

%solution = linprog(f, -A, -B, [], [], x_ograniczenie_dolne, x_ograniczenie_gorne);

problem = prob2struct(prob);
[solution, wskaznik_jakosci] = linprog(problem);

disp(prob.Variables)
disp(solution)

disp("f = " + string(wskaznik_jakosci));


