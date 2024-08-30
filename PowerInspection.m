
[original, fs] = audioread('multich_test.wav');
[enhanced, ~] = audioread('sample.wav');
[baseline, ~] = audioread('FBF.wav');

window_length = 0.04; % 窗口长度（秒）
overlap_ratio = 0.74;

window_size = round(window_length * fs);
overlap_size = round(overlap_ratio * window_size);
num_windows = floor((length(original) - window_size) / overlap_size) + 1;

power1 = zeros(1, num_windows);
power2 = zeros(1, num_windows);
power3 = zeros(1, num_windows);

for i = 1:num_windows
    start_idx = 1 + (i - 1) * overlap_size;
    end_idx = start_idx + window_size - 1;
    
    window_data_1 = original(start_idx:end_idx, 3);
    window_data_2 = enhanced(start_idx:end_idx);
    window_data_3 = baseline(start_idx:end_idx);
    power1(i) = rms(window_data_1)^2; % 计算每个窗口的均方根功率
    power2(i) = rms(window_data_2)^2;
    power3(i) = rms(window_data_3)^2;
end

% 绘制均方根功率随时间变化的趋势图
time = (window_size/2 : overlap_size : window_size/2 + (num_windows-1)*overlap_size) / fs;
figure;
plot(time, 10*log10(power1)); hold on;
plot(time, 10*log10(power2)); hold on;
plot(time, 10*log10(power3)); hold off;
ylim([-60 0]);
legend('Original', 'GSC', 'FBF')
xlabel('time(s)');
ylabel('Power RMS');