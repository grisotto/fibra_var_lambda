function solnum = buscaLPs( model, dset, coords, M, nModos, limiar, neigs, filename )
%BUSCALPs Busca os modos LP0i onde i eh um entero maior que 1.
%  

assert(length(coords) == 2, 'buscaLPs: as coordenadas devem ser um vetor de duas dimensoes');
assert(length(M) == 1 && isnumeric(M), 'buscaLPs: M deve ser um escalar');
assert(length(nModos) == 1 && isnumeric(nModos), 'buscaLPs: a posicao deve ser um escalar');
assert(length(limiar) == 1 && isnumeric(limiar), 'buscaLPs: o limiar deve ser um escalar');
assert(length(dset) == 5 & ischar(dset), 'buscaLPs: o dastaset deve ser uma cadeia de 5 caracteres');

solnum =  zeros(1,nModos);
campos =  zeros(1,neigs);
pos =  zeros(1,neigs);

% Calcula o vetor de poynting nos pontos coords
campos = mphinterp(model,'emw2.Poavz','dataset',dset,'CoordErr','on','coord',[coords(1); coords(2)])./mphmax(model,'emw.Poavz','surface','dataset',dset)';
[~,pos]=sort(campos,'descend');

% apanho para corregir quando 
% if pos(1)~=neigs
%     neff = mphglobal(model,'emw.beta','Dataset',dset,'Solnum',pos(1:nModos));
%     [~,pos2] = max(neff);
%     pos_temp = [pos(pos2) pos(1:pos2-1)];
%     if pos(2)~=neigs
%         pos = [pos_temp pos(pos2+1:end)];
%     else
%         pos = pos_temp;
%     end
%     clear neff pos2 pos_temp
% end

for jj=1:nModos
    if abs(campos(pos(jj))) > limiar
        solnum(jj) = pos(jj);
        fprintf(['>>>escolhido o modo ' num2str(pos(jj)) ' como modo LP0' num2str(jj) ' <<<\n']);
        fprintf(['Potencia na posicao [' num2str(coords) '] eh igual a ' num2str(campos(pos(jj)),'%.3e') '.\n' ]);
    else
        error(['O modo escolhido ' num2str(pos(jj)) ' como modo LP0' num2str(jj) ' nao supera o limiar: ' num2str(limiar) '<<<\n']);
    end
    

    
end
% pinta os modos
label = regexprep(filename,'_',' ');
guardaImagem(model,2,[ ceil(nModos/2) 2 ],'pg1',pos(1:nModos),label,filename,2);
