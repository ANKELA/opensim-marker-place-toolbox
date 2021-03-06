function x0 = getInitCond(options)

global testCoords

% modelFile = [options.modelFolder options.newName];
modelFile = options.model;

% these guesses must have accompanying calculations in ModScaler.m

% global MODEL

% Pull in the modeling classes straight from the OpenSim distribution
import org.opensim.modeling.*
   
model = Model(modelFile);
model.initSystem();

markers = model.getMarkerSet;
m = Vec3(0,0,0);

% determine amputation side
joints = model.getJointSet();
socketParent = joints.get('socket').getParentBody();

if strcmp(options.bodySet, 'ROB') % Note sternum not included - constrained to initial position
    if strcmp(char(socketParent),'tibia_l_amputated')
        markerNames = {'R_AC','L_AC','R_ASIS','L_ASIS','R_PSIS', ...
            'L_PSIS','R_THIGH_PROX_POST','R_THIGH_PROX_ANT', ...
            'R_THIGH_DIST_POST','R_THIGH_DIST_ANT','R_SHANK_PROX_ANT', ...
            'R_SHANK_PROX_POST','R_SHANK_DIST_POST','R_SHANK_DIST_ANT', ...
            'R_HEEL_SUP','R_HEEL_MED','R_HEEL_LAT','R_TOE','R_1ST_MET', ...
            'R_5TH_MET','C7'};
    else
        markerNames = {'R_AC','L_AC','R_ASIS','L_ASIS','R_PSIS','L_PSIS', ...
            'L_THIGH_PROX_POST','L_THIGH_PROX_ANT', ...
            'L_THIGH_DIST_POST','L_THIGH_DIST_ANT','L_SHANK_PROX_ANT', ...
            'L_SHANK_PROX_POST','L_SHANK_DIST_POST','L_SHANK_DIST_ANT', ...
            'L_HEEL_SUP','L_HEEL_MED','L_HEEL_LAT','L_TOE','L_1ST_MET', ...
            'L_5TH_MET','C7'};
    end
elseif strcmp(options.bodySet, 'pros')
    if strcmp(char(socketParent),'tibia_l_amputated')
        markerNames = {'L_SHANK_PROX_POST', ...
            'L_SHANK_PROX_ANT','L_SHANK_DIST_ANT','L_SHANK_DIST_POST', ...
            'L_HEEL_SUP','L_HEEL_MED','L_HEEL_LAT', ...
            'L_TOE','L_1ST_MET','L_5TH_MET'};
    else
        markerNames = {'R_SHANK_PROX_POST', ...
            'R_SHANK_PROX_ANT','R_SHANK_DIST_ANT','R_SHANK_DIST_POST', ...
            'R_HEEL_SUP','R_HEEL_MED','R_HEEL_LAT', ...
            'R_TOE','R_1ST_MET','R_5TH_MET'};
    end
elseif strcmp(options.bodySet, 'prosThigh')
    if strcmp(char(socketParent),'tibia_l_amputated')
        markerNames = {'L_THIGH_PROX_POST','L_THIGH_PROX_ANT', ...
            'L_THIGH_DIST_POST','L_THIGH_DIST_ANT'};
    else
        markerNames = {'R_THIGH_PROX_POST','R_THIGH_PROX_ANT', ...
            'R_THIGH_DIST_POST','R_THIGH_DIST_ANT'};
    end
else
    error('Invalid body set name')
end
    
x0 = zeros(1,length(markerNames)*3);
testCoords = cell(1,length(markerNames)*3);

for i = 1:length(markerNames)
    markers.get(markerNames(i)).getOffset(m)
    x0(3*(i-1) + 1) = m.get(0);
    x0(3*(i-1) + 2) = m.get(1);
    x0(3*(i-1) + 3) = m.get(2);
    
    testCoords{3*(i-1) + 1} = [markerNames{i} ' x'];
    testCoords{3*(i-1) + 2} = [markerNames{i} ' y'];
    testCoords{3*(i-1) + 3} = [markerNames{i} ' z'];
end
