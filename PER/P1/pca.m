function[m,W] = pca(X)
    % Obtener la media de la matriz de muestras
    n = columns(X);
    Xmedia = sum(X')/n;
    Xmedia = Xmedia';

    % Obtener una matriz igual a la matriz de muestras menos 
    % su media, para calcular la matriz de covarianza 
    A = X-Xmedia;
    matCov = (A*A')/n;

    % Obtener eigenvectors y eigenvalues de la matriz de covarianza
    [eigenVector, eigValue] = eig(matCov);

    % Ordenar las eigenvalues obtenidas    
    [sortEigvalue, indices] = sort(-diag(eigValue));

    % W es la matriz de proyecciones y m la media de las muestras
    W = eigenVector(:,indices);
    m = Xmedia;
endfunction