function post = Resource_dynamics(pre,p1,p2,v1,v2)
post = p1 - p2*pre - pre*sum(v1.*v2) ;
end

