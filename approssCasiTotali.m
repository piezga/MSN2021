function I = approssCasiTotali(nuoviCasi,gamma)
I=zeros(length(nuoviCasi),1);
I(1)=nuoviCasi(1);

for i=2:length(nuoviCasi)
    I(i) = I(i-1) + nuoviCasi(i) - gamma*I(i-1);
end

end