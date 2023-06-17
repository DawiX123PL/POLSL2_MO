

P1 = [5  29 12 14 15 18 20 24 27 30 34 38];
P2 = [7  29 11 13 16 19 21 22 25 28 35 40];
P3 = [6 30 13 15 16 18 21 22 25 26 29 33];

% xi - ilość dostępnych koparek w danym etapi robót
% u[i] - ilość koparek przydzielonych do danego etapu robót nad drogą


%x(i+1) = x(i) - u(i);
% u(i) <= x(i)


L1  = P2
G2  = 25

G1 = (L1 + G2)'
