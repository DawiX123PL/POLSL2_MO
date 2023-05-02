clear all; close all; clc
% macierze opisujące uklad
% x(i+1) = A*x(i) + B*u(i)

A = [2 0; 1 2];
B = [2; 3];

% stan początkowy układu
x0 = [10; 15]

Q = [3 -2; -2 2]; % musi być 1 albo 0
F = [0 0; 0 0];

R_all = {
        [10]
        [12]
        [14]
        [20]
        [40]
        [60]
    }; % musi być >0

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

% if ~isequal(size(R), [m m])
%     error("Macierz 'R' musi mieć wymiary m*m!" + newline + ...
%         "size(F) = " + size(R,1) + "*" + size(R,2) + newline + ...
%         "m = " + m)
% end

if ~isequal(size(F), [n n])
    error("Macierz 'F' musi mieć wymiary n*n!" + newline + ...
        "size(F) = " + size(F,1) + "*" + size(F,2) + newline + ...
        "n = " + n)
end

if ~issymmetric(Q)
    error("Macierz 'Q' musi być symetryczna")
end

% if ~issymmetric(R)
%     error("Macierz 'R' musi być symetryczna")
% end

if ~issymmetric(F)
    error("Macierz 'F' musi być symetryczna")
end

%%

X = {}
U = {}

for R_temp = R_all'
    R = R_temp{1};

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

    % zapisanie wartości 'x' i 'u'
    X{end+1} = x;
    U{end+1} = u;

end

%%
% PLOTy
% 
% for i = 1:n
%     
%     figure('Name',"x_" + string(i) + "(i)",'NumberTitle','off')
%     hold on
%     title("przebieg x_" + string(i) + "(i)")
%     
%     Legend_pos = string.empty
% 
%     for j = 1:length(R_all)
%         stairs([0:N]', X{j}(i,:)');
%         Legend_pos(end+1) = "x_{" + i + "}(i) dla R = " + mat2str(R_all{j})
%     end
% 
%     legend(Legend_pos)
% end
% 
% % Plot u(i)
% for i = 1:m
%     figure('Name',"u_" + string(i) + "(i)",'NumberTitle','off')
%     hold on
%     title("przebieg u_" + string(i) + "(i)")
% 
%     Legend_pos = string.empty
% 
%     for j = 1:length(R_all)
%         stairs([0:N-1]', U{j}(i,:)');
%         Legend_pos(end+1) = "u_{" + i + "}(i) dla R = " + mat2str(R_all{j})
%     end
% 
%     legend(Legend_pos)
% end
% 


%figure
%tiledlayout(2, max(n,m))
% plot x(i)
for i = 1:n
    %nexttile(2*i-1)

    figure('Name',"x_" + string(i) + "(i)",'NumberTitle','off')
    hold on
    %title("przebieg x_" + string(i) + "(i)")
    
    Legend_pos = string.empty

    for j = 1:length(R_all)
        plot([0:N]', X{j}(i,:)');
        Legend_pos(end+1) = "x_{" + i + "}(i) dla R = " + mat2str(R_all{j})
    end

    legend(Legend_pos)
    
end

% Plot u(i)
for i = 1:m
    %nexttile(2*i)
    figure('Name',"u_" + string(i) + "(i)",'NumberTitle','off')
    hold on
    %title("przebieg u_" + string(i) + "(i)")

    Legend_pos = string.empty

    for j = 1:length(R_all)
        plot([0:N-1]', U{j}(i,:)');
        Legend_pos(end+1) = "u_{" + i + "}(i) dla R = " + mat2str(R_all{j})
    end

    legend(Legend_pos)

end







