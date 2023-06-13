clear all; close all; clc;
%%

Alpha = [0.1];
Delta = [0.001];
epsilon = {0.0001, 0.0001};

QI = @(e, u) ISE_ISC(e, u);

WYNIKI_FOLDER = "../wyniki/Zad3/GP";
model_file = "object_with_PID";


metoda_optymalizacji = "GradProsty";

%%
Zad1234_Com