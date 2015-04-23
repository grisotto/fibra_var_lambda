%% funcao guardaImagem
function guardaImagem(model,fig,dim, pgs, modo,label,nome,zum)
% GUARDAIMAGEM: saves an array of pictures plotted with comsol's Livelink function mphplot
% Arguments:
% model: name of the model
% fig: positive integer indicating the fig number used by Matlab to
%       identify the figure window.
% dim: dimension of the plot array, i.e [ m n ] means m rows with n columns.
% pgs: could be a string or a cell made mxn of strings
% modo: modes to plot, it may be an array of numbers with integer values.
% label: string to put on the bottom of the figure
% nome: name of the output file.
% zum: zoom factor (see zoom command in Matlab).
%
ld = dim(1)*dim(2);
assert(all(size(dim) == [1 2]), 'guardaImagem: as dimensoes devem ser um vetor 1 x 2');
assert(ld == length(pgs) || ischar(pgs),'guardaImagem: pgs deve ser um string ou um cell com numero de elementos igual ao numero de graficos declarado');
assert(ld == length(modo),'guardaImagem: o numero de posicoes deve ser igual ao numero de graficos declarado');
if exist('imagem','dir') ~= 7
    mkdir('imagem');
end
%
figure(fig);
clf;
for cont=1:ld % guarda os graficos dos 'ld' modos com maior autovalor.
    subplot(dim(1),dim(2),cont);
    if ischar(pgs) && all(pgs(1:2) == 'pg')
        pgraf = pgs;
    elseif iscellstr(pgs)
        pgraf = pgs{cont};
        assert(all(pgraf(1:2) == 'pg'),'guardaImagem: o argumento pgs nao e'' uma celula de strings que comecam com "pg"');
    else
        error('guardaImagem: o argumento pgs nao esta bem definido.');
    end
    % pegaNeffs, subfuncao, pega os indices efetivos associados aos modos
    titulo = pegaNeffs(model,pgraf,modo(cont));
    
    % Limpa os titulos
%     model.result(pgraf).set('unitintitle', false);
%     model.result(pgraf).set('titletype', 'custom');
%     model.result(pgraf).set('frametype', 'spatial');
%     model.result(pgraf).set('solrepresentation', 'solnum');
%     model.result(pgraf).set('typeintitle', false);
%     model.result(pgraf).set('descriptionintitle', false);
    %
    model.result(pgraf).set('solnum', modo(cont));
    mphplot(model,pgraf);
    zoom(zum);
    axis off;
    model.result(pgraf).set('titletype', 'manual');
    title(titulo)
end
%suplabel(label,'x',[.09 .1 .84 .84]);
set(gcf,'PaperPositionMode','auto');
print('-r200','-djpeg',['imagem/' nome,'.jpg']);
end

%% subfuncao pegaNeffs
function out = pegaNeffs(modelo,pg,modo)
    if strcmp(pg,'pg1')
        out = mphglobal(modelo,'emw.neff','dataset','dset1','solnum',modo);
    elseif strcmp(pg,'pg2')
        out = mphglobal(modelo,'emw2.neff','dataset','dset2','solnum',modo);
    else
        error('Erro na subfuncao pegaNeffs, pg nao eh nenhuma das opcoes possiveis');
    end
    
end