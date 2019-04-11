#!/usr/bin/octave -qf

if (nargin != 10)
    printf("Usage: pcaexp.m <trdata> <trlabels> <tedata> <telabels> <mink1> <stepk1> <maxk1> <mink2> <stepk2> <maxk2>\n");
    exit(1);
end

arg_list = argv();
trdata = arg_list{1};
trlabs = arg_list{2};
tedata = arg_list{3};
telabs = arg_list{4};

% Interval of values to perform PCA
mink1 = str2num(arg_list{5});
stepk1 = str2num(arg_list{6});
maxk1 = str2num(arg_list{7});

% Interval of values to perform LDA
mink2 = str2num(arg_list{8});
stepk2 = str2num(arg_list{9});
maxk2 = str2num(arg_list{10});

load(trdata);
load(trlabs);
load(tedata);
load(telabs);

kk = 1;
i = 1;
aux = [];

% Calcutate # of dimensions
nd = rows(X);

% Calculate # of classes
c = unique(xl);
nc = columns(c);

printf("Valor de k(PCA):\tValor de k(LDA):\tValor de err:\n");

[m, W] = pca(X);

for k1=mink1:stepk1:maxk1
    
    if (k1 > nd)
        printf("%f\t\t---\t\t---\n", k1);
        break;
    end
  
    XR = W(:,1:k1)'*(X-m);
    YR = W(:,1:k1)'*(Y-m);

    V = lda(XR, xl);

    for k2=mink2:stepk2:maxk2
      
        % Impossible iterations
        if (k2 > nc || k2 > k1)
          
            printf("%f\t\t%f\t\t---\n", k1, k2);
            break;
        end
        
        XR2 = V(:,1:k2)'*XR;
        YR2 = V(:,1:k2)'*YR;
        err(i) = knn(XR2, xl, YR2, yl, kk);

        aux=[aux; err(i)];
        
        printf("%f\t\t%f\t\t%f\n", k1, k2, err(i));
        
        i++;
    end
    
    printf("\n");
end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% Command to execute:
%./pcaldaexp.m trdata.mat.gz trlabels.mat.gz tedata.mat.gz telabels.mat.gz 1 10 100 1 1 9

%./pcaldaexp.m extra_data/trdata.mat.gz extra_data/trlabels.mat.gz extra_data/tedata.mat.gz extra_data/telabels.mat.gz 1 10 100 1 1 9

%./pcaldaexp.m extra_data/trdata.mat.gz extra_data/trlabels.mat.gz extra_data/tedata.mat.gz extra_data/telabels.mat.gz 1 10 200 1 10 100

%./pcaldaexp.m extra_data/trdata.mat.gz extra_data/trlabels.mat.gz extra_data/tedata.mat.gz extra_data/telabels.mat.gz 1 5 500 1 5 100
