%% Main GSC
% clear;
% filename = 'revSpeech_test.wav';
% d=0.15;
% Dtheta = 5;    % DOA error in degree
% K = 10.0;   % Threshold of NCAF
% P = 16; N = 8; % define the order of CCAF & NCAF
% ITER1 = 48000; ITER2 = 120000; mu1 = 0.001; mu2 = 0.001;
% 
% OutputSignal = HoshuyamaGSC(filename, d, Dtheta, K, P, N, ITER1, ITER2, mu1, mu2);
% audiowrite('revSpeech.wav', OutputSignal, 8000);

clear;
filename = 'multich_test.wav';
d=0.15;
Dtheta = 5;    % DOA error in degree
K = 10.0;   % Threshold of NCAF
P = 16; N = 8; % define the order of CCAF & NCAF
ITER1 = 16000; ITER2 = 4e4; mu1 = 0.01; mu2 = 0.01;

OutputSignal = HoshuyamaGSC(filename, d, Dtheta, K, P, N, ITER1, ITER2, mu1, mu2);
audiowrite('sample.wav', OutputSignal, 8000);