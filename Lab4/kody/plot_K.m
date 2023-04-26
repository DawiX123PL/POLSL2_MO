clear all; close all; clc
% macierze opisujące uklad
% x(i+1) = A*x(i) + B*u(i)

A = [1 1; 1 2];
B = [1 1 1; 1 1 1];

% stan początkowy układu
%x0 = [1 1]';

x0 = [1; 1]


Q = [1 0; 0 1]; % musi być 1 albo 0
R = [1 2 2; 2 2 1; 2 1 1]; % musi być >0
F = [1 0; 0 1];

N = 20; % liczba całkowita 


sterowalny = czy_sterowalny(A,B);

%%
% sprawdzenie czy macierze A i B są prawidłowo zapisane
if size(A,1) ~= size(A,2)
    error("Macierz 'A' musi mieć wymiary n*n!" + newline + ...
        "size(A) = [n n] = " + size(A,1) + "*" + size(A,2) + newline + ...
        "size(B) = [n m] = " + size(B,1) + "*" + size(B,2))
end

n = size(A,1);

if size(B,1) ~= n
    error("Macierz 'B' musi mieć wymiary n*m!" + newline + ...
        "size(A) = [n n] = " + size(A,1) + "*" + size(A,2) + newline + ...
        "size(B) = [n m] = " + size(B,1) + "*" + size(B,2))
end

m = size(B,2);

%%
% sprawdzenie czy macierze Q,R,F są prawidłowo zapisane

if ~isequal(size(Q), [n n])
    error("Macierz 'Q' musi mieć wymiary n*n!" + newline + ...
        "size(Q) = " + size(Q,1) + "*" + size(Q,2) + newline + ...
        "n = " + n)
end

if ~isequal(size(R), [m m])
    error("Macierz 'R' musi mieć wymiary m*m!" + newline + ...
        "size(F) = " + size(R,1) + "*" + size(R,2) + newline + ...
        "m = " + m)
end

if ~isequal(size(F), [n n])
    error("Macierz 'F' musi mieć wymiary n*n!" + newline + ...
        "size(F) = " + size(F,1) + "*" + size(F,2) + newline + ...
        "n = " + n)
end

if ~issymmetric(Q)
    error("Macierz 'Q' musi być symetryczna")
end

if ~issymmetric(R)
    error("Macierz 'R' musi być symetryczna")
end

if ~issymmetric(F)
    error("Macierz 'F' musi być symetryczna")
end

%%

% obliczanie wartości K(i) dla i = 0:N (równanie (5))
% UWAGA!!! - w matlabie nie działają ujemne indexy
% zamiast K{n} jest K{n+1}
% zamiast K{0} jest K{1}

K = cell(N + 1,1);
K(end) = {F};

for i = N:-1:1
    K{i} = A' * ( K{i+1} - K{i+1}*B * (R + B'*K{i+1}*B)^-1 * B'*K{i+1} ) * A + Q;
end


% wyznaczanie sterowania u{i} i x{i} (równanie (3))

%u = cell(N,1);
%x = cell(N,1);
%x{1} = x0;
u = [];
x = x0;

for i = 1:N
    S_prim_i = (R + B'*K{i+1}*B)^-1 * B'*K{i+1}*A; % równanie (3)
    u(:,i) = -S_prim_i * x(:,i); % równanie (3)
    x(:,i+1) = A*x(:,i) + B*u(:,i); % równanie (1)
end


% obliczanie wskaźnika Jo_0 (równanie (4))

Jo_0 = 1/2 * x0' * K{1} * x0;

% obliczanie wskaźników Jo{i} (równanie (6))

Jo = cell(N,1);

for i = 1:N+1
    J0{i} = 1/2 * x(:,i)' * K{i} * x(:,i);
end


%%
% PLOTy


% Plot K(i)
figure('Name',"K(i)",'NumberTitle','off')
hold on
Legend_pos = string.empty;
for pos_x = 1:n
    for pos_y = 1:n

        Legend_pos(end+1) = "K_{" + pos_x + " " + pos_y +  "}(i)";
        k_xy_i = [];

        for Ki = K'
            k_xy_i(end+1) = Ki{1}(pos_x, pos_y);
        end

        stairs(k_xy_i)

    end
end

legend(Legend_pos)







