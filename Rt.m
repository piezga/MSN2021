function Rt = Rt(totale_positivi,gamma)

dlnI=diff(log(totale_positivi));
Rt=(dlnI + gamma)/gamma;

end