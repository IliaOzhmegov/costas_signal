% binary matrix dimension
M = 7;
m = 1:M;

% code sequence
am = [4 7 1 6 5 2 3];

tb = 1;
% signal duration
T = tb*M;
nPointChip = 512;
nPointSignal = M*nPointChip;
step_time = tb/nPointChip;
Fs = 1/step_time;
fm = am/tb;

t = 0:step_time:T - step_time;
sigCostas = zeros(1, nPointSignal);
timeChip = zeros(1, nPointChip);

for c_ = 1:M
    timeChip = nPointChip*(c_-1)+1 : c_*nPointChip;
    sigCostas(timeChip) =  exp(1j*2*pi*fm(c_)*t(timeChip));
end

figure(1);
sig_abs = abs(sigCostas);
sig_norm = sig_abs/max(sig_abs);
sig = 20*log10(sig_norm);
plot(sig);
grid on
xlabel('t/t_b'); ylabel('|g(t)|, dB');

figure(2);
phase_g = angle(sigCostas);
plot(t/tb, phase_g);
grid on
xlabel('t/t_b'); ylabel('Phase, rad');

figure(3);
N = 2048/4;
freq = -N/2:N/2-1;
spec_g = fftshift(fft(sigCostas, N));
spec_norm = spec_g/max(spec_g);
sig = 10*log10(abs(spec_norm));
x_ = tb*freq/N*2;
plot(x_, sig);
xlabel('ft_b/N');
ylabel('|S(f)|, dB'); 
grid on

[afmag,delay,doppler] = ambgfun(sigCostas, 1/step_time,1/(M));
subplot(1,2,1); contour(delay/T,T*doppler,afmag);
grid on
xlabel('\tau/T'); 
ylabel('vT');

subplot(1,2,2); mesh(delay,doppler,afmag);
grid on
xlabel('\tau/T'); ylabel('vT');
[afmag, delay] = ambgfun(sigCostas,1/step_time,1/(M),'Cut','Doppler');

% figure(7);
% plot(delay/tb, 20*log10(afmag));
% grid on
% xlabel('t/t_b'); ylabel('|\chi(\tau, 0)|, dB');
% [afmag, doppler] = ambgfun(sigCostas,1/step_time,1/(M),'Cut','Delay');
% 
% figure(8);
% plot(doppler*tb, 20*log10(afmag));
% grid on
% xlabel('vt_b'); ylabel('|\chi(0, v)|');

