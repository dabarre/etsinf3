#!/usr/bin/octave -qf

if (nargin != 1)
	print("Usage: multinomial.m <data_filename>");
	exit(1);
endif

% Cargar datos
arglist = argv();
datafile=arglist{1};
load(datafile);
[nrows,ncols] = size(data);
rand("seed",23);

% Número de iteraciones
NE = 30;
% Matriz de error de cada epsilon en los NE barajados
A=[];

% Se calcula el error para NE barajados
for i=1:NE
  perm=randperm(nrows);
  pdata=data(perm,:);

  % Dividir muestras 0.9 training y 0.1 test
  trper=0.9;
  ntr=floor(nrows*trper);
  nte=nrows-ntr;
  tr=pdata(1:ntr,:);
  te=pdata(ntr+1:nrows,:);

  % Se calcula las probabilidades a priori de las clases ham y spam
  ispam = find(tr(:, end) == 1);
  ns = rows(ispam);
  pspam =  ns/ntr;
  pham = 1-pspam;

  trspam = tr(ispam, 1:(end-1));

  iham = find(tr(:, end) == 0);
  trham = tr(iham, 1:(end-1));

  % Se calcula las probabilidades condicionales de las clases ham y spam
  pcspam = sum(trspam)/sum(sum(trspam));
  pcham = sum(trham)/sum(sum(trham));

  % Inicializar variables de los clasificadores
  wh0 = log(pham);
  ws0 = log(pspam);

  % Suavizado & Error
  telabels = te(:,end);
  aux1 = [];
  aux2 = [];
  
  % Inicializar variables de los clasificadores
  wh = log(pcham);
  ws = log(pcspam);

  % Clasificar las muestras
  gh = wh*te(:,1:end-1)' + wh0;
  gs = ws*te(:,1:end-1)' + ws0;
  
  % Calcular porcentaje de aciertos y el error
  t = gh < gs;
  correct = telabels == t';
  correct = sum(correct==1)/numel(telabels);    
  error = (1-correct)*100;
  
  % Guardar los valores de error
  aux2 = [aux2; error];
  
  % Guardar valores de error en un barajado
  A = [A; aux2'];
endfor

% Calcular el error promedio
avg = sum(A) / NE;
%Calcular la desviación típica
dev = sqrt(sum((A - avg).^2) / NE);

% Imprimir resultados
printf("Error (%%):\tStandard Deviation:\n");
for i = 1:length(aux2)  
  printf("%.2f\t%.2f\n", avg(i), dev(i));
endfor

% ./multinomial.m trec06p.dat.gz

% Grafica GNUPLOT
%gnuplot
%set logscalexy
%set yrange[0.2:25]
%set xrange[1e-21:1]
%plot 'results.txt' u 1:2 not w lp, 'results.txt' u 1:2:(2*$3) not w e