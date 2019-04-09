#!/usr/bin/octave -qf

if (nargin != 7)
    printf("Usage: ldaexp.m <trdata> <trlabels> <tedata> <telabels> <mink> <stepk> <maxk>\n");
    exit(1);
end

arg_list = argv();
trdata = arg_list{1};
trlabs = arg_list{2};
tedata = arg_list{3};
telabs = arg_list{4};
mink = str2num(arg_list{5});
stepk = str2num(arg_list{6});
maxk = str2num(arg_list{7});

load(trdata);
load(trlabs);
load(tedata);
load(telabs);

k = mink;
kk = 1;
printf("Valor de k:\tValor de err:(PCA)\tValor de err:(LDA)\n");
i=1;
err2 = knn(X, xl, Y, yl, kk);
aux=[];
[m, W] = pca(X);
W2 = lda(X, xl);

while (k <= maxk)    
    XR = W(:,1:k)'*(X-m);
    YR = W(:,1:k)'*(Y-m);
    err(i) = knn(XR, xl, YR, yl, kk);
    
    XR2 = W2(:,1:k)'*(X);
    YR2 = W2(:,1:k)'*(Y);
    err2(i) = knn(XR2, xl, YR2, yl, kk);
    
    aux=[aux; err(i) err2(i)];
    
    printf("%f\t%f\t\t%f\n", k, err(i), err2(i));
    
    i++;
    k += stepk;
end

plot([mink:stepk:maxk], aux);
xlabel("Dimensionalidad espacio reducido");
ylabel("Error (%)");
axis([mink, maxk, 10, 70]);
legend("PCA", "LDA");
refresh();
input("Press key");
print -djpg ldagraph.jpg;

%Command to execute:
%./ldaexp.m trdata.mat.gz trlabels.mat.gz tedata.mat.gz telabels.mat.gz 1 1 9
