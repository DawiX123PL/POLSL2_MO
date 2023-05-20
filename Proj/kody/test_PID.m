clear all; close all; clc;

%PID_kr = 0.67245
%PID_Ti = 1.42
%PID_Td = 0.355

PID_kr = 0.41568
PID_Ti = 1.74
PID_Td = 0.435

filter_coeficient = 100

w_target = 0.5;

u_limit = [0 1];


%% symulacja


sim_out = sim("object_with_PID");
sim_out.SimulationMetadata.TimingInfo

Y = sim_out.Y;
plot(Y);
