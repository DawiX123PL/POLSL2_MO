%clear all; delete all; clc;


DESTINATION_FOLDER = "C:\Users\Dawid\Desktop\POLSL_MO\Proj\wyniki\ISE_100\Wyniki_2\"

%% parametry optymalizacji

% PID_kr = 1
% PID_Ti = 1000
% PID_Td = 0

PID_kr = 0.41568
PID_Ti = 1.74
PID_Td = 0.435
PID_h = 0.1

filter_coeficient = 100;
w_target = 0.5;
u_limit = [0 1];

Model_file = "object_with_PID.slx"

x0 = [PID_kr, PID_Ti, PID_Td] % punkt poczatkowy optymalizacji

n = 1000;
epsilon = {0.00001, 0.00001};
delta = 0.001; % delta = {0.001, 0.01, 0.1, 1}
alfa = 1; % alfa = {0.05, 1}


%% optymalizacja metoda sprzezonego gradientu i wyswietlenie wyniku

% wskaźnik jakości
QI = @(e) ISE_100(e)
%QI = @(e) ISE_20_100(e)
%QI = @(e) ISE_ISC(e)
%QI = @(e) MeanError(e)

% przeksztalcenie minimalizowanej funkcji do postaci y = F(x)
F = @(x) PID_to_QI(x(1), x(2), x(3), filter_coeficient, w_target, u_limit, PID_h, QI, Model_file)

% minimalizacja
tic
[x_min, trajectory, iter, Q_trajectory] = GradientSearchMin(F, x0, epsilon, n, delta, alfa);
% [x_min, trajectory, iter] = GradientConjugateSearchMin(F, x0, epsilon, n, delta, alfa);
toc

PID_kr_opt = x_min(1)
PID_Ti_opt = x_min(2)
PID_Td_opt = x_min(3)


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
plot([0: length(trajectory_kr)-1], trajectory_kr);
ylabel("kr");
xlabel("iteration");
grid on

nexttile;
plot([0: length(trajectory_Ti)-1], trajectory_Ti);
ylabel("Ti");
xlabel("iteration");
grid on

nexttile;
plot([0: length(trajectory_Td)-1], trajectory_Td);
ylabel("Td");
xlabel("iteration");
grid on

nexttile;
plot([0: length(Q_trajectory)-1], Q_trajectory);
ylabel("QI");
xlabel("iteration");
grid on

saveas(gcf, DESTINATION_FOLDER + 'trajectory.png')
saveas(gcf, DESTINATION_FOLDER + 'trajectory.svg')

%% wyświetlenie plotów dla danego regulatora PID


quality_indicator = Plot_PID(PID_kr_opt, PID_Ti_opt, PID_Td_opt, filter_coeficient, w_target, u_limit, PID_h, QI, Model_file);
saveas(gcf, DESTINATION_FOLDER + 'output.png')
saveas(gcf, DESTINATION_FOLDER + 'output.svg')


%% zapisanie macierzy do plikow

save(DESTINATION_FOLDER + 'trajectory.mat', 'trajectory');
save(DESTINATION_FOLDER + 'Q_trajectory.mat', 'Q_trajectory');
save(DESTINATION_FOLDER + 'PID_min.mat', 'x_min');
save(DESTINATION_FOLDER + 'quality_indicator.mat', 'quality_indicator');

%% 

function quality_indicator = Plot_PID(PID_kr, PID_Ti, PID_Td, filter_coeficient, w_target, u_limit, PID_h, QI, Model_file)
    w=warning('off','all');
    sim_out = sim(Model_file, "SrcWorkspace", "current", 'FastRestart', 'on');
    warning(w);
    
    figure
    hold on
    plot(sim_out.Y);
    plot(sim_out.E);
    xlabel("time");
    yline(0);
    yline(w_target);
    
    legend("y(t)","e(t)", '', '', "Location","east");

    quality_indicator = QI(sim_out.E);
end

%% funkcja uruchamiająca symulacje i zwracająca wskażnik jakości

function quality_indicator = PID_to_QI(PID_kr, PID_Ti, PID_Td, filter_coeficient, w_target, u_limit, PID_h, QI, Model_file)

    filter_coeficient = 100;
    w_target = 0.5;
    u_limit = [0 1];
    
    w=warning('off','all');
    sim_out = sim(Model_file, "SrcWorkspace", "current", 'FastRestart', 'on');
    warning(w);

    sim_out.SimulationMetadata.TimingInfo

    Y = sim_out.Y;
    E = sim_out.E;
    
    quality_indicator = QI(E)    
end


