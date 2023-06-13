clear all; close all; clc;
%%

Alpha = [0.1];
Delta = [0.001];
epsilon = {0.0001, 0.0001};

QI = @(e, u) ISE_100(e);

WYNIKI_FOLDER = "../wyniki/Zad1/GPM";
model_file = "object_with_PID";


metoda_optymalizacji = "GradProstyMOD";

%%
Zad1234_Com