function res = MYavrg(dd,nn,NN)

res = dd(1:end-nn+1);

for i=2:nn
    res = res + dd(i:end-nn+i);
end

res = res/nn;
res = res(NN-nn+1:end);

end