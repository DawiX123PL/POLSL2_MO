clear all; close all; clc

% równanie stanu
r_stanu = @(x, u) x + u

% wskaznik jakosci
Ln = @(x, u) 1/2*( x.^2 + u.^2 )
hn = @(x) 0
I  = @(x, u) sum( Ln(x, u) ) + hn(x)

% predkosc uogólniona
p_n = @(x, u, p_plus_1) x + p_plus_1

% gradient
b_n = @(x, u, p_plus_1) u + p_plus_1

x0 = 1
e = 0.2

K = 15
K = 1000;
u = [1 9 8 1]

N = length(u)+1

for k = 1:K
    
    x = x_calc(x0, u, r_stanu) % wyznaczenie stanu układu

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

    % znajdowanie poprawionego sterowania
    
    t_popr = fminsearch(@(t) fmin(t, x0, u, b, r_stanu, I), 0)
    u = u - t_popr*b;
end

function J = fmin(t, x0, u, b, r_stanu, I)
    ut = u - t*b;
    x = x_calc(x0, ut, r_stanu);
    J = I(x(1:end-1), ut)
end

% function I = I_zmodyfikowane(x, u, p, Ln, fn)
%     x_n = x(2:end-1);
%     u_n = u(2:end);
%     p_n = p(2:end-1);
%     p_n_plus = p(3:end);
% 
%     I = p(1)*x(1) ...
%         + sum( Ln(x_n, u_n) + p_n_plus.*fn(x_n, u_n) - p_n.*x_n) ...
%         - p(end)*x(end);
% end


function x = x_calc(x0, u, r_stanu)
    x = x0;
    for u_n = u
        x(end+1) = r_stanu(x(end), u_n);
    end
end

