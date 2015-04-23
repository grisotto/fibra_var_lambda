function out = model
%
% Tripathi_b_MATLAB.m
%
% Model exported on Apr 5 2015, 23:28 by COMSOL 4.3.2.152.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('/media/backup/Comp/Projeto_optics/novafiber/4Paulo');

model.name('TripathiModel_v43b.mph');

model.param.set('chuteG', '1.47673');
model.param.set('chuteS', '1.45001', 'chute para a SMF');
model.param.set('M', '1', 'escala');
model.param.set('lamb', '1.1', 'cumprimento de onda em microns');
model.param.set('frq', 'c_const/(lamb*1[um])', 'frequencia');
model.param.set('dCore', '4[um]', 'diametro nucleo');
model.param.set('dClad', '125[um]', 'diametro da casca');
model.param.set('interfaz', 'M*dClad', 'interfaz taper-exterior');
model.param.set('GRIN_dCore', 'M*62.5[um]');
model.param.set('SA1', '0.6961663');
model.param.set('SA2', '0.4079426');
model.param.set('SA3', '0.8974794');
model.param.set('SL1', '0.0684043');
model.param.set('SL2', '0.1162414');
model.param.set('SL3', '9.896160999999999');
model.param.set('q', '2', 'exponente do perfil do RI');
model.param.set('GA1', '0.80686642', 'Mixed Sellemeir, Fleming 1984');
model.param.set('GA2', '0.71815848');
model.param.set('GA3', '0.85416831');
model.param.set('GL1', '0.068972606');
model.param.set('GL2', '0.15396605');
model.param.set('GL3', '11.841931');
model.param.set('xmolG', '0.1934', 'Concentracao GeO2 num guia multimodo, ver GRIN_Fleming.nb');
model.param.set('xmolS', '0.033', 'Concentracao GeO2 num guia monomodo, ver GRIN_Fleming.nb');
model.param.set('next', '1', 'indice de refracao do material externo');

model.modelNode.create('mod1');
model.modelNode('mod1').name('EM Waves');

model.func.create('an3', 'Analytic');
model.func.create('an4', 'Analytic');
model.func.create('an5', 'Analytic');
model.func.create('an6', 'Analytic');
model.func.create('an2', 'Analytic');
model.func('an3').name('Sellmeier');
model.func('an3').set('plotargs', {'ll' '0.6' '1.8'});
model.func('an3').set('funcname', 'ncl');
model.func('an3').set('args', {'ll'});
model.func('an3').set('expr', 'sqrt(1+SA1*ll^2/(ll^2-SL1^2)+SA2*ll^2/(ll^2-SL2^2)+SA3*ll^2/(ll^2-SL3^2))');
model.func('an4').name('Mixed Sellmeier');
model.func('an4').set('plotargs', {'ll' '0.8' '1.6'; 'xmol' '0' '1'});
model.func('an4').set('funcname', 'n0');
model.func('an4').set('args', {'ll' 'xmol'});
model.func('an4').set('expr', 'sqrt(1+ (SA1+xmol*(GA1 - SA1))*ll^2/(ll^2-(SL1+xmol*(GL1-SL1))^2) + (SA2+xmol*(GA2 - SA2))*ll^2/(ll^2-(SL2+xmol*(GL2 - SL2))^2) + (SA3+xmol*(GA3-SA3))*ll^2/(ll^2-(SL3+xmol*(GL3-SL3))^2))');
model.func('an5').name('DeltaM');
model.func('an5').set('plotargs', {'ll' '0' '1'; 'xmol' '0' '1'});
model.func('an5').set('funcname', 'DeltaM');
model.func('an5').set('args', {'ll' 'xmol'});
model.func('an5').set('expr', '(n0(ll,xmol)^2 - ncl(ll)^2)/(2*n0(ll,xmol)^2)');
model.func('an6').name('rr');
model.func('an6').set('plotargs', {'x' '0' '1'; 'y' '0' '1'});
model.func('an6').set('funcname', 'rr');
model.func('an6').set('args', {'x' 'y'});
model.func('an6').set('expr', 'sqrt(x^2+y^2)');
model.func('an2').name('nCore');
model.func('an2').set('plotargs', {'x' '-GRIN_dCore/2' 'GRIN_dCore/2'; 'y' '-GRIN_dCore/2' 'GRIN_dCore/2'; 'll' '1.55' '1.55'; 'xmol' '0' '1'});
model.func('an2').set('funcname', 'nCore');
model.func('an2').set('complex', true);
model.func('an2').set('args', {'x' 'y' 'll' 'xmol'});
model.func('an2').set('expr', 'n0(ll,xmol)*sqrt(1-2*DeltaM(ll,xmol)*(2*rr(x,y)/GRIN_dCore)^q)');

model.geom.create('geom1', 2);
model.geom('geom1').feature.create('c5', 'Circle');
model.geom('geom1').feature.create('c2', 'Circle');
model.geom('geom1').feature.create('c4', 'Circle');
model.geom('geom1').feature.create('c7', 'Circle');
model.geom('geom1').feature.create('c6', 'Circle');
model.geom('geom1').feature.create('c3', 'Circle');
model.geom('geom1').feature('c5').name('Core SMF');
model.geom('geom1').feature('c5').set('r', 'dCore/2');
model.geom('geom1').feature('c5').set('angle', '180');
model.geom('geom1').feature('c2').name('Core GRIN');
model.geom('geom1').feature('c2').set('r', 'GRIN_dCore/2');
model.geom('geom1').feature('c2').set('angle', '180');
model.geom('geom1').feature('c4').name('Refine');
model.geom('geom1').feature('c4').set('r', 'GRIN_dCore/3');
model.geom('geom1').feature('c4').set('angle', '180');
model.geom('geom1').feature('c7').name('Interfaz');
model.geom('geom1').feature('c7').set('r', 'interfaz/2');
model.geom('geom1').feature('c7').set('angle', '180');
model.geom('geom1').feature('c6').name('Exterior');
model.geom('geom1').feature('c6').set('r', 'dClad/2+5*1.55[um]');
model.geom('geom1').feature('c6').set('angle', '180');
model.geom('geom1').feature('c3').name('PML');
model.geom('geom1').feature('c3').set('r', 'dClad/2+10*1.55[um]');
model.geom('geom1').feature('c3').set('angle', '180');
model.geom('geom1').run;

model.material.create('mat1');
model.material('mat1').propertyGroup.create('RefractiveIndex', 'Refractive index');
model.material('mat1').selection.set([3]);
model.material.create('mat2');
model.material('mat2').propertyGroup.create('RefractiveIndex', 'Refractive index');
model.material('mat2').selection.set([4 5 6]);
model.material.create('mat3');
model.material('mat3').propertyGroup.create('RefractiveIndex', 'Refractive index');
model.material('mat3').selection.set([1 2]);

model.physics.create('emw', 'ElectromagneticWaves', 'geom1');
model.physics.create('emw2', 'ElectromagneticWaves', 'geom1');
model.physics('emw2').feature.create('wee2', 'WaveEquationElectric', 2);
model.physics('emw2').feature('wee2').selection.set([6]);
model.physics('emw2').feature.create('wee3', 'WaveEquationElectric', 2);
model.physics('emw2').feature('wee3').selection.set([1 2]);

model.mesh.create('mesh1', 'geom1');
model.mesh('mesh1').feature.create('ftri1', 'FreeTri');
model.mesh('mesh1').feature.create('ref1', 'Refine');
model.mesh('mesh1').feature.create('ref2', 'Refine');
model.mesh('mesh1').feature('ref1').selection.geom('geom1', 2);
model.mesh('mesh1').feature('ref1').selection.set([1 2 4 5 6]);
model.mesh('mesh1').feature('ref2').selection.geom('geom1', 2);
model.mesh('mesh1').feature('ref2').selection.set([1 5 6]);

model.coordSystem.create('pml1', 'geom1', 'PML');
model.coordSystem('pml1').selection.set([1]);

model.view('view1').axis.set('xmin', '-1.4426675625145435E-4');
model.view('view1').axis.set('ymin', '-6.322329863905907E-5');
model.view('view1').axis.set('xmax', '1.4426675625145435E-4');
model.view('view1').axis.set('ymax', '1.4122329594101757E-4');

model.material('mat1').name('Cladding');
model.material('mat1').propertyGroup('RefractiveIndex').set('n', '');
model.material('mat1').propertyGroup('RefractiveIndex').set('ki', '');
model.material('mat1').propertyGroup('RefractiveIndex').set('n', {'ncl(lamb)' '0' '0' '0' 'ncl(lamb)' '0' '0' '0' 'ncl(lamb)'});
model.material('mat1').propertyGroup('RefractiveIndex').set('ki', {'0' '0' '0' '0' '0' '0' '0' '0' '0'});
model.material('mat2').name('Core');
model.material('mat2').propertyGroup('RefractiveIndex').set('n', '');
model.material('mat2').propertyGroup('RefractiveIndex').set('ki', '');
model.material('mat2').propertyGroup('RefractiveIndex').set('n', {'nCore(x[1/m],y[1/m],lamb,xmolG)' '0' '0' '0' 'nCore(x[1/m],y[1/m],lamb,xmolG)' '0' '0' '0' 'nCore(x[1/m],y[1/m],lamb,xmolG)'});
model.material('mat2').propertyGroup('RefractiveIndex').set('ki', {'0' '0' '0' '0' '0' '0' '0' '0' '0'});
model.material('mat3').name('Next');
model.material('mat3').propertyGroup('RefractiveIndex').set('n', '');
model.material('mat3').propertyGroup('RefractiveIndex').set('ki', '');
model.material('mat3').propertyGroup('RefractiveIndex').set('n', {'next' '0' '0' '0' 'next' '0' '0' '0' 'next'});
model.material('mat3').propertyGroup('RefractiveIndex').set('ki', {'0' '0' '0' '0' '0' '0' '0' '0' '0'});

model.physics('emw').name('GRIN, Frequency Domain');
model.physics('emw').feature('wee1').set('DisplacementFieldModel', 'RefractiveIndex');
model.physics('emw').feature('wee1').set('materialType', 'from_mat');
model.physics('emw').feature('init1').set('E', {'emw.Ex'; 'emw.Ey'; '0'});
model.physics('emw2').name('SMF, Frequency Domain');
model.physics('emw2').feature('wee1').set('DisplacementFieldModel', 'RefractiveIndex');
model.physics('emw2').feature('wee1').set('n_mat', 'userdef');
model.physics('emw2').feature('wee1').set('n', {'ncl(lamb)'; '0'; '0'; '0'; 'ncl(lamb)'; '0'; '0'; '0'; 'ncl(lamb)'});
model.physics('emw2').feature('wee1').set('ki_mat', 'userdef');
model.physics('emw2').feature('wee1').set('materialType', 'solid');
model.physics('emw2').feature('init1').set('E2', {'emw2.Ex'; 'emw2.Ey'; '0'});
model.physics('emw2').feature('wee2').set('DisplacementFieldModel', 'RefractiveIndex');
model.physics('emw2').feature('wee2').set('n_mat', 'userdef');
model.physics('emw2').feature('wee2').set('n', {'n0(lamb,xmolS)'; '0'; '0'; '0'; 'n0(lamb,xmolS)'; '0'; '0'; '0'; 'n0(lamb,xmolS)'});
model.physics('emw2').feature('wee2').set('ki_mat', 'userdef');
model.physics('emw2').feature('wee2').set('epsilonr_mat', 'userdef');
model.physics('emw2').feature('wee2').set('epsilonr', {'n0(lamb,xmolS)'; '0'; '0'; '0'; 'n0(lamb,xmolS)'; '0'; '0'; '0'; 'n0(lamb,xmolS)'});
model.physics('emw2').feature('wee3').set('DisplacementFieldModel', 'RefractiveIndex');

model.mesh('mesh1').feature('size').set('hauto', 3);
model.mesh('mesh1').run;

model.coordSystem('pml1').set('ScalingType', 'Cylindrical');

model.study.create('std1');
model.study('std1').feature.create('mode', 'ModeAnalysis');
model.study('std1').feature.create('mode2', 'ModeAnalysis');

model.sol.create('sol1');
model.sol('sol1').study('std1');
model.sol('sol1').attach('std1');
model.sol('sol1').feature.create('st1', 'StudyStep');
model.sol('sol1').feature.create('v1', 'Variables');
model.sol('sol1').feature.create('e1', 'Eigenvalue');
model.sol('sol1').feature.create('su1', 'StoreSolution');
model.sol('sol1').feature.create('st2', 'StudyStep');
model.sol('sol1').feature.create('v2', 'Variables');
model.sol('sol1').feature.create('e2', 'Eigenvalue');

model.study('std1').feature('mode').set('initstudyhide', 'on');
model.study('std1').feature('mode').set('initsolhide', 'on');
model.study('std1').feature('mode').set('notstudyhide', 'on');
model.study('std1').feature('mode').set('notsolhide', 'on');
model.study('std1').feature('mode2').set('initstudyhide', 'on');
model.study('std1').feature('mode2').set('initsolhide', 'on');
model.study('std1').feature('mode2').set('notstudyhide', 'on');
model.study('std1').feature('mode2').set('notsolhide', 'on');

model.result.dataset.create('join1', 'Join');
model.result.dataset('join1').set('data', 'dset1');
model.result.create('pg1', 'PlotGroup2D');
model.result.create('pg2', 'PlotGroup2D');
model.result('pg1').feature.create('surf1', 'Surface');
model.result('pg2').feature.create('surf1', 'Surface');

model.study('std1').feature('mode').set('modeFreq', 'c_const/(lamb*1[um])');
model.study('std1').feature('mode').set('activate', {'emw' 'off' 'emw2' 'on'});
model.study('std1').feature('mode').set('shift', 'chuteS');
model.study('std1').feature('mode2').set('modeFreq', 'c_const/(lamb*1[um])');
model.study('std1').feature('mode2').set('activate', {'emw' 'on' 'emw2' 'off'});
model.study('std1').feature('mode2').set('shift', 'chuteG');

model.sol('sol1').attach('std1');
model.sol('sol1').feature('st1').name('Compile Equations: Mode Analysis');
model.sol('sol1').feature('st1').set('studystep', 'mode');
model.sol('sol1').feature('v1').set('control', 'mode');
model.sol('sol1').feature('v1').feature('mod1_E').set('solvefor', false);
model.sol('sol1').feature('e1').set('control', 'mode');
model.sol('sol1').feature('e1').set('shift', 'chuteS');
model.sol('sol1').feature('e1').set('transform', 'effective_mode_index');
model.sol('sol1').feature('e1').feature('aDef').set('complexfun', true);
model.sol('sol1').feature('st2').name('Compile Equations: Mode Analysis 2 (2)');
model.sol('sol1').feature('st2').set('studystep', 'mode2');
model.sol('sol1').feature('v2').set('control', 'mode2');
model.sol('sol1').feature('v2').set('solnum', 'auto');
model.sol('sol1').feature('v2').set('initmethod', 'sol');
model.sol('sol1').feature('v2').set('notsolmethod', 'sol');
model.sol('sol1').feature('v2').set('notsolnum', 'auto');
model.sol('sol1').feature('v2').set('initsol', 'sol1');
model.sol('sol1').feature('v2').set('notsol', 'sol1');
model.sol('sol1').feature('v2').feature('mod1_E2').set('solvefor', false);
model.sol('sol1').feature('e2').set('control', 'mode2');
model.sol('sol1').feature('e2').set('shift', 'chuteG');
model.sol('sol1').feature('e2').set('transform', 'effective_mode_index');
model.sol('sol1').feature('e2').feature('aDef').set('complexfun', true);
model.sol('sol1').runAll;

model.result.dataset('join1').set('method', 'explicit');
model.result.dataset('join1').set('data2', 'dset2');
model.result.dataset('join1').set('solnum2', '6');
model.result.dataset('join1').set('solnum', '6');
model.result.dataset('join1').set('solutions2', 'one');
model.result.dataset('join1').set('solutions', 'one');
model.result('pg1').name('Electric Field (emw)');
model.result('pg1').set('frametype', 'spatial');
model.result('pg1').set('looplevel', {'6'});
model.result('pg1').feature('surf1').name('Surface');
model.result('pg2').name('Electric Field (emw2)');
model.result('pg2').set('data', 'dset2');
model.result('pg2').set('frametype', 'spatial');
model.result('pg2').set('looplevel', {'6'});
model.result('pg2').feature('surf1').name('Surface');
model.result('pg2').feature('surf1').set('expr', 'emw2.normE');

out = model;
