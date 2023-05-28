clear all; close all; clc


% x = [x1; x2; x3]

x_ograniczenie_gorne = [];
x_ograniczenie_dolne = [0 0 0];

% A * x <= B

A = [5, 7,  0;
    3,  0, 7];

B = [5;
    4];

f = [8; 11; 4];

%% rozwiązanie

solution = linprog(f, -A, -B, [], [], x_ograniczenie_dolne, x_ograniczenie_gorne);


disp(solution)
