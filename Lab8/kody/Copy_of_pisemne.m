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
x_optymalne = obliczanie_x(u_optymalne, x0)'


% funkcja obliczajaca stan x na bazie sterowania u
function x = obliczanie_x(u, x0)
    
    % rówanie stanu
    x_plus_1 = @(x,u) x + 2*u;

    % obliczenie x
    x = [x0];
    for i = [1:length(u)]
        x(i+1) = x_plus_1(x(i), u(i));
    end
end

%obliczanie zmodyfikowanego wskaznika jakosci
function I_m = I_calc(u, I, R, t, x0)

    x = obliczanie_x(u, x0);

    % obliczenie I_m
    I_m = I(x,u);
    for j = 1:length(R)
        I_m = I_m + t(j)*R{j}(x,u);
    end

end

