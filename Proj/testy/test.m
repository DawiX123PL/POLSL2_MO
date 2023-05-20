clear all
clc


syms x;
func(x) = 1/4 * x.^4 - 2/3 * x.^3 - 1/2 * x.^2 + 2*x;
X = -2:0.1:3;
Y = func(X);

plot(X,Y)


wynik = [];

%x,a,b,j] = MetodaGradientowa(func, , x0    ,beta   ,t      , eps   , n)

[x,a,b,j] = MetodaGradientowa(func, 3       , 0.3   , 0.1   , 0.1   , 120)
wynik = [wynik ; x,j];
[x,a,b,j] = MetodaGradientowa(func, 3       , 0.5   , 0.1   , 0.1   , 120)
wynik = [wynik ; x,j];
[x,a,b,j] = MetodaGradientowa(func, 3       , 0.9   , 0.1   , 0.1   , 120)
wynik = [wynik ; x,j];


disp(wynik)