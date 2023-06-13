clear all; close all; clc;
%%

Alpha = [0.1];
Delta = [0.001];
epsilon = {0.0001, 0.0001};

QI = @(e, u) MeanError(e);

WYNIKI_FOLDER = "../wyniki/Zad2/GP";
model_file = "object_with_PID";


metoda_optymalizacji = "GradProsty";

%%
Zad1234_Com