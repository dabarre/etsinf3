#!/usr/bin/octave -qf

if (nargin != 7)
    printf("Usage: pcaexp.m <trdata> <trlabels> <tedata> <telabels> <mink> <stepk> <maxk>\n");
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
printf("Valor de k:\t\tValor de err: \n");
i=1;
err2 = knn(X, xl, Y, yl, kk);
aux=[];
[m, W] = pca(X);

while (k <= maxk)    
    XR = W(:,1:k)'*(X-m);
    YR = W(:,1:k)'*(Y-m);
    err(i) = knn(XR, xl, YR, yl, kk);
    
    aux=[aux; err(i) err2];
    
    printf("%f\t\t%f\n", k, err(i));
    
    i++;
    k += stepk;
end

plot([mink:stepk:maxk], aux);
xlabel("Dimensionalidad espacio PCA");
ylabel("Error (%)");
axis([mink, maxk, 4, 11]);
legend("PCA", "Original");
refresh();
input("Press key");
print -djpg pcagraph.jpg;

%Command to execute:
%./pcaexp.m trdata.mat.gz trlabels.mat.gz tedata.mat.gz telabels.mat.gz 10 10 100