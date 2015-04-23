function out = model
%
% Fibra_ge_si_MATLAB.m
%
% Model exported on Apr 5 2015, 23:49 by COMSOL 4.3.2.152.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('/media/backup/Comp/Projeto_optics/novafiber/4Paulo');

model.name('fibra_Ge_Si.mph');

model.param.set('Delta', '0.003');
model.param.set('n1', '1.444', ['indice do n' native2unicode(hex2dec('00fa'), 'Cp1252') 'cleo']);
model.param.set('n0', 'n1*sqrt(1-2*Delta)', [native2unicode(hex2dec('00ed'), 'Cp1252') 'ndice da casca']);
model.param.set('q', '2');
model.param.set('micron', '1.0[um]');
model.param.set('omega0', '2*pi*c_const/lambda0');
model.param.set('f0', 'c_const/lambda0', 'frequencia');
model.param.set('a', '4[um]', 'raio do nucleo da SMF');
model.param.set('b', '30e-6[m]', ['raio do n' native2unicode(hex2dec('00fa'), 'Cp1252') 'cleo da MMF']);
model.param.set('c', '60e-6[m]');
model.param.set('m', '0[1]');
model.param.set('lambda0', '1.45e-6[m]');
model.param.set('SA1', '0.6961663');
model.param.set('SA2', '0.4079426');
model.param.set('SA3', '0.8974794');
model.param.set('SL1', '0.0684043[um]');
model.param.set('SL2', '0.1162414[um]');
model.param.set('SL3', '9.89616[um]');
model.param.set('GA1', '0.80686642');
model.param.set('GA2', '0.71815848');
model.param.set('GA3', '0.85416831');
model.param.set('GL1', '0.068972606[um]');
model.param.set('GL2', '0.15396605[um]');
model.param.set('GL3', '11.841931[um]');
model.param.set('xmolG', '0.1934', 'GeO2 concentration for a Thorlabs GRIN fiber, see GRIN_Fleming.nb');
model.param.set('xmolS', '0.033', 'GeO2 concentration for a SMF fiber.');
model.param.set('wl', 'lambda0');
model.param.set('chuteS', '1.45001', 'chute para a SMF');
model.param.set('chuteG', '1.48');
model.param.set('lamb', '1.1', 'comprimento de onda');

model.modelNode.create('mod1');

model.func.create('an1', 'Analytic');
model.func('an1').model('mod1');
model.func('an1').set('fununit', '1');
model.func('an1').set('plotargs', {'x' '-b/2' 'b/2'; 'y' '-b/2' 'b/2'});
model.func('an1').set('funcname', 'n2');
model.func('an1').set('args', {'x' 'y'});
model.func('an1').set('argunit', 'm');
model.func('an1').set('expr', 'n1*sqrt(1-2*Delta*((x^2+y^2)^(q/2)/b^q))');

model.geom.create('geom1', 2);
model.geom('geom1').lengthUnit([native2unicode(hex2dec('00b5'), 'Cp1252') 'm']);
model.geom('geom1').feature.create('c1', 'Circle');
model.geom('geom1').feature.create('c2', 'Circle');
model.geom('geom1').feature.create('c3', 'Circle');
model.geom('geom1').feature('c1').set('r', 'a');
model.geom('geom1').feature('c1').set('pos', {'m*micron' '0'});
model.geom('geom1').feature('c2').set('r', 'b');
model.geom('geom1').feature('c3').set('r', 'c');
model.geom('geom1').run;

model.variable.create('var1');
model.variable('var1').model('mod1');
model.variable('var1').set('ncore', 'sqrt(1+(SA1+xmol*(GA1-SA1))*wl^2/(wl^2-(SL1+xmol*(GL1-SL1))^2)+(SA2+xmol*(GA2-SA2))*wl^2/(wl^2-(SL2+xmol*(GL2-SL2))^2)+(SA3+xmol*(GA3-SA3))*wl^2/(wl^2-(SL3+xmol*(GL3-SL3))^2))');
model.variable.create('var2');
model.variable('var2').model('mod1');
model.variable('var2').set('xmol', 'xmolG');
model.variable('var2').selection.geom('geom1', 2);
model.variable('var2').selection.set([2 3]);
model.variable.create('var3');
model.variable('var3').model('mod1');
model.variable('var3').set('xmol', 'xmolS');
model.variable('var3').selection.geom('geom1', 2);
model.variable('var3').selection.set([1]);

model.view.create('view2', 2);
model.view.create('view3', 2);

model.physics.create('emw', 'ElectromagneticWaves', 'geom1');
model.physics('emw').feature.create('wee2', 'WaveEquationElectric', 2);
model.physics('emw').feature('wee2').selection.set([3]);
model.physics.create('emw2', 'ElectromagneticWaves', 'geom1');
model.physics('emw2').feature.create('wee2', 'WaveEquationElectric', 2);
model.physics('emw2').feature('wee2').selection.set([2 3]);

model.mesh.create('mesh1', 'geom1');
model.mesh('mesh1').feature.create('ftri1', 'FreeTri');
model.mesh('mesh1').feature.create('ref1', 'Refine');
model.mesh('mesh1').feature.create('ref2', 'Refine');
model.mesh('mesh1').feature('ref1').selection.geom('geom1', 2);
model.mesh('mesh1').feature('ref1').selection.set([2 3]);
model.mesh('mesh1').feature('ref2').selection.geom('geom1', 2);
model.mesh('mesh1').feature('ref2').selection.set([2]);

model.result.table.create('tbl1', 'Table');

model.variable('var1').name('Variables 1a');
model.variable('var2').name('Variables 2a');
model.variable('var3').name('Variables 3a');

model.view('view1').axis.set('xmin', '-109.89917755126953');
model.view('view1').axis.set('ymin', '-84.34798431396484');
model.view('view1').axis.set('xmax', '109.89917755126953');
model.view('view1').axis.set('ymax', '84.34798431396484');
model.view('view2').axis.set('xmin', '-28.14876937866211');
model.view('view2').axis.set('ymin', '-17.04224395751953');
model.view('view2').axis.set('xmax', '28.14876937866211');
model.view('view2').axis.set('ymax', '17.04224395751953');
model.view('view3').axis.set('xmin', '-112.5950698852539');
model.view('view3').axis.set('ymin', '-66');
model.view('view3').axis.set('xmax', '112.5950698852539');
model.view('view3').axis.set('ymax', '66');

model.physics('emw').name('SMF Electromagnetic Waves, Frequency Domain');
model.physics('emw').feature('wee1').set('DisplacementFieldModel', 'RefractiveIndex');
model.physics('emw').feature('wee1').set('n_mat', 'userdef');
model.physics('emw').feature('wee1').set('n', {'n0'; '0'; '0'; '0'; 'n0'; '0'; '0'; '0'; 'n0'});
model.physics('emw').feature('wee1').set('ki_mat', 'userdef');
model.physics('emw').feature('wee2').set('DisplacementFieldModel', 'RefractiveIndex');
model.physics('emw').feature('wee2').set('n_mat', 'userdef');
model.physics('emw').feature('wee2').set('n', {'n1'; '0'; '0'; '0'; 'n1'; '0'; '0'; '0'; 'n1'});
model.physics('emw').feature('wee2').set('ki_mat', 'userdef');
model.physics('emw2').name('GrIn Electromagnetic Waves, Frequency Domain 2');
model.physics('emw2').feature('wee1').set('DisplacementFieldModel', 'RefractiveIndex');
model.physics('emw2').feature('wee1').set('n_mat', 'userdef');
model.physics('emw2').feature('wee1').set('n', {'ncore'; '0'; '0'; '0'; 'ncore'; '0'; '0'; '0'; 'ncore'});
model.physics('emw2').feature('wee1').set('ki_mat', 'userdef');
model.physics('emw2').feature('wee2').set('DisplacementFieldModel', 'RefractiveIndex');
model.physics('emw2').feature('wee2').set('n_mat', 'userdef');
model.physics('emw2').feature('wee2').set('n', {'ncore'; '0'; '0'; '0'; 'ncore'; '0'; '0'; '0'; 'ncore'});
model.physics('emw2').feature('wee2').set('ki_mat', 'userdef');

model.mesh('mesh1').feature('ref1').set('numrefine', {'2'});
model.mesh('mesh1').run;

model.result.table('tbl1').comments('Surface Integration 1 (data1(emw.normE)*data2(emw2.normE))');

model.study.create('std1');
model.study('std1').feature.create('mode', 'ModeAnalysis');
model.study.create('std2');
model.study('std2').feature.create('mode', 'ModeAnalysis');

model.sol.create('sol1');
model.sol('sol1').study('std1');
model.sol('sol1').attach('std1');
model.sol('sol1').feature.create('st1', 'StudyStep');
model.sol('sol1').feature.create('v1', 'Variables');
model.sol('sol1').feature.create('e1', 'Eigenvalue');

model.study('std1').feature('mode').set('initstudyhide', 'on');
model.study('std1').feature('mode').set('initsolhide', 'on');
model.study('std1').feature('mode').set('notstudyhide', 'on');
model.study('std1').feature('mode').set('notsolhide', 'on');
model.study('std2').feature('mode').set('initstudyhide', 'on');
model.study('std2').feature('mode').set('initsolhide', 'on');
model.study('std2').feature('mode').set('notstudyhide', 'on');
model.study('std2').feature('mode').set('notsolhide', 'on');

model.sol.create('sol2');
model.sol('sol2').study('std2');
model.sol('sol2').attach('std2');
model.sol('sol2').feature.create('st1', 'StudyStep');
model.sol('sol2').feature.create('v1', 'Variables');
model.sol('sol2').feature.create('e1', 'Eigenvalue');

model.study('std1').feature('mode').set('initstudyhide', 'on');
model.study('std1').feature('mode').set('initsolhide', 'on');
model.study('std1').feature('mode').set('notstudyhide', 'on');
model.study('std1').feature('mode').set('notsolhide', 'on');
model.study('std2').feature('mode').set('initstudyhide', 'on');
model.study('std2').feature('mode').set('initsolhide', 'on');
model.study('std2').feature('mode').set('notstudyhide', 'on');
model.study('std2').feature('mode').set('notsolhide', 'on');

model.result.dataset.create('join1', 'Join');
model.result.dataset('join1').set('data', 'dset1');
model.result.numerical.create('int1', 'IntSurface');
model.result.numerical('int1').set('probetag', 'none');
model.result.create('pg1', 'PlotGroup2D');
model.result.create('pg2', 'PlotGroup2D');
model.result.create('pg3', 'PlotGroup2D');
model.result('pg1').feature.create('surf1', 'Surface');
model.result('pg2').feature.create('surf1', 'Surface');
model.result('pg3').feature.create('surf1', 'Surface');
model.result.export.create('data1', 'Data');
model.result.export.create('data2', 'Data');
model.result.export.create('data3', 'Data');

model.study('std1').feature('mode').set('modeFreq', 'f0');
model.study('std1').feature('mode').set('activate', {'emw' 'on' 'emw2' 'off'});
model.study('std1').feature('mode').set('shift', 'chuteS');
model.study('std2').feature('mode').set('neigs', '20');
model.study('std2').feature('mode').set('modeFreq', 'f0');
model.study('std2').feature('mode').set('activate', {'emw' 'off' 'emw2' 'on'});
model.study('std2').feature('mode').set('shift', 'chuteG');

model.sol('sol1').attach('std1');
model.sol('sol1').feature('st1').name('Compile Equations: Mode Analysis');
model.sol('sol1').feature('st1').set('studystep', 'mode');
model.sol('sol1').feature('v1').set('control', 'mode');
model.sol('sol1').feature('v1').feature('mod1_E2').set('solvefor', false);
model.sol('sol1').feature('e1').set('control', 'mode');
model.sol('sol1').feature('e1').set('shift', 'chuteS');
model.sol('sol1').feature('e1').set('transform', 'effective_mode_index');
model.sol('sol1').feature('e1').feature('aDef').set('complexfun', true);
model.sol('sol1').runAll;
model.sol('sol2').attach('std2');
model.sol('sol2').feature('st1').name('Compile Equations: Mode Analysis');
model.sol('sol2').feature('st1').set('study', 'std2');
model.sol('sol2').feature('st1').set('studystep', 'mode');
model.sol('sol2').feature('v1').set('control', 'mode');
model.sol('sol2').feature('v1').feature('mod1_E').set('solvefor', false);
model.sol('sol2').feature('e1').set('control', 'mode');
model.sol('sol2').feature('e1').set('shift', 'chuteG');
model.sol('sol2').feature('e1').set('neigs', '20');
model.sol('sol2').feature('e1').set('transform', 'effective_mode_index');
model.sol('sol2').feature('e1').feature('aDef').set('complexfun', true);
model.sol('sol2').runAll;

model.result.dataset('join1').set('method', 'explicit');
model.result.dataset('join1').set('data2', 'dset2');
model.result.dataset('join1').set('solutions2', 'one');
model.result.dataset('join1').set('solutions', 'one');
model.result.numerical('int1').set('data', 'join1');
model.result.numerical('int1').set('solrepresentation', 'solnum');
model.result.numerical('int1').set('unit', 'm^4*kg^2/(s^6*A^2)');
model.result.numerical('int1').set('table', 'tbl1');
model.result.numerical('int1').set('dataseries', 'integral');
model.result.numerical('int1').set('descr', 'data1(emw.normE)*data2(emw2.normE)');
model.result.numerical('int1').set('expr', 'data1(emw.normE)*data2(emw2.normE)');
model.result.numerical('int1').setResult;
model.result('pg1').name('Electric Field (emw)');
model.result('pg1').set('frametype', 'spatial');
model.result('pg1').feature('surf1').name('Surface');
model.result('pg1').feature('surf1').set('data', 'dset1');
model.result('pg1').feature('surf1').set('looplevel', {'1'});
model.result('pg2').set('data', 'dset2');
model.result('pg2').feature('surf1').set('data', 'dset2');
model.result('pg2').feature('surf1').set('descr', 'emw2.normE^2');
model.result('pg2').feature('surf1').set('expr', 'emw2.normE^2');
model.result('pg2').feature('surf1').set('looplevel', {'9'});
model.result('pg2').feature('surf1').set('unit', 'm^2*kg^2/(s^6*A^2)');
model.result('pg3').set('data', 'join1');
model.result('pg3').set('solrepresentation', 'solnum');
model.result('pg3').feature('surf1').set('data', 'join1');
model.result('pg3').feature('surf1').set('descr', 'data1(emw.normE)*data2(emw2.normE)');
model.result('pg3').feature('surf1').set('expr', 'data1(emw.normE)*data2(emw2.normE)');
model.result('pg3').feature('surf1').set('unit', 'm^2*kg^2/(s^6*A^2)');
model.result('pg3').feature('surf1').set('solrepresentation', 'solnum');
model.result.export('data1').set('expr', {'emw.normE'});
model.result.export('data1').set('gridstruct', 'grid');
model.result.export('data1').set('header', false);
model.result.export('data1').set('gridx2', 'range(-60,5,-45) range(-44,1,-41) range(-40,0.2,40) range(41,1,44) range(45,5,60)');
model.result.export('data1').set('unit', {'V/m'});
model.result.export('data1').set('fullprec', false);
model.result.export('data1').set('gridy2', 'range(-60,5,-45) range(-44,1,-41) range(-40,0.2,40) range(41,1,44) range(45,5,60)');
model.result.export('data1').set('filename', '/Users/paulogomestl/Documents/Dropbox/Profissional/Jatai/2015/pesquisas/Simulacao/Grisoto/01janeiro/24janeiro/fibra1E1.csv');
model.result.export('data1').set('location', 'grid');
model.result.export('data1').set('descr', {'Electric field norm'});
model.result.export('data2').set('data', 'dset2');
model.result.export('data2').set('expr', {'emw2.normE'});
model.result.export('data2').set('gridstruct', 'grid');
model.result.export('data2').set('header', false);
model.result.export('data2').set('gridx2', 'range(-60,5,-45) range(-44,1,-41) range(-40,0.2,40) range(41,1,44) range(45,5,60)');
model.result.export('data2').set('unit', {'V/m'});
model.result.export('data2').set('fullprec', false);
model.result.export('data2').set('gridy2', 'range(-60,5,-45) range(-44,1,-41) range(-40,0.2,40) range(41,1,44) range(45,5,60)');
model.result.export('data2').set('filename', '/Users/paulogomestl/Documents/Dropbox/Profissional/Jatai/2015/pesquisas/Simulacao/Grisoto/01janeiro/24janeiro/fibra2E6.csv');
model.result.export('data2').set('location', 'grid');
model.result.export('data2').set('descr', {'Electric field norm'});
model.result.export('data3').set('data', 'dset2');
model.result.export('data3').set('expr', {'emw2.beta'});
model.result.export('data3').set('gridstruct', 'grid');
model.result.export('data3').set('header', false);
model.result.export('data3').set('gridx2', 'range(-60,5,-45) range(-44,1,-41) range(-40,0.2,40) range(41,1,44) range(45,5,60)');
model.result.export('data3').set('unit', {''});
model.result.export('data3').set('fullprec', false);
model.result.export('data3').set('gridy2', 'range(-60,5,-45) range(-44,1,-41) range(-40,0.2,40) range(41,1,44) range(45,5,60)');
model.result.export('data3').set('filename', '/Users/paulogomestl/Documents/Dropbox/Profissional/Jatai/2015/pesquisas/Simulacao/Grisoto/01janeiro/24janeiro/fibra2E6.csv');
model.result.export('data3').set('location', 'grid');
model.result.export('data3').set('descr', {'Propagation constant'});

model.name('fibra_Ge_Si.mph');

model.result('pg2').run;

out = model;
