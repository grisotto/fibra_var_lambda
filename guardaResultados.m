function guardaResultados(nome, dados,M,N,ll,cabeca)
%Cria o arquivo de registro junto com uma explicacao nas primeras linhas.
%
% Determina se o arquivo existia antes de chamar a funcao.
if exist(nome,'file') == 2
    bandeira = true;
elseif exist(nome,'file') == 0 % o arquivo nao existe
    bandeira = false;
else
    error('guardaResultados: nome eh outra coisa diferente a um arquivo')
end

% ABRE O ARQUIVO
fid1 = fopen(nome, 'a');

% COLOCA CABECALHO SO EM ARQUIVOS NOVOS
if ~bandeira % o arquivo nao existia antes de chamar a funcao.
    if nargin < 6
        cabeca = 'lambda\t\t\t\t a1\t\t\t\t a2\t\t\t betas1\t\t\t betas2\t\t\t deltaNeff';
    end
    fprintf(fid1,['*** ',datestr(clock, 'local'),' ***\n']);
    fprintf(fid1,['*** Estudio parametrico: M=', num2str(M),' e next=', num2str(N),'   ***\n']);
    fprintf(fid1,[ cabeca '\n']);
end
    
% ESCREVE RESULTADOS dependendo do tamanho da variavel dados.
format long e
if isvector(dados) % dados eh um vetor que vai ser anexo ao final do arquivo de resultados.
    fprintf(fid1,'%.15e\t',dados);
    fprintf(fid1,'\n');
elseif ~bandeira && length(dados) == ll
    for i=1:ll
        fprintf(fid1,'%.15e\t',dados(i,:));
        fprintf(fid1,'\n');
    end
end
% FECHA O ARQUIVO
fclose(fid1);
end
