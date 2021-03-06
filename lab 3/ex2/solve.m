clear all; close all; 
Enorm = [];
L2norm = [];
maxNorm = [];
NVAL = [2 4 16 256];
xe = linspace(0,1,1000);
for N = NVAL
	h = 1/N;
	x = (0:h:1);
	f = @(x) 2;
	%Solving the fem
	A = stiffAssembly(x);
	b = loadAssembly(x,f);

	f2 = @(x) (x.*(1-x))';
	M = L2Mass1D(x);
	b2 =  LoadAssemblerS1D(x,f2);

	psiPu = M\b2;


	psi = A\b;
	plot(x,psi) %We do not plot with hat basis since it's basically one for every psi value. 
	hold on
	%plot(x,psiPu)
	
	Enorm = [ Enorm; sqrt( 1/3 - psi'*A*psi)];
	L2norm = [L2norm; sqrt((psiPu-psi)'*M*(psiPu-psi))];
	uh = interp1(x, psi, xe)'
	maxNorm = [ maxNorm; max(abs(f2(xe)-uh))]; 
end

plot(xe, f2(xe))
legend('h = 1/2', 'h = 1/4', 'h = 1/16', 'h = 1/256', 'Analytical Solution')
title('Solving a System using FEM')

figure(2)
h = 1./NVAL;
loglog(h,Enorm)
hold on
loglog(h,L2norm)
loglog(h,maxNorm)

legend('Energy Norm', 'L^2 norm', 'Max Norm')

e1 = Enorm(1); h1 = 1/2;
e2 = Enorm(2); h2 = 1/4;

log(e2)-log(e1)/(log(h2)-log(h1))
