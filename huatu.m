% original = audio(end-16000:end,1);
% L = length(original);
% mag_original = PlotFFT(original);
% mag_o = PlotFFT(OutputSignal(end-16000:end));
% f = fs*(0:(L/2))/L;
% xlabel('f (Hz)')
% ylabel('magnitude')
% title('Power Spectrum of the Original and Blocked')
% plot(f, mag_original); hold on; 
% plot(f, mag_o); hold off;
% legend('original', 'output')
% sum(mag_o(0.095*L:0.105*L).^2) / sum(mag_o(0.12*L:0.13*L).^2)



function mag = PlotFFT(signal)
    L = length(signal);
    mag = abs(fft(signal))/L;
    mag = mag(1:L/2+1);
    mag(2:end-1) = 2*mag(2:end-1);
end