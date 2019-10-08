#!/usr/bin/octave -qf

if (nargin != 1)
	print("Usage: multinomial.m <data_filename>");
	exit(1);
endif

% Cargar datos
arglist = argv();
datafile=arglist{1};
load(datafile);
%[nrows,ncols] = size(data);

%tr = trainData;
%te = testData;

%rand("seed",23);

%perm=randperm(nrows);
%pdata=data(perm,:);

% Dividir muestras 0.9 training y 0.1 test
%trper=0.9;
%ntr=floor(nrows*trper);
%nte=nrows-ntr;
%tr=pdata(1:ntr,:);
%te=pdata(ntr+1:nrows,:);

% Se calcula las probabilidades a priori de las clases ham y spam
ispam = find(tr(:, end) == 1);
ns = rows(ispam);
ntr = rows(tr);
pspam =  ns/ntr;
pham = 1-pspam;

trspam = tr(ispam, 1:(end-1));

iham = find(tr(:, end) == 0);
trham = tr(iham, 1:(end-1));

% Se calcula las probabilidades condicionales de las clases ham y spam
pcspam = sum(trspam)/sum(sum(trspam));
pcham = sum(trham)/sum(sum(trham));
  
% Imprimir resultados
printf("Epsilon:\tError (%%):\n");
min = 100;
% Realizar suavizado con distintos epsilon
for i = 1:100
  epsilon = 10^-i;

  % Inicializar variables de los clasificadores con suavizado "Laplace"
  wh = (pcham + epsilon)/sum(pcham + epsilon);
  wh = log(wh);
  
  ws = (pcspam + epsilon)/sum(pcspam + epsilon);
  ws = log(ws);

  % Inicializar variables de los clasificadores
  wh0 = log(pham);
  ws0 = log(pspam);
    
  % Etiquetas de test
  telabels = te(:,end);    
  
  % Clasificar las muestras
  gh = wh*te(:,1:end-1)' + wh0;
  gs = ws*te(:,1:end-1)' + ws0;

  % Calcular porcentaje de aciertos y el error
  t = gh < gs;
  correct = telabels == t';
  correct = sum(correct==1)/numel(telabels);    
  error = (1-correct)*100;
  if (error < min)
    min = error;
  endif
  % Imprimir resultados
  printf("%e\t%f\n", epsilon, error);   
endfor
printf("%f\n", min); 