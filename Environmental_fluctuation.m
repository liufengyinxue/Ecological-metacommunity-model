function EF = Environmental_fluctuation(v1,t,cycle)
EF = 0.5*(sin(v1 + 2*pi*t/cycle) + 1) ;
end

