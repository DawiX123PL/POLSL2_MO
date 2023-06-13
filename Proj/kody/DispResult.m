clear all; close all; clc

filename_path = "..\wyniki\Zad4\GPM\a-0.1_d-0.001_e1-0.001_e2-0.001"

load(filename_path + "\wyniki.mat");

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



