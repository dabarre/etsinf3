function [W] = lda(X,xl)
	% Obtener la media de la matriz de muestras
    n = size(X,2);
    Xmedia = sum(X,2)/n;
    
	Sb = Sw = 0;
	
	% Para cada clase se identifican sus muestras y se
	% calcula la media de cada clase
	for c = unique(xl)
		i = find(xl == c);
		Xc = X(:,i);
		Xcmedia = sum(Xc,2)/columns(Xc);
		% Sb es la suma de la multiplicación entre el número
		% de muestras de una clase, el vector igual a la media
		% de la clase menos la media global y la matriz traspuesta
		% de este vector
		Sb = Sb + columns(Xc)*(Xcmedia-Xmedia)*(Xcmedia-Xmedia)';

		% Sw es la suma de covarianzas de las clases. Así que
		% se obtiene una matriz igual a la matriz de muestras 
		% de una clase menos su media asociada para calcular la 
		% matriz de covarianza
		A = Xc-Xcmedia;
		matCov = (A*A')/columns(Xc); 
		Sw = Sw + matCov;
    end

	% Obtener eigenvectors y eigenvalues comunese entre Sb y Sw
    [eigenVector, eigValue] = eig(Sb,Sw);

	% Ordenar las eigenvalues obtenidas
    [sortEigvalue, indices] = sort(-diag(eigValue));

	%Es la matriz de los k primeros vectores propios
    W = eigenVector(:,indices);    
endfunction