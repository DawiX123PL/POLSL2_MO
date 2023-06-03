clear all; close all; clc

% równanie stanu
r_stanu = @(x, u) 0.5*x + 0.9*u;

% wskaznik jakosci
Ln = @(x, u) 10*(x - 3).^2 + u.^2;
hn = @(x) 0;
I  = @(x, u) sum( Ln(x, u) ) + hn(x);

% predkosc uogólniona
p_n = @(x, u, p_plus_1) 20*(x - 3) + 0.5*p_plus_1;

% gradient
b_n = @(x, u, p_plus_1) 2*u + 0.9*p_plus_1;

x0 = 8;
e = 0.2;

K = 15;
u = [3 2 3 2 2];

N = length(u)+1;

I_trajectory = [];

for k = 1:K
    
    x = x_calc(x0, u, r_stanu); % wyznaczenie stanu układu

    % obliczenie prędkości i predkosci
    p = zeros(1, N);
    b = zeros(1, N-1);
    for n = N-1:-1:1
        p(n) = p_n(x(n), u(n), p(n+1));
        b(n) = b_n(x(n), u(n), p(n+1));
    end

    % warunek stopu 
    if norm(b) < e
        break
    end

    if k == K
        break
    end

    % wyznaczanie kierunku poszukiwania minimum
    if k == 1
        c = 0;
        dir = -b;
    else
        c = (norm(b)^2) / (norm(b_old)^2);
        dir = -b + c * dir;
    end

    b_old = b;

    % znajdowanie poprawionego sterowania
    [t_popr, I_popr] = fminsearch(@(t) fmin(t, x0, u, dir, r_stanu, I), 0);
    I_trajectory(end+1) = I_popr;
    disp("k = " + string(k) + char(9) +" I popr = " + string(I_popr));
    u = u + t_popr*dir;
end

plot(I_trajectory)

function J = fmin(t, x0, u, dir, r_stanu, I)
    ut = u + t*dir;
    x = x_calc(x0, ut, r_stanu);
    J = I(x(1:end-1), ut);
end

function x = x_calc(x0, u, r_stanu)
    x = x0;
    for u_n = u
        x(end+1) = r_stanu(x(end), u_n);
    end
end

