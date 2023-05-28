clear all; delete all; clc;

%% parametry optymalizacji

% PID_kr = 1
% PID_Ti = 1000
% PID_Td = 0

PID_kr = 0.41568
PID_Ti = 1.74
PID_Td = 0.435

filter_coeficient = 100;
w_target = 0.5;
u_limit = [0 1];


x0 = [PID_kr, PID_Ti, PID_Td] % punkt poczatkowy optymalizacji

n = 200;
epsilon = 0.00001;
delta = 0.1;
alfa = 0.02;



%% optymalizacja metoda sprzezonego gradientu i wyswietlenie wyniku

% wskaźnik jakości
QI = @(e) ISE_100(e)
%QI = @(e) ISE_20_100(e)
%QI = @(e) ISE_ISC(e)
%QI = @(e) MeanError(e)

% przeksztalcenie minimalizowanej funkcji do postaci y = F(x)
F = @(x) PID_to_QI(x(1), x(2), x(3), filter_coeficient, w_target, u_limit, QI)

% minimalizacja
tic
[x_min, trajectory, iter, Q_trajectory] = GradientSearchMin(F, x0, epsilon, n, delta, alfa);
% [x_min, trajectory, iter] = GradientConjugateSearchMin(F, x0, epsilon, n, delta, alfa);
toc

PID_kr_opt = x_min(1)
PID_Ti_opt = x_min(2)
PID_Td_opt = x_min(3)

%% wyświetlenie plotow

quality_indicator = Plot_PID(PID_kr_opt, PID_Ti_opt, PID_Td_opt, filter_coeficient, w_target, u_limit, QI);

%% wyświetlenie trajektorii
trajectory_kr = zeros(size(trajectory));
trajectory_Ti = zeros(size(trajectory));
trajectory_Td = zeros(size(trajectory));

for i = 1:length(trajectory)
    trajectory_kr(i) = trajectory{i}(1);
    trajectory_Ti(i) = trajectory{i}(2);
    trajectory_Td(i) = trajectory{i}(3);
end

figure
tiledlayout(2,2);
nexttile;
plot(trajectory_kr);
ylabel("kr");
xlabel("iteration");
grid on

nexttile;
plot(trajectory_Ti);
ylabel("Ti");
xlabel("iteration");
grid on

nexttile;
plot(trajectory_Td);
ylabel("Td");
xlabel("iteration");
grid on

nexttile;
plot(Q_trajectory);
ylabel("QI");
xlabel("iteration");
grid on

%% wyświetlenie plotów dla danego regulatora PID

function quality_indicator = Plot_PID(PID_kr, PID_Ti, PID_Td, filter_coeficient, w_target, u_limit, QI)

    w=warning('off','all');
    sim_out = sim("object_with_PID.slx", "SrcWorkspace", "current", 'FastRestart', 'on');
    warning(w);
    
    figure
    hold on
    plot(sim_out.Y);
    plot(sim_out.E);

    quality_indicator = QI(sim_out.E);
end

%% funkcja uruchamiająca symulacje i zwracająca wskażnik jakości

function quality_indicator = PID_to_QI(PID_kr, PID_Ti, PID_Td, filter_coeficient, w_target, u_limit, QI)

    filter_coeficient = 100;
    w_target = 0.5;
    u_limit = [0 1];
    
    w=warning('off','all');
    sim_out = sim("object_with_PID.slx", "SrcWorkspace", "current", 'FastRestart', 'on');
    warning(w);

    sim_out.SimulationMetadata.TimingInfo

    Y = sim_out.Y;
    E = sim_out.E;
    
    quality_indicator = QI(E)    
end


