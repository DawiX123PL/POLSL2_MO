clear all; close all; clc;

%PID_kr = 0.67245
%PID_Ti = 1.42
%PID_Td = 0.355

% PID_kr = 0.41568
% PID_Ti = 1.74
% PID_Td = 0.435
% 
% filter_coeficient = 100
% 
% w_target = 0.5;
% 
% u_limit = [0 1];

%% optymalizacja metoda sprzezonego gradientu


% PID_kr = 1
% PID_Ti = 1
% PID_Td = 1

PID_kr = 0.41568
PID_Ti = 1.74
PID_Td = 0.435



x0 = [PID_kr, PID_Ti, PID_Td]

F = @(x) PID_to_ISE(x(1), x(2), x(3))
n = 100;
epsilon = 0.001;
delta = 0.01;
alfa = 0.1;

x_min = GradientSearchMin(F, x0, epsilon, n, delta, alfa);

PID_kr_opt = x_min(1)
PID_Ti_opt = x_min(2)
PID_Td_opt = x_min(3)

Plot_PID(PID_kr_opt, PID_Ti_opt, PID_Td_opt)


%% symulacja


ise = PID_to_ISE(1,2,3)


function ise = Plot_PID(PID_kr, PID_Ti, PID_Td)

    filter_coeficient = 100;
    w_target = 0.5;
    u_limit = [0 1];
    
    w=warning('off','all');
    sim_out = sim("object_with_PID.slx", "SrcWorkspace", "current", 'FastRestart', 'on');
    warning(w);

    sim_out.SimulationMetadata.TimingInfo

    Y = sim_out.Y;
    E = sim_out.E;
    
    figure
    hold on
    plot(Y);
    plot(E);
    
    ise = ISE(E)    
end


function ise = PID_to_ISE(PID_kr, PID_Ti, PID_Td)

    filter_coeficient = 100;
    w_target = 0.5;
    u_limit = [0 1];
    
    w=warning('off','all');
    sim_out = sim("object_with_PID.slx", "SrcWorkspace", "current", 'FastRestart', 'on');
    warning(w);

    sim_out.SimulationMetadata.TimingInfo

    Y = sim_out.Y;
    E = sim_out.E;
    
%     figure
%     hold on
%     plot(Y);
%     plot(E);
    
    ise = ISE(E)    
end


%% wskaznik jakosci ISE

function ise = ISE(E_ts)

    E = E_ts.Data(1:end-1);
    T = E_ts.Time;

    Delta_t = T(2:end) - T(1:end-1);
    
    ise = sum( (E.^2) .* Delta_t );

end