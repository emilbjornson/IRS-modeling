function x = quant(x,B)

%Assumes a full-scale signal x in the interval [-1,1]
Q=2^-(B-1);
x=x*(1-1e-12);
x=x-Q/2;
x=round(x*pow2(B-1))/pow2(B-1);
x=x+Q/2;
end

