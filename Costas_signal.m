% code sequence
% am = [1 2 5 4 6 3];
% am = [1 2 6 4 3 5]; 
am = [1 2 3 4 5 6]; % not Costas
% am = [6 5 4 3 2 1]; % not Costas

% binary matrix dimension
M = length(am);

tb = 1; % 1 sec
% signal duration
T = tb*M;
nPointChip = 16; % accuracy
nPointSignal = M*nPointChip;
step_time = tb/nPointChip;
Fs = 1/step_time;
fm = am/tb;

t = 0:step_time:T - step_time;
sigCostas = zeros(1, nPointSignal);
timeChip  = zeros(1, nPointChip);

for i = 1:M
    timeChip = nPointChip*(i-1)+1 : i*nPointChip;
    sigCostas(timeChip) =  exp(1j*2*pi*fm(i)*t(timeChip));
end

figure('Position',[400 500 1400 900], ...
       'MenuBar','figure')
N = 2048/4;
freq = -N/2:N/2-1;

spec_g = fftshift(fft(sigCostas, N));
spec_norm = spec_g/max(spec_g);
sig = 10*log10(abs(spec_norm));
x_ = tb*freq/N*2;
plot(x_, sig);
xlabel('ft_b/N',    'FontSize',12,'FontWeight','bold','Color','k') 
ylabel('|S(f)|, dB','FontSize',12,'FontWeight','bold','Color','k') 
grid on

[afmag,delay,doppler] = ambgfun(sigCostas, 1/step_time,1/(M));
subplot(1,2,1); 
contour(delay/T,T*doppler,afmag);
grid on
xlabel('\tau','FontSize',12,'FontWeight','bold','Color','k') 
ylabel('\Delta f','FontSize',12,'FontWeight','bold','Color','k') 

subplot(1,2,2); 
mesh(delay,doppler,afmag);
grid on
xlabel('\tau','FontSize',12,'FontWeight','bold','Color','k')  
ylabel('\Delta f','FontSize',12,'FontWeight','bold','Color','k') 
zlabel('\chi(\tau, \Delta f)','FontSize',12,'FontWeight','bold','Color','k')  
[afmag, delay] = ambgfun(sigCostas,1/step_time,1/(M),'Cut','Doppler');

