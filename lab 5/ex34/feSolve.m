clear all; close all;

u0 = @(x,y) 0.1*exp(-10*sqrt((x-0.2).^2 + (y-0.8).^2))';
f = @(x,y) 0;
dt = 0.05;
[p,e,t] = initmesh('lshapeg','hmax',0.05);
pdemesh(p,e,t);
%return;
np = size(p,2);
T = 3;
timevec = 0:dt:T;

%Initial Conditions
xin = u0(p(1,:), p(2,:));
etan = zeros(size(xin));
[A,M] = systemMatrixAssembler(p,e,t);
%Forward Euler
FEerr = [];
val = [];
zer = zeros(np,np);
poi = 6;
for time = timevec
	LHS = [M zer; zer M];
	%Note that the load vector is always zero from f = 0
	%Thus we skip it
	cnM = [M dt*M; -dt*A M];
	rhs = cnM*[xin; etan];
	
	%LHS = [M -0.5*dt*M; 0.5*dt*A M]; % Crank-Nicholson
	%rhs = [M 0.5*dt*M; -0.5*dt*A M]*[xin; etan];

	np1 = LHS\rhs;
	xin = np1(1:np);
	etan = np1(np+1:end);
	%pdesurf(p,t,xin)
	%axis([-1 1 -1 1 -0.1 0.2])
	%title(sprintf('time = %.2f', time))
	%drawnow;
	
	val = [ val xin(poi)];
	FEerr = [FEerr xin'*M*xin+xin'*A*xin];
end
figure(2)
plot(timevec, FEerr)
title('Energy Error Over Time, Forward Euler')
xlabel('Time')
ylabel('Energy Error')

figure(3)
plot(timevec, val)
title('Value at node (1,-1), Forward Euler')
