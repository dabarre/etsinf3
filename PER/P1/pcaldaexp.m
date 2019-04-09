#!/usr/bin/octave -qf

% cambiar 7 por 4 para hacer comprobaciones
if (nargin != 4)
    printf("Usage: pcaexp.m <trdata> <trlabels> <tedata> <telabels> <mink> <stepk> <maxk>\n");
    exit(1);
end

arg_list = argv();
trdata = arg_list{1};
trlabs = arg_list{2};
tedata = arg_list{3};
telabs = arg_list{4};
%mink = str2num(arg_list{5});
%stepk = str2num(arg_list{6});
%maxk = str2num(arg_list{7});

load(trdata);
load(trlabs);
load(tedata);
load(telabs);


kk = 1;
printf("Valor de k(PCA):\tValor de k(LDA):\tValor de err:\n");

mink1 = 1;
stepk1 = 10;
maxk1 = 100;

mink2 = 1;
stepk2 = 1;
maxk2 = 9; % number of classes

k1 = mink1;

[m, W] = pca(X);

i=1;
while (k1 <= maxk1)    
    W = W(:,1:k1);
    
    % ERROR ¿?
    W = lda(W, xl);
    %
    
    k2 = mink2;
    while (k2 <= maxk2)
        XR = W(:,1:k2)'*(X);
        YR = W(:,1:k2)'*(Y);
        err(i) = knn(XR, xl, YR, yl, kk);
        i++;
        
        printf("%f\t\t%f\t\t%f\n", k1, k2, err(i));
        k2 += stepk2;
    end        
    
    k1 += stepk1;
end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% Command to execute:
%./pcaexp.m trdata.mat.gz trlabels.mat.gz tedata.mat.gz telabels.mat.gz 10 10 100