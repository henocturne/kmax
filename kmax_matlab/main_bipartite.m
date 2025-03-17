clear;clc;
load dataset.mat;  % 先把邻接矩阵导入并且保存到mat文件中，最好把不同领域的分开保存，每个领域选

id = 1; %i从1到50
bipartite = ecology_bipartite{id};
data_name = ['ecology bipartite No.',num2str(id)];

A = bipartite_to_mat(bipartite);

while 1
    degree_in = sum(A'); degree_out = sum(A);
    ids = degree_in==0|degree_out==0;
    if sum(ids)==0
        break;
    end
    A(ids,:) = []; A(:,ids) = [];
end

undirected = isequal(A, A'); %如果是0，代表是有向网络

degree_in = sum(A,2);
degree_out = sum(A,1);

kmax_original = kcore(A);
rho_original = abs(eigs(A,1));
%%   
N = 100;
norm = 1/sum(degree_in);
p_mat = degree_in*degree_out*norm;
core_list = zeros(N,1);
rho_list = zeros(N,1);
for i = 1:N
    i
    B = double(rand(size(A))<=p_mat);
    if undirected  %如果是无向网络，则做对称化处理，从而保证随机网络也是无向网络
        B = triu(B,0)+triu(B,1)';
    end
    degree_B = sum(B,2);
    core_list(i,1) = kcore(B);      %记录每一次的kmax
    rho_list(i,1) = abs(eigs(B,1)); %记录每一次的最大特征值
end
kmax_rand_avg = mean(core_list); kmax_rand_std = std(core_list);
rho_rand_avg = mean(rho_list); rho_rand_std = std(rho_list);

kmax_sigma = abs((kmax_original-kmax_rand_avg)/kmax_rand_std);
rho_sigma = abs((rho_original-rho_rand_avg)/rho_rand_std);
%% 对于每个数据集，把这里打印出来的语句全部保存下来

disp('请保存以下文字：')
disp(['Dataset: ',data_name,'. Nodes: ',num2str(length(A)),'. Avg_degree_in: ',num2str(mean(degree_in))]);
disp(['现实网络的kmax为',num2str(kmax_original),',随机网络的的kmax为',num2str(kmax_rand_avg),',标准差为', num2str(kmax_rand_std)]);
disp(['现实网络的rho为',num2str(rho_original),',随机网络的的rho为',num2str(rho_rand_avg),',标准差为', num2str(rho_rand_std)]);

if kmax_original<kmax_rand_avg
    disp(['现实网络比随机网络更脆弱，kmax差距为',num2str(kmax_sigma),'个标准差(两个标准差以内代表差距不显著)']);
elseif kmax_original==kmax_rand_avg
    disp(['现实网络和随机网络的kmax一样'])
else
    disp(['现实网络比随机网络更稳定，kmax差距为',num2str(kmax_sigma),'个标准差(两个标准差以内代表差距不显著)']);
end
if rho_original<rho_rand_avg
    disp(['现实网络比随机网络更脆弱，rho差距为',num2str(rho_sigma),'个标准差(两个标准差以内代表差距不显著)']);
else
    disp(['现实网络比随机网络更稳定，rho差距为',num2str(rho_sigma),'个标准差(两个标准差以内代表差距不显著)']);
end