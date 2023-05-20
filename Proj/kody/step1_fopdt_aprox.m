clear all; close all; clc


u_step = 0.5;
t_step = 40;

y_stable_since_time = 20; %[s]




%% symulacja

sim_out = sim("FOPDT_aprox.slx");
Y = sim_out.Y;

plot(Y)
hold on;

%% Aproksymacja FOPDT - metoda dwoch punktow

% wyznaczenie Y_0 i Y_stable
y_0 = mean(getsampleusingtime(Y, 0, t_step));
y_stable = mean(getsampleusingtime(Y, t_step + y_stable_since_time));


% obliczenie 63,2% * (Y_stable-Y_0)
% obliczenie 28,3% * (Y_stable-Y_0)

y_63 = 0.632 * (y_stable-y_0);
y_28 = 0.283 * (y_stable-y_0);

% znalezienie punktow przeciecia z y_63 i y_28

t1 = Y.Time(find(Y.Data>y_28, 1,'first'));
t2 = Y.Time(find(Y.Data>y_63, 1,'first'));

T_obj = 1.5 * (t2 - t1);
T0_obj = (t2-t_step)-T_obj;

% obliczenie wzmocnienia układu

K_obj = (y_stable - y_0) / u_step;


%% wyświetlenie wyników aproksymacji

yline(y_0)
yline(y_stable)
yline(y_63)
yline(y_28)
xline(t_step)
xline(t1)
xline(t2)

disp("K_obj  = " + string(K_obj))
disp("T_obj  = " + string(T_obj))
disp("T0_obj = " + string(T0_obj))

disp(" ");


%% wyznaczenie wartości regulatora PID (kryterium QDR)


PID_kr = 1.2 * T_obj / (K_obj * T0_obj);
PID_Ti = 2 * T0_obj;
PID_Td = 0.5 * T0_obj;

disp("PID_kr = " + string(PID_kr));
disp("PID_Ti = " + string(PID_Ti));
disp("PID_Td = " + string(PID_Td));







