%% Beampattern test
clear;
d=0.15;
Dtheta = 4;    % DOA error in degree
K = 10.0;   % Threshold of NCAF
P = 16; N = 8; % define the order of CCAF & NCAF
ITER1 = 15000; ITER2 = 35000; mu1 = 0.01; mu2 = 0.01;

folder_path = 'DOAfiles'; 
output_folder = 'output_audio';

% 检查文件夹是否已存在，如果不存在则创建
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
    disp(['文件夹 ', output_folder, ' 已成功创建。']);
else
    disp(['文件夹 ', output_folder, ' 已存在。']);
end


% 获取指定文件夹中的所有音频文件
audio_files = dir(fullfile(folder_path, '*.wav')); % 可根据实际文件格式调整
file_numbers = zeros(numel(audio_files), 1);
for i = 1:numel(audio_files)
    % 使用正则表达式提取文件名中的数字部分
    file_name = audio_files(i).name;
    number_str = regexp(file_name, '\d+', 'match');
    
    % 将提取的数字部分转换为实际数字
    if ~isempty(number_str)
        file_numbers(i) = str2double(number_str{1});
    end
end
% 根据文件名中的数字大小排序
[~, sorted_idx] = sort(file_numbers);
L = 16000;
OutPower = zeros(numel(sorted_idx), 1);

% 逐个读取音频文件
for i = 1:numel(sorted_idx)
    file_name = fullfile(folder_path, audio_files(sorted_idx(i)).name);
    disp(['Reading File：', file_name]);
    OutputSignal = HoshuyamaGSC(file_name, d, Dtheta, K, P, N, ITER1, ITER2, mu1, mu2);
    output_file = fullfile(output_folder, sprintf('sample_%03d.wav', i));
    % audiowrite(output_file, OutputSignal/max(OutputSignal), 8000);
    mag = abs(fft(OutputSignal(end-L:end)))/L;
    OutPower(i) = sum(mag(0.12*L:0.13*L).^2);
end

x = (-90:90);
response = 10*log10(OutPower/max(OutPower));
plot(x, response)
xlabel('DOA(degree)')
ylabel('Normalized Power Response(dB)')

