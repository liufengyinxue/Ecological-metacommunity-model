function post = Species_dynamics(pre,p1,p2,p3,p4,p5,Index,v1)
v1(Index) = [] ;
post = (p1*p2*p3 - p4)*pre + p5/length(v1)*sum(v1) - p5*pre ;
end

