clear all; close all; clc


x1 = optimvar('x1','LowerBound',0,'UpperBound',1);
x2 = optimvar('x2','LowerBound',0,'UpperBound',1);
x3 = optimvar('x3','LowerBound',0,'UpperBound',1);
x4 = optimvar('x4','LowerBound',0,'UpperBound',1);
x5 = optimvar('x5','LowerBound',0,'UpperBound',1);
x6 = optimvar('x6','LowerBound',0,'UpperBound',1);

prob = optimproblem();

prob.Objective = -(7*x1 + 4*x2 + 5*x3 + 8*x4 + 9*x5 + 2*x6);

prob.Constraints.c1 = 4*x1 + 8*x2 + 8*x3 + 9*x4 + 9*x5 + 7*x6 <= 31;

prob.Constraints.c100 = x2 == 0;
prob.Constraints.c101 = x6 == 0;


%% rozwiązanie

%solution = linprog(f, -A, -B, [], [], x_ograniczenie_dolne, x_ograniczenie_gorne);

problem = prob2struct(prob);
[solution, wskaznik_jakosci] = linprog(problem);

disp(prob.Variables)
disp(solution)

disp("f = " + string(wskaznik_jakosci));


