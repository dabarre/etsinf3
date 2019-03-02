#!/usr/bin/octave -qf
if (nargin!=3)
  printf("Usage: ./experiment.m <data> <alphas> <bes>\n");
  exit(1);
end
arg_list=argv();
data=arg_list{1};
as=str2num(arg_list{2});
bs=str2num(arg_list{3});
load(data); [N,L]=size(data); D=L-1;

#PRINT HEADERS
sample=arg_list{1};
printf("[%s]\n",sample);
printf("#      a        b   E   k Ete  Ete(%%)  Ite   (%%)\n");
printf("#------- -------- --- --- --- ------- ----------\n");

#SET TRAINING AND TESTING SET
ll=unique(data(:,L)); C=numel(ll);
rand("seed",23); data=data(randperm(N),:);
#TRAINING
NTr=round(.7*N); M=N-NTr;
#TESTING
te=data(NTr+1:N,:);

for a=as
  for b=bs
    #ESTIMATE CLASS WITH PERCEPTRON ALGORITHM
    [w,E,k]=perceptron(data(1:NTr,:),b,a); rl=zeros(M,1);
    
    #CALCULATE THE SUPPOSED CLASS OF EACH SAMPLE OF THE TESTING SET
    for m=1:M
      tem=[1 te(m,1:D)]';
      rl(m)=ll(linmach(w,tem));
    end
    #CALCULATE ERROR
    [nerr m]=confus(te(:,L),rl);
    #CALCULATE ESTIMATED ERROR AND CONFIDENCE INTERVAL
    m=(nerr/M);
    s=sqrt(m*(1-m)/M);
    r=1.96*s;
	m1=(m-r)*100;
	m2=(m+r)*100;
	if (m1<0) m1=0; endif
	if (m2<0) m2=0; endif
    #PRINT RESULTS
    printf("%8.1f %8.1f %3d %3d %3d %7.1f [%.1f, %.1f]\n",a,b,E,k,nerr,m*100,m1,m2);
  end
end

# ./experiment.m OCR_14x14 "[0.1 1 10 100 1000 10000]" "[0.1]"
