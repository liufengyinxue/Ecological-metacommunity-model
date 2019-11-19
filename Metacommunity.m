%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Basic settings��
NumOfSpecies = 7 ; %��������
NumOfCommunity = 7 ; %Ⱥ������ 
T = 1e5 ; %�ݻ�ʱ��
DeltaT = 1 ; %�ݻ���ʱ����
PSC = zeros(NumOfSpecies,NumOfCommunity) ; %i������jȺ���е�����,iΪ�У�jΪ�У���ͬ��
CSC = zeros(NumOfSpecies,NumOfCommunity) ; %i������jȺ����������Դ������
ESC = zeros(NumOfSpecies,NumOfCommunity) ; %i������jȺ���н���Դת��Ϊ��������Ч��
MSC = zeros(NumOfSpecies,NumOfCommunity) ; %i������jȺ���е���������
ASC = zeros(NumOfSpecies,NumOfCommunity) ; %i������jȺ���еĴ�������
PC = zeros(NumOfCommunity,1) ; %jȺ���е���Դ��
IC = zeros(NumOfCommunity,1) ; %jȺ������Դ����������
LC = zeros(NumOfCommunity,1) ; %jȺ������Դ��Ȼ��ʧ������
HS = zeros(NumOfSpecies,1) ; %i���ֵ�����
EC = zeros(NumOfCommunity,1) ; %jȺ��Ļ�������
XC = zeros(NumOfCommunity,1) ; %ʹEC�ĳ�ֵ�����ض�ֵ�Ĳ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Special settings:
PSC = PSC + 1 ; %i������jȺ���е������ĳ�ֵ
PC = PC + 1 ; %jȺ���е���Դ���ĳ�ֵ
Period = 40000 ; %��Դ��������
XC = asin(2*(NumOfCommunity-1:-1:0)/(NumOfCommunity-1)-1) ;
HS = (NumOfSpecies-1:-1:0)/(NumOfSpecies-1) ;
HSC = repmat(HS,NumOfCommunity,1) ;
HSC = HSC' ;
% HSC = np.tile(HS,(NumOfCommunity,1)).T ; %��Ⱥ��������HS����ɾ����μ�����������������ľ���,ת�ú��һ��Ϊ��һ�����֡��ڶ���Ϊ�ڶ������֣��Դ����ơ�
ESC = ESC+0.2 ;
MSC = MSC+0.2 ;
IC = IC+150 ;
LC = LC+10 ;
ASC = ASC+0.1 ; %���ִ������ʣ����������������������Ⱥ���д����������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Save data
SampleInterval = 100 ;
NumOfData = T/SampleInterval ;
PData = zeros(NumOfData,1) ; %�洢��̬ϵͳ������Ⱥ�䣩����������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Loop:
cb = 0 ;
path = '' ; %���ݴ洢·��
for k = 1:T
    EC = Environmental_fluctuation(XC,k,Period) ;
    CSC = 1.5 - abs(HSC-EC) ; %�������Դ�����ʾ���
    PCTemp = PC ; %����ǰʱ�̵������������
    PSCTemp = PSC ; %����ǰʱ�̵������������
    for j = 1:NumOfCommunity
        PC(j) = DeltaT*Resource_dynamics(PCTemp(j),IC(j),LC(j),CSC(:,j),PSCTemp(:,j))+PCTemp(j) ; %������һʱ�̵��������
        for i = 1:NumOfSpecies
            PSC(i,j) = DeltaT*Species_dynamics(PSCTemp(i,j),ESC(i,j),CSC(i,j),PCTemp(j),MSC(i,j),ASC(i,j),j,PSCTemp(i,:))+PSCTemp(i,j) ; %������һʱ�̵��������
        end
    end
    Pdy = Productivity(ESC,CSC,PCTemp,PSCTemp)/NumOfCommunity ;
    if rem(k,SampleInterval)==0: %��SampleInterval�ļ������
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