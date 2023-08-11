clear all; close; clc

% Original network
Node = [1,2,3,4];
Edge = [1,2,3,4];
N_V = length(Node);
N_E = length(Node);

C_V = [10;9;12;10];
C_E = [5;8;7;4];

E = zeros(N_V,N_E); % incidence matrix
E([1,2],1) = [-1;1];
E([1,3],2) = [-1;1];
E([2,4],3) = [-1;1];
E([3,4],4) = [-1;1];


N_J = 3;
Delta_1 = zeros(N_V,N_J);   % >0
Delta_2 = zeros(N_V,N_J);   % <0
Delta_1(2,1)=1; Delta_1(4,2)=1; Delta_1(4,3)=1;     % d_ell
Delta_2(1,1)=-1; Delta_2(1,2)=-1; Delta_2(3,3)=-1;  % o_ell

M = 200;    % a constant (can be changed)

% solution = TP_compute(E,Delta_1,Delta_2,C_V,C_E,M);

% Backup network
Node_b = [5,6,7,8,9];
Edge_b = 5:28;
N_Vb = length(Node_b);
N_Eb = length(Edge_b);
N_Vt = N_Vb + N_V;
N_Et = N_Eb + N_E;

E_t = zeros(N_Vt,N_Et);

E_t(1:N_V,1:N_E) = E;
% E_t([1,5],5) = [-1;1];     E_t([1,5],6) = [1;-1];
% E_t([6,2],7) = [-1;1];     E_t([6,2],8) = [1;-1];
% E_t([6,2],9) = [-1;1];     E_t([6,2],10) = [1;-1];
% E_t([1,6],11) = [-1;1];     E_t([1,6],12) = [1;-1];
% 
% E_t([1,6],13) = [-1;1];     E_t([1,6],14) = [1;-1];
% E_t([6,2],15) = [-1;1];     E_t([6,2],16) = [1;-1];
% 
% E_t([6,2],15) = [-1;1];     E_t([6,2],16) = [1;-1];
% E_t([6,2],15) = [-1;1];     E_t([6,2],16) = [1;-1];
% E_t([6,2],15) = [-1;1];     E_t([6,2],16) = [1;-1];
e_list = [1,5;2,5;3,5;4,5;...
    1,6;6,2;1,7;7,3;...
    2,8;8,4;4,9;9,3];
for k = 1:N_Eb/2
    e_ind = N_E+2*k-1;
    E_t(e_list(k,:),e_ind) = [-1;1];
    E_t(e_list(k,:),e_ind+1) = [1;-1];      % a pair of edges
end

E_t_b = E_t(:,N_E+1:end);   



Delta_adj = zeros(N_V,N_Vb);
for kv = 1:N_V
    for kj = 1:N_Eb
        if E_t_b(kv,kj) <0 
            ind = find(E_t_b(:,kj) >0);
            ind = ind(ind~=kv)-N_V;
            Delta_adj(kv,ind)=1;
        end
    end
end


KZ = 4;
C_b_all = zeros(N_Vb,KZ);
F = zeros(N_Vb,KZ);

temp_c = [0,3,6,9];
temp_f = temp_c*2+4;
temp_f(1) = temp_f(1)-10;

for k =1:N_Vb
    C_b_all(k,:) = temp_c;
    F(k,:) = temp_f;
end

% E(ev) E(v)= E_v E(e)= E_e
E_v = cell(N_V,1);
E_e = cell(N_E,1);
% E_e
for k_e1 = 1:N_E    % disturbed e
    E_temp = zeros(N_Vt,N_Et);
    E_temp(1:N_V,1:N_E) = E;
    ori_ind = find(E(:,k_e1)==-1);  %origin ind
    dest_ind = find(E(:,k_e1)==1);  %dest ind
    for k_e2 = N_E+1:N_Et 
        if E_t(ori_ind,k_e2)==-1
            dest_ind2 = find(E_t(:,k_e2)==1);
            comp_vec = zeros(N_Vt,1);   % must have a returning link
            comp_vec(dest_ind2)=-1;
            comp_vec(dest_ind)=1;
            if ismember(comp_vec',E_t','rows')
                E_temp(:,k_e2)=E_t(:,k_e2);
            end
        elseif E_t(dest_ind,k_e2)==1
            ori_ind2 = find(E_t(:,k_e2)==-1);
            comp_vec = zeros(N_Vt,1);   % must have a going out link
            comp_vec(ori_ind)=-1;
            comp_vec(ori_ind2)=1;
            if ismember(comp_vec',E_t','rows')
                E_temp(:,k_e2)=E_t(:,k_e2);
            end
        end
    end
    E_e{k_e1} = E_temp;
end

% E_v
for k_v = 1:N_V
    E_v{k_v} = E;   % incidence matrix the same
end

Delta_1e = [Delta_1;zeros(N_Vb,N_J)];
Delta_2e = [Delta_2;zeros(N_Vb,N_J)];


% set unceratin capacity
c_V_list = zeros(N_V,4);
c_E_list = zeros(N_E,4);

prob_V_list = zeros(N_V,4);
prob_E_list = zeros(N_E,4);

cap_ind_V = zeros(N_V,2);
cap_ind_E = zeros(N_E,2);
count= 0;

for i = 1:size(c_V_list,1)
    cap_ind_V(i,1) = count+1;
    for i2 = 1:size(c_V_list,2)
        c_V_list(i,i2) = 1/4*(i2-1)*C_V(i);
        count = count+1;
    end
    cap_ind_V(i,2) = count;
    prob_V_list(i,:)= [0.05,0.1,0.15,0.7];
end
count= 0;

for i = 1:size(c_E_list,1)
    cap_ind_E(i,1) = count+1;
    for i2 = 1:size(c_E_list,2)
        c_E_list(i,i2) = 1/4*(i2-1)*C_E(i);  
        count = count+1;
    end
    cap_ind_E(i,2) = count;
    prob_E_list(i,:)= [0.05,0.1,0.15,0.7];
end

cap_info.c_V_list = c_V_list;
cap_info.c_E_list = c_E_list;
cap_info.prob_V_list = prob_V_list;
cap_info.prob_E_list = prob_E_list;
cap_info.cap_ind_V = cap_ind_V;
cap_info.cap_ind_E = cap_ind_E;

% simplify some notations

Delta.Delta_1 = Delta_1;
Delta.Delta_2 = Delta_2;
Delta.Delta_1e = Delta_1e;
Delta.Delta_2e = Delta_2e;

E2.e = E_e;
E2.v = E_v;
E2.t = E_t;

N_info.N_V = N_V;
N_info.N_E = N_E;
N_info.N_J = N_J;
N_info.N_Vb = N_Vb;
N_info.N_Eb = N_Eb;


C_b_all(1,:)= [0,0,0,0];

M2 = 200;
w = 0.11;
solution = decision_fcn(E,Delta,Delta_adj,E2,N_info,C_V,C_E,cap_info,C_b_all,KZ,F,M,M2,w);


% solution = best_Z(E,Delta,Delta_adj,E2,N_info,C_V,C_E,C_b_all,KZ,F,M,M2,w);
% disp(solution.Z)
% solution = best_Z();