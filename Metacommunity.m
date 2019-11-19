%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Basic settings：
NumOfSpecies = 7 ; %物种数量
NumOfCommunity = 7 ; %群落数量 
T = 1e5 ; %演化时间
DeltaT = 1 ; %演化的时间间隔
PSC = zeros(NumOfSpecies,NumOfCommunity) ; %i物种在j群落中的数量,i为行，j为列（下同）
CSC = zeros(NumOfSpecies,NumOfCommunity) ; %i物种在j群落中消耗资源的速率
ESC = zeros(NumOfSpecies,NumOfCommunity) ; %i物种在j群落中将资源转换为生物量的效率
MSC = zeros(NumOfSpecies,NumOfCommunity) ; %i物种在j群落中的死亡速率
ASC = zeros(NumOfSpecies,NumOfCommunity) ; %i物种在j群落中的传播速率
PC = zeros(NumOfCommunity,1) ; %j群落中的资源量
IC = zeros(NumOfCommunity,1) ; %j群落中资源再生的速率
LC = zeros(NumOfCommunity,1) ; %j群落中资源自然流失的速率
HS = zeros(NumOfSpecies,1) ; %i物种的特性
EC = zeros(NumOfCommunity,1) ; %j群落的环境波动
XC = zeros(NumOfCommunity,1) ; %使EC的初值满足特定值的参数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Special settings:
PSC = PSC + 1 ; %i物种在j群落中的数量的初值
PC = PC + 1 ; %j群落中的资源量的初值
Period = 40000 ; %资源波动周期
XC = asin(2*(NumOfCommunity-1:-1:0)/(NumOfCommunity-1)-1) ;
HS = (NumOfSpecies-1:-1:0)/(NumOfSpecies-1) ;
HSC = repmat(HS,NumOfCommunity,1) ;
HSC = HSC' ;
% HSC = np.tile(HS,(NumOfCommunity,1)).T ; %按群落数量将HS扩充成矩阵，牢记这是行向量扩充出的矩阵,转置后第一行为第一个物种。第二行为第二个物种，以此类推。
ESC = ESC+0.2 ;
MSC = MSC+0.2 ;
IC = IC+150 ;
LC = LC+10 ;
ASC = ASC+0.1 ; %物种传播速率，这里假设所有物种在所有群落中传播速率相等
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Save data
SampleInterval = 100 ;
NumOfData = T/SampleInterval ;
PData = zeros(NumOfData,1) ; %存储生态系统（所有群落）的总生产力
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Loop:
cb = 0 ;
path = '' ; %数据存储路径
for k = 1:T
    EC = Environmental_fluctuation(XC,k,Period) ;
    CSC = 1.5 - abs(HSC-EC) ; %计算出资源消耗率矩阵
    PCTemp = PC ; %将当前时刻的运算矩阵留存
    PSCTemp = PSC ; %将当前时刻的运算矩阵留存
    for j = 1:NumOfCommunity
        PC(j) = DeltaT*Resource_dynamics(PCTemp(j),IC(j),LC(j),CSC(:,j),PSCTemp(:,j))+PCTemp(j) ; %计算下一时刻的运算矩阵
        for i = 1:NumOfSpecies
            PSC(i,j) = DeltaT*Species_dynamics(PSCTemp(i,j),ESC(i,j),CSC(i,j),PCTemp(j),MSC(i,j),ASC(i,j),j,PSCTemp(i,:))+PSCTemp(i,j) ; %计算下一时刻的运算矩阵
        end
    end
    Pdy = Productivity(ESC,CSC,PCTemp,PSCTemp)/NumOfCommunity ;
    if rem(k,SampleInterval)==0: %按SampleInterval的间隔采样
        cb = cb + 1 ;
        filenamePC = ['PC_' num2str(cb) '.mat'] ;
        filenamePSC = ['PSC_' num2str(cb) '.mat'] ;
        save(path+filenamePC,'PC') ;
        save(path+filenamePSC,'PSC') ;
        PData(cb) = Pdy ;
    end
end
filenameP = 'Productivity.mat' ;
save(path+filenameP,'PData') ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%