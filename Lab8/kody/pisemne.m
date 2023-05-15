% autor:
% Dawid Kania
% Oliwier Cieślik


clear all; close all; clc


x0 = 1; % stan poczatkowy
t = [2 2]; % początkowe wspolczynniki kary
N = 3; % horyzont sterowania
I = @(x,u) sum(x.^2 + u, "all"); % wskaznik jakosci

% ograniczenia 
R = {
    @(x,u) 0.5*( x(end) - 16 ).^2
    @(x,u) sum( (-u+4).*max(0, (-u+4)) ,"all")
};

% sterowanie jako wartość startowa funkcji fminsearch
u = ones(N,1);

% obliczanie optymalnego sterowania 

u_optymalne = fminsearch(@(u) I_calc(u, I, R, t, x0), u)
x_optymalne = obliczanie_x(u_optymalne, x0)

% ograniczenia 
R = {
    @(x,u) 0.5*( x(end) - [15.8577] ).^2
    @(x,u) sum( (-u+[8.2013; 7.9088; 7.0689]).*max(0, (-u+[8.2013; 7.9088; 7.0689])) ,"all")
};

u_optymalne2 = fminsearch(@(u) I_calc(u, I, R, t, x0), u)
x_optymalne2 = obliczanie_x(u_optymalne2, x0)



% funkcja obliczajaca stan x na bazie sterowania u
function x = obliczanie_x(u, x0)
    
    % rówanie stanu
    x_plus_1 = @(x,u) x + 2*u;

    % obliczenie x
    x = [x0];
    for i = [1:length(u)]
        x = [x;  x_plus_1(x(i), u(i))];
    end
end

%obliczanie zmodyfikowanego wskaznika jakosci
function I_m = I_calc(u, I, R, t, x0)

    x = obliczanie_x(u, x0);
    x_n = x(1:end-1);
    

    % obliczenie I_m
    I_m = I(x_n,u);
    for j = 1:length(R)
        I_m = I_m + t(j)*R{j}(x,u);
    end

end

