%% Test signal generation
SIG_LENGTH = 1e5;
rate = 8000;
M = 6;

sig = randn(SIG_LENGTH, 1); % Look direction signal

bpFilt = designfilt('bandpassfir', 'FilterOrder', 100, ...
             'CutoffFrequency1', 0.12, 'CutoffFrequency2', 0.13,...
             'SampleRate', 1);
sig0 = filter(bpFilt,sig);

bpFilt = designfilt('bandpassfir', 'FilterOrder', 100, ...
             'CutoffFrequency1', 0.095, 'CutoffFrequency2', 0.105,...
             'SampleRate', 1);
sig1 = filter(bpFilt,sig);

audiowrite('target.wav', sig0, rate);
audiowrite('interf_10dBSIR.wav', 0.316.*sig1, rate);