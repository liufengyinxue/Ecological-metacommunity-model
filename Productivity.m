function P = Productivity(mat1,mat2,v1,mat3)
M,N = size(mat1) ;
SCtemp = zeros(M,1) ;
for i = 1:M
    CPtemp = zeros(N,1) ;
    for j = 1:N
        CPtemp(j) = mat1(i,j)*mat2(i,j)*v1(j)*mat3(i,j) ;
    end
    SCtemp(i) = sum(CPtemp) ; %每个物种的生产力
end
P = sum(SCtemp) ; %所有群落的总生产力
end

