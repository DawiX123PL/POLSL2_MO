clear all; close all; clc


% funckja celu 
f = @(x1,x2)( x1.^2 - 6.*x1.^2.*x2 - 20.*x1 + 3.*x2.^2 + 3.*x1.^4 + 109);


X1 = linspace(-20,20,100);
X2 = linspace(-200,200,100);
[X1, X2] = meshgrid(X1,X2);

Y = f(X1,X2);

F = @(x) f(x(1),x(2));

eps = {0.00001, 0.00001};
% eps = 0.00001
iter_max = 10000;
delta = 0.0001;
%alfa = 1;

alfa = 1;

[x_min, trajectory, iter] = GradientSearchMin(F, [-10; -150], eps, iter_max, delta, alfa);
% [x_min, trajectory, iter] = GradientConjugateSearchMin(F, [-10, -150], eps, iter_max, delta, alfa);

trajectory_x1 = zeros(size(trajectory));
trajectory_x2 = zeros(size(trajectory));

for i = 1:length(trajectory)
    trajectory_x1(i) = trajectory{i}(1);
    trajectory_x2(i) = trajectory{i}(2);
end


disp(x_min)
disp(F(x_min))

disp("iteracja: " + string(iter));

figure; hold on;
contourf(X1,X2,Y, 50)
plot(x_min(1), x_min(2), '*');
plot(trajectory_x1, trajectory_x2);
