function OutputSignal = HoshuyamaGSC(MultichInput, d, Dtheta, K, P, N, ITER1, ITER2, mu1, mu2)
% Input Multichannel audio FILENAME.
% d: Uniform Linear Array distance of units
filename = MultichInput;
[audio, fs] = audioread(filename);
[SIG_LENGTH, M] = size(audio);
audio = audio+.001*randn(SIG_LENGTH, M);

m = [0:M-1]*d;  % Array geometry for ccafbound computation
L = P+N;
Snapshot = zeros(L, M); % Kind of sample at a clock period
Wc = ones(M, 1) / M;                % Fixed Beamformer
[phi, psi] = ccafbounds(m, fs, Dtheta, P, P);    % CCAF bounds determined
phi = phi'; psi = psi';
H_CCAF = randn(M, P);  % The adaptive BM matrix(an P-tap filter)
W_NCAF = randn(M, N);  % The adaptive MC(an N-tap filter)
Snpsht_ncaf = zeros(M, N);
reg_yo = zeros(M, 1);
reg_d = zeros(1, P);
OutputSignal = zeros(SIG_LENGTH+1e3, 1);
BlockedSignal = zeros(SIG_LENGTH+1e3, 1);


% Beamforming
for indx = 1:SIG_LENGTH+20
    % @Clock posedge, shift the registers🤗sequential logic part
    Snapshot = circshift(Snapshot, 1, 1); 
    if indx <= SIG_LENGTH
        Snapshot(1,:) = audio(indx, :);
    else
        Snapshot(1,:) = zeros(1, M);
    end     % Read in the sample
    reg_d = Update(reg_d, Snapshot(1, :) * Wc); % REG for d(n)
    Snpsht_ncaf = Update(Snpsht_ncaf, reg_yo);  % NCAF signal register
    
    % Combinational logic part
    reg_d_delayed = Snapshot(L, :) * Wc;% REG for delayed d(n), functions at output
    % sig_ccaf = Snapshot(1:P,:);
    reg_yo = Snapshot(P, :).' - H_CCAF*reg_d.'; % Wiener filter
    reg_ya = trace(W_NCAF*Snpsht_ncaf');
    Out = reg_d_delayed - reg_ya;   % Output
    BlockedSignal(indx) = reg_yo(1);
    OutputSignal(indx) = Out;
    H_CCAF = updateBM(H_CCAF, reg_yo, reg_d, [phi, psi], mu1);

    % Coe update
    if indx < ITER1 && mod(indx, 3) == 0
        H_CCAF = updateBM(H_CCAF, reg_yo, reg_d, [phi, psi], mu1);
        
    end
    if indx>=ITER1 && indx < ITER2 && mod(indx, 3) == 0
        W_NCAF = updateMC(W_NCAF, Out, Snpsht_ncaf, K, mu2);
        
    end
end

FBF = audio * Wc;
audiowrite('FBF.wav', FBF, fs);
audiowrite('original.wav', audio(:, 3), fs);
% audiowrite('sample.wav', OutputSignal/max(OutputSignal), fs);
audiowrite('blocked.wav', BlockedSignal/max(BlockedSignal), fs);
end