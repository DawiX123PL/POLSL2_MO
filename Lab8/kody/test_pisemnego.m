% Autorzy:
% Dawid Kania
% Oliwier Cieślik


clear all; close all; clc


x0 = 1; % stan poczatkowy
t = [2 2]; % początkowe wspolczynniki kary
N = 3; % horyzont sterowania
%I = @(x,u) sum( x.^2 + 1.5 * u.^2, "all"); % wskaznik jakosci
I = @(x,u) sum(x.^2 + u, "all"); % wskaznik jakosci

% ograniczenia 
R = {
    @(x,u,v) 0.5*( x(end) - v ).^2
    @(x,u,v) sum( (-u-v).*max(0, (-u-v)) ,"all")
};

a = { [16], [-4;-4;-4] }

v = a
c = 2

epsilon = 0.001
beta = 2
alfa = 0.5

for nr_iteracji = 1:2
    % krok 4

    % sterowanie jako wartość startowa funkcji fminsearch
    u = ones(N,1);
    u_optymalne = u;

    % obliczanie optymalnego sterowania 
    u_optymalne = fminsearch(@(u_) I_calc(u_, I, R, t, x0, v), u_optymalne)
    x_optymalne = obliczanie_x(u_optymalne, x0)
    I_optymalne = I_calc(u, I, R, t, x0, v);

    % krok 5 wyznaczenie 'r'
    r = {
        x_optymalne(end) - a{1}
        max(0, -u_optymalne - a{2})
    }

    % krok 6 - liczenie gamma
    vra = [];
    for w=1:length(r)
        vra = [vra; v{w} + r{w} - a{w} ];
    end
   
    gamma = sqrt(sum(vra.^2, "all"))


    % krok 7
    if(gamma < epsilon)
        break
    end

    % krok 9
    if(gamma < c)
        c = alfa * c
        for w = 1:length(v )
            v{w} = a{w} - r{w}; 
        end
    end
    
    % krok 11
    if(gamma >= c)
        t = beta * t
        for w = 1:length(v )
            v{w} = a{w} - (1/beta) * r{w};
        end
    end

end


% funkcja obliczajaca stan x na bazie sterowania u
function x = obliczanie_x(u, x0)
    
    % rówanie stanu
    x_plus_1 = @(x,u) x + 2*u;

    % obliczenie x
    x = [x0];
    for i = [1:length(u)]
        x = [x; x_plus_1(x(i), u(i))];
    end
end

%obliczanie zmodyfikowanego wskaznika jakosci
function I_m = I_calc(u, I, R, t, x0, v)

    x = obliczanie_x(u, x0);
    x_n = x(1:end-1);

    % obliczenie I_m
    I_m = I(x_n,u);
    for j = 1:length(R)
        I_m = I_m + t(j)*R{j}(x,u,v{j});
    end

end

