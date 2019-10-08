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
  
  % Acumular valor de epsilon y de error
  aux1 = [];
  aux2 = [];
  
  % Realizar suavizado con distintos epsilon
  e = [0.3, 0.25, 0.2, 0.15, 0.1, 0.05, 0.03, 0.02,0.01, 0.005, 0.001];
  for epsilon = e
  %for j = 1:20
    %epsilon = 10^-j;

    % Inicializar variables de los clasificadore,
    % con suavizadio "Descuento Absoluto - Backing off"

    % Restar epsilon a los valores distintos de cero,
    % distribuir la cantidad total restada entre los
    % valores iguales a cero
    
    wh = pcham;
    n = find(wh == 0);
    if (n != 0)
      m = find(wh != 0);      
      wh(m) -= epsilon;
      wh += (epsilon*length(m))/length(wh);
    end
    wh = log(wh);
    
    ws = pcspam;
    n = find(ws == 0);
    if (n != 0)
      m = find(ws != 0);    
      ws(m) -= epsilon;
      ws += (epsilon*length(m))/length(ws);
    end
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

% ./multinomialDAI.m trec06p.dat.gz