function A = bipartite_to_mat(bipartite)
% 把二部图转为邻接矩阵，用于ecology_bipartite数据集
[m,n] = size(bipartite);
A = [zeros(m,m),bipartite;bipartite',zeros(n,n)];