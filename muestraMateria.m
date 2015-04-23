function [] = muestraMateria( model, label, nome)
%MUESTRAMATERIA Muestra la distribuci??n de ??ndices de refraccion para las
%dos fibras.
% figure(3)
% clf

% Define a componente xx do tensor de indice de refracao como a grandeza a
% ser plotada.
model.result('pg1').feature('surf1').set('expr','emw.nxx');
model.result('pg2').feature('surf1').set('expr','emw2.nxx');
%
guardaImagem(model,3,[ 1 2 ],{'pg2' 'pg1'},[ 1 1 ],label,nome,2);
%
% Restaura a componente z do vetor de Poynting como a grandeza a ser
% plotada
model.result('pg1').feature('surf1').set('expr','emw.Poavz');
model.result('pg2').feature('surf1').set('expr','emw2.Poavz');

end

