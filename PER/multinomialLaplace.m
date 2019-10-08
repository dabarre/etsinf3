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
for i = 1:NE
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

  % Datos de training sin las etiquetas
  trspam = tr(ispam, 1:(end-1));
  iham = find(tr(:, end) == 0);
  trham = tr(iham, 1:(end-1));

  % Se calcula las probabilidades condicionales de las clases ham y spam
  pcspam = sum(trspam)/sum(sum(trspam));
  pcham = sum(trham)/sum(sum(trham));
  
  % Acumular valor de epsilon y de error
  aux1 = [];
  aux2 = [];
  
  % Realizar suavizado con distintos epsilon
  for j = 1:20
    epsilon = 10^-j;

    % Inicializar variables de los clasificadores con suavizado "Laplace"
    wh = (pcham + epsilon)/sum(pcham + epsilon);
    wh = log(wh);
    
    ws = (pcspam + epsilon)/sum(pcspam + epsilon);
    ws = log(ws);

    % Inicializar variables de los clasificadores
    wh0 = log(pham);
    ws0 = log(pspam);      
    
    % Clasificar las muestras
    gh = wh*te(:,1:end-1)' + wh0;
    gs = ws*te(:,1:end-1)' + ws0;
    
    % Etiquetas de test
    telabels = te(:,end);  

    % Calcular porcentaje de aciertos y el error
    t = gh < gs;
    correct = telabels == t';
    correct = sum(correct==1)/numel(telabels);    
    error = (1-correct)*100;

    % Guardar los valores de epsilon y error
    aux1 = [aux1; epsilon];
    aux2 = [aux2; error];    
  endfor
  A = [A; aux2'];
endfor

% Calcular el error promedio
avg = sum(A) / NE;
%Calcular la desviación típica
dev = sqrt(sum((A - avg).^2) / NE);

% Imprimir resultados
printf("Epsilon:\tError (%%):\tStandard Deviation:\n");
for i = 1:length(aux1)  
  printf("%e\t%.2f\t\t%.2f\n", aux1(i), avg(i), dev(i));
endfor

% ./multinomialLaplace.m trec06p.dat.gz

% Grafica GNUPLOT
%gnuplot
%set logscalexy
%set yrange[0.2:25]
%set xrange[1e-21:1]
%plot 'results.txt' u 1:2 not w lp, 'results.txt' u 1:2:(2*$3) not w e
