%Created by Kriston Rickman
%Date created 07/06/26
%V1.53
%Energy based constraint analysis
%Note:


%After changing data from trim and control authority we need to run all the
%known data into DATCOM to double check for uncertanties. Then run the new
% information into the functions to grab the thrust, weight, wing area,
%stability, and trim. Then finally run the performance verificaiton to test
%if it is possible for what this aircraft was built to do.

%/*simple concept of the takeoff constraint. formulas have been double
% checked and have changed base on the developing knowledge on the
% matter.*\


clearvars -except user_aircraft_TW_input user_ST_aircraft_input
clear functions
clear classes

clc


%What the user wants to do

if isfile("user_TW_aircraft.mat")

    load("user_TW_aircraft.mat", "user_TW_saved");

else
    
    user_TW_saved = struct('name', {}, 'user_input', {});

end


if isfile("user_ST_aircraft.mat")

    load("user_ST_aircraft.mat", "user_ST_saved");

else
    
    user_ST_saved = struct('name', {}, 'TW_aircraft_name', {}, 'user_input', {});

end


if isfile("user_loads_aircraft.mat")

    load("user_loads_aircraft.mat", "user_loads_saved");

else
   
    user_loads_saved = struct('name', {}, 'ST_aircraft_name', {}, 'user_input', {});

end



currState = Aircraft_constraint_states.MAIN_MENU;

while true
    switch currState

%This is the main page
        case Aircraft_constraint_states.MAIN_MENU
            currState = user_state();


            
%This shows the user T/W saved aircraft data names
        case Aircraft_constraint_states.SAVED_TW_AIRCRAFT_DATA
            currState = doc_options(user_TW_saved);



%This shows the menu of the specific T/W aircraft the user chose
        case Aircraft_constraint_states.USER_TW_AIRCRAFT_MENU
             user_aircraft_TW_input = user_TW_saved(1).user_input;

            [currState, user_TW_saved] = user_TW_aircraft_menu(user_TW_saved);



%This edits the user specific T/W aircraft data that they chose
        case Aircraft_constraint_states.EDIT_SAVED_TW_AIRCRAFT
            user_aircraft_TW_input = user_TW_saved(1).user_input;

            user_aircraft_TW_input = edit_TW_aircraft(user_aircraft_TW_input);

            user_TW_saved(1).user_input = user_aircraft_TW_input;

            save("user_TW_aircraft.mat", "user_TW_saved");

            disp("Data has been saved...");

            currState = Aircraft_constraint_states.USER_TW_AIRCRAFT_MENU;



%This asks the user for T/W aircraft data
        case Aircraft_constraint_states.GET_TW_AIRCRAFT_DATA
            user_aircraft_TW_input = get_user_aircraft_design_inputs();
            
            currState = Aircraft_constraint_states.CALCULATE_TW;
        


%This calculates what the user entered from getting the T/W aircraft data
        case Aircraft_constraint_states.CALCULATE_TW
            user_aircraft_TW_input_loads = user_aircraft_TW_input;

            user_aircraft_TW_input_loads.Wing_area = ...
                user_ST_aircraft_input.Wing_area;
            
            TW = calculate_TW_constraints(user_aircraft_TW_input_loads);

            currState = Aircraft_constraint_states.GRAPH_TW;



%This graphs what the calculation gave from getting the T/W aircraft data
        case Aircraft_constraint_states.GRAPH_TW
            display_TW(TW);
            user_TW_saved = save_user_aircraft(user_TW_saved, ...
                user_aircraft_TW_input);
            currState = Aircraft_constraint_states.MAIN_MENU;
            % disp(user_TW_saved(1).user_input);



%This calculates what the user T/W aircraft data entered from getting the aircraft data
        case Aircraft_constraint_states.CALCULATE_TW_FROM_USER_TW_DATA_CALCULATION
            TW = calculate_TW_constraints(user_aircraft_TW_input);

            currState = ...
                Aircraft_constraint_states.GRAPH_TW_FROM_USER_TW_DATA_CALCULATION;



%This graphs the calculation that was recieved from the user T/W aircraft data
%file
        case Aircraft_constraint_states.GRAPH_TW_FROM_USER_TW_DATA_CALCULATION
            display_TW(TW);

            currState = Aircraft_constraint_states.SAVED_TW_AIRCRAFT_DATA;



%This asks the user fot S/T aircraft data            
        case Aircraft_constraint_states.GET_ST_AIRCRAFT_DATA
            user_ST_aircraft_input = get_user_aircraft_ST_design_inputs();
            
            currState = Aircraft_constraint_states.CALCULATE_ST;



%This calculates what the user entered from getting the S/T aircraft data
        case Aircraft_constraint_states.CALCULATE_ST
            ST = calculate_ST(user_aircraft_TW_input, ...
                user_ST_aircraft_input);

            currState = Aircraft_constraint_states.DISPLAY_ST;



%This graphs what was calculated from getting the S/T aircraft data
        case Aircraft_constraint_states.DISPLAY_ST
            display_ST_calc_data(ST);

            user_ST_saved = save_user_ST_aircraft(user_ST_saved, ...
                user_ST_aircraft_input, user_TW_saved(1).name);

            currState = Aircraft_constraint_states.USER_TW_AIRCRAFT_MENU;



%This shows the user S/T saved aircraft data names
        case Aircraft_constraint_states.SAVED_ST_AIRCRAFT_DATA
            currState = ST_doc_options(user_TW_saved, user_ST_saved);



%This shows the menu of the specific S/T aircraft the user chose
        case Aircraft_constraint_states.USER_ST_AIRCRAFT_MENU
            user_ST_aircraft_input = user_ST_saved(1).user_input;

            [currState, user_ST_saved] = user_ST_aircraft_menu(user_ST_saved);



%This calculates the specific S/T aircraft the user chose
        case Aircraft_constraint_states.CALCULATE_ST_FROM_USER_ST_DATA_CALCULATION
            ST = calculate_ST(user_aircraft_TW_input, ...
                user_ST_aircraft_input);

            currState = ...
                Aircraft_constraint_states.DISPLAY_ST_FROM_USER_ST_DATA_CALCULATION;



%This graph the specific S/T aircraft the user chose
        case Aircraft_constraint_states.DISPLAY_ST_FROM_USER_ST_DATA_CALCULATION
            display_ST_calc_data(ST);

            currState = Aircraft_constraint_states.USER_ST_AIRCRAFT_MENU;

 

%Edits the saved user S/T aircraft data
        case Aircraft_constraint_states.EDIT_SAVED_ST_AIRCRAFT
         
            user_ST_aircraft_input = user_ST_saved(1).user_input;

            user_ST_aircraft_input = edit_ST_aircraft(user_ST_aircraft_input);

            user_ST_saved(1).user_input = user_ST_aircraft_input;

            save("user_ST_aircraft.mat", "user_ST_saved");

            disp("Data has been saved...");

            currState = Aircraft_constraint_states.USER_ST_AIRCRAFT_MENU;


            %The start of aircraft loads



%This asks the user for S/T aircraft data            
        case Aircraft_constraint_states.GET_LOADS_AIRCRAFT_DATA
            user_loads_aircraft_input = get_user_aircraft_loads_design_inputs();
            
            currState = Aircraft_constraint_states.CALCULATE_LOADS;



%This calculates what the user entered from getting the S/T aircraft data
        case Aircraft_constraint_states.CALCULATE_LOADS
            user_aircraft_TW_input_loads = user_aircraft_TW_input;

            user_aircraft_TW_input_loads.Wing_area = ...
                user_ST_aircraft_input.Wing_area;

            TW = calculate_TW_constraints(user_aircraft_TW_input_loads);

            ST = calculate_ST(user_aircraft_TW_input, ...
                user_ST_aircraft_input);
            
            loads = calculate_loads(TW, ST, ...
                user_loads_aircraft_input, user_ST_aircraft_input, ...
                user_aircraft_TW_input);

            currState = Aircraft_constraint_states.DISPLAY_LOADS;



%This graphs what was calculated from getting the S/T aircraft data
        case Aircraft_constraint_states.DISPLAY_LOADS
            display_loads_calc_data(loads);

            user_loads_saved = save_user_loads_aircraft(user_loads_saved, ...
                user_loads_aircraft_input, user_ST_saved(1).name);

            currState = Aircraft_constraint_states.USER_ST_AIRCRAFT_MENU;



%This shows the user loads saved aircraft data names
        case Aircraft_constraint_states.SAVED_LOADS_AIRCRAFT_DATA
            currState = loads_doc_options(user_ST_saved, user_loads_saved);



%This shows the menu of the specific loads aircraft the user chose
        case Aircraft_constraint_states.USER_LOADS_AIRCRAFT_MENU
            user_loads_aircraft_input = user_loads_saved(1).user_input;

            [currState, user_loads_saved] = ...
                user_loads_aircraft_menu(user_loads_saved);



%This calculates the specific loads aircraft the user chose
        case Aircraft_constraint_states.CALCULATE_LOADS_FROM_USER_LOADS_DATA_CALCULATION
            user_aircraft_TW_input_loads = user_aircraft_TW_input;

            user_aircraft_TW_input_loads.Wing_area = ...
                user_ST_aircraft_input.Wing_area;
        
            TW = calculate_TW_constraints(user_aircraft_TW_input_loads);

            ST = calculate_ST(user_aircraft_TW_input, ...
                user_ST_aircraft_input);

            loads = calculate_loads(TW, ST, ...
                user_loads_aircraft_input, user_ST_aircraft_input, ...
                user_aircraft_TW_input);

            currState = ...
                Aircraft_constraint_states.DISPLAY_LOADS_FROM_USER_LOADS_DATA_CALCULATION;



%This graph the specific loads aircraft the user chose
        case Aircraft_constraint_states.DISPLAY_LOADS_FROM_USER_LOADS_DATA_CALCULATION
            display_loads_calc_data(loads);

            currState = Aircraft_constraint_states.USER_LOADS_AIRCRAFT_MENU;



%This edits the saved aircraft loads data
        case Aircraft_constraint_states.EDIT_SAVED_LOADS_AIRCRAFT

            user_loads_aircraft_input = user_loads_saved(1).user_input;

            user_loads_aircraft_input = edit_loads_aircraft(user_loads_aircraft_input);

            user_loads_saved(1).user_input = user_loads_aircraft_input;

            save("user_loads_aircraft.mat", "user_loads_saved");

            disp("Data has been saved...");

            currState = Aircraft_constraint_states.USER_LOADS_AIRCRAFT_MENU;
            

    end
end



function TW = calculate_TW_constraints(user_aircraft_TW_input)

%Initial assumptions of aircraft design

Gravity = 9.81;

pi = 3.141592653589793238462643383; 

% for fun I wrote down the decimals ik,
%the program rounds decimals to the 4th decimal

% rho_SL = 1.225;

% Cruise_velocity = 74.594;

% C_Dmin = 0.027; % Assumption from Cirrus sr 20
% C_Lmin = 0.3; % Assumption from Cirrus sr 20

% Sweep_angle = 3; % Made from assumption

% HP_to_watts = 745.7;

%The Design of the aircraft inputs
%NOTE Measuremnt in HP will be convert to Watts

% Engine_power_HP = 230; % Assumption of Eninge need data
% Span = 9; % assume based on aircraft type
% Wing_area = 8:0.1:16; % assume based on aircraft type

% Mass_without_wing_skin = 780; % assume based on aircraft type
% Wing_material_density = 2700; % assumption of kg/m^3 density of GA aluminum
% Wing_skin_thickness = 0.002; % assumption of mass of GA aluminum

% Engine Characteristics calculations

% Engine_power_watts = user_aircraft_TW_input.Engine_power_HP .* HP_to_watts;

%Mass of the aircraft and related Geometry calculations

% Fuel_spent_ground_to_TO = 0.11;
% Fuel_mass_per_gallon = 2.8; % ARD
mass_loss_on_TO = user_aircraft_TW_input.Fuel_spent_ground_to_TO .* ...
    user_aircraft_TW_input.Fuel_mass_per_gallon;

Wing_skin_area_total = 2 .* user_aircraft_TW_input.Wing_area;
Wing_skin_volume = Wing_skin_area_total .* ...
    user_aircraft_TW_input.Wing_skin_thickness;
Wing_skin_mass = Wing_skin_volume .* ...
    user_aircraft_TW_input.Wing_material_density;

Mass_aircraft = user_aircraft_TW_input.Mass_without_wing_skin + Wing_skin_mass; 
% assume based on aircraft type
Mass_TO = Mass_aircraft - mass_loss_on_TO;

TW.Weight_TO = Mass_TO * Gravity;
Wing_loading = TW.Weight_TO ./ user_aircraft_TW_input.Wing_area;
AR_wing = user_aircraft_TW_input.Span.^2 ./ user_aircraft_TW_input.Wing_area;

%Aerodynamic calculations

    %Oswald efficiency calculations - Sweep angle calculation decision
if user_aircraft_TW_input.Sweep_angle == 0
    e = 1.78 .* (1 - 0.045 .* AR_wing.^0.68) - 0.64;
elseif user_aircraft_TW_input.Sweep_angle >= 30
    e = 4.61 .* (1 - 0.045 .* AR_wing.^0.68) .* ...
        (cosd(user_aircraft_TW_input.Sweep_angle)).^0.15 - 3.1;
elseif (user_aircraft_TW_input.Sweep_angle > 0) && ...
        (user_aircraft_TW_input.Sweep_angle < 30)
    e0 = 1.78 .* (1 - 0.045 .* AR_wing.^0.68) - 0.64;
    e30 = 4.61 .* (1 - 0.045 .* AR_wing.^0.68) .* (cosd(30)).^0.15 - 3.1;
    e = e0 + (user_aircraft_TW_input.Sweep_angle ./ 30) .* (e30 - e0);
else
    error("Sweep angle is out of range")
end
    
    %Full Drag Polar Buildup
K_1 = 1./(pi.*AR_wing.*e);

C_D0 = user_aircraft_TW_input.C_Dmin + K_1.*user_aircraft_TW_input.C_Lmin.^2;

K_2 = -2.*K_1.*user_aircraft_TW_input.C_Lmin;

%Takeoff constraint assumptions, variables and formulas
    %variables

    %Desired inputs
% S_G = 502.92; % Ground roll takeoff distance
% K_TO = 1.2;
% C_Lmax_TO = 1.7; % Assumption including flaps, elevator, and wing
% Rolling_friction_coefficient = 0.03;
% Propeller_efficiency_TO = 0.75; % assume based on propeller

user_aircraft_TW_input.rho_TO = ...
    altitude_find_rho(user_aircraft_TW_input.altitude_TO);

    %Velocity formulas
Velocity_stall = sqrt((2 .* TW.Weight_TO) ./ (user_aircraft_TW_input.rho_TO .*...
    user_aircraft_TW_input.Wing_area .* user_aircraft_TW_input.C_Lmax_TO));

Velocity_TO = user_aircraft_TW_input.K_TO * Velocity_stall;

Velocity_avg_TO = Velocity_TO ./ sqrt(2);

    %constraints sub-formulas
q_avg_TO = 0.5 .* user_aircraft_TW_input.rho_TO .* Velocity_avg_TO.^2;

C_L_required_TO = 2 .* TW.Weight_TO ./(user_aircraft_TW_input.rho_TO .*...
    Velocity_TO.^2 .* user_aircraft_TW_input.Wing_area);

%/*C_L_ground_TO For a more accurate constraint create a lift
%coefficient that is specific for ground because the ground 
%and takeoff coefficients are not the same*\

C_DTO = C_D0 + (K_1.*C_L_required_TO.^2) + K_2.*C_L_required_TO;

%/*Lift_avg_TO = 0.5 .* user_aircraft_TW_input.rho_TO .* Velocity_avg_TO.^2
%.* user_aircraft_TW_input.Wing_area .* C_L_required_TO;*\

%/*The lift average take off will change based on the average dynamic
% pressure, lift coefficients for the ground Take off and etc*\

%/*Drag_TO = 0.5 .* C_DTO .* user_aircraft_TW_input.rho_TO .*
%user_aircraft_TW_input.Wing_area .* Velocity_TO.^2;*\

%/*Drag_avg_TO = 0.5 .* user_aircraft_TW_input.rho_TO .* Velocity_avg_TO.^2
%.* user_aircraft_TW_input.Wing_area .* C_DTO;*\

%/*Will also chagned when created ground drag coeffiecients for TO*\
%/*Thrust_TO = (user_aircraft_TW_input.Propeller_efficiency_TO .*
%Engine_power_watts) ./ Velocity_TO;*\

Acceleration_TO = Velocity_TO.^2 ./ (2 .* user_aircraft_TW_input.S_G);

Thrust_to_Weight_TO = (Acceleration_TO ./ Gravity) + ... 
    (q_avg_TO .* C_DTO) ./ Wing_loading + user_aircraft_TW_input.Rolling_friction_coefficient ...
    .* (1 - (q_avg_TO .* C_L_required_TO) ./ Wing_loading); % Takeoff Constraint
%Creating scatter plot for takeoff constraint
% figure;
% plot(Wing_loading, Thrust_to_Weight_TO, '-');

% hold on; %Stops from other plots from overriding the first



%Climb constraint

%/*This assumes no turns and constant climbing velocity, thus
% keeping the load factor (n) roughly around 1. Additionaly, the
% claculation assumes that there are no resistance such as landing
% gears or flaps that can have an inlfluence to drag are all not
% accounted for.*\

%Variables
alpha = 1; % assuming Simple sea-level climb

    %Aircraft desired Inputs
n = 1;
% rate_of_climb = 3.5; %(meters per sec)
% velocity_climb = 48;

user_aircraft_TW_input.rho_climb = ...
    altitude_find_rho(user_aircraft_TW_input.altitude_climb);

%sub-formulas for the climb constraint

user_aircraft_TW_input.velocity_climb = ...
    conv_knts_to_ms(user_aircraft_TW_input.velocity_climb); 

q_climb = 0.5 .* user_aircraft_TW_input.rho_climb .* ...
    user_aircraft_TW_input.velocity_climb.^2;

Beta = Mass_TO ./ Mass_aircraft; % Weight fraction

%A more specific version of Beta could have bee the mass while 
% climbing ./ Mass_TO

Thrust_to_Weight_climb = Beta/alpha .* (((K_1 .* n.^2 .* Beta) ./ ...
    q_climb) .* (TW.Weight_TO ./ user_aircraft_TW_input.Wing_area) + K_2 .* ...
    n + C_D0 ./ ((Beta ./ q_climb) .* Wing_loading) + ...
    user_aircraft_TW_input.rate_of_climb ./ ...
    user_aircraft_TW_input.velocity_climb);


% plot(Wing_loading, Thrust_to_Weight_climb, '-');



% Cruise constraint

%variable
% knot_to_ms = 0.51444444;

%aircraft user inputs
% velocity_cruise = 155 .* knot_to_ms;
%/*Will change in the future for user input when wanting to know
% the T/W for the desired cruise knots they want. Additionaly, will
% add the calculation of the cruise velocity when user does not have
% a desire velcoity and will be based on the parameter they place for
% the aircraft.*\

user_aircraft_TW_input.rho_cruise = ...
    altitude_find_rho(user_aircraft_TW_input.altitude_cruise);

% sub-formulas for constraint

% velocity_cruise_knts = user_aircraft_TW_input.velocity_cruise .* knot_to_ms;

user_aircraft_TW_input.velocity_cruise = ...
    conv_knts_to_ms(user_aircraft_TW_input.velocity_cruise);

q_cruise = 0.5 .* user_aircraft_TW_input.rho_cruise .* ...
    user_aircraft_TW_input.velocity_cruise.^2;

C_Lcruise = Wing_loading ./ q_cruise;

C_D_cruise = C_D0 + (K_1 .* C_Lcruise.^2) + K_2 .* C_Lcruise;

% Calculate the thrust-to-weight ratio for cruise
Thrust_to_Weight_cruise = (q_cruise * C_D_cruise) ./ Wing_loading;

% plot(Wing_loading, Thrust_to_Weight_cruise, '-');



%Turn constraint

%Variables

    %User desire input

%in meters of user idea of their aircraft turning
% radius_turn = 300;

user_aircraft_TW_input.rho_turn = ...
    altitude_find_rho(user_aircraft_TW_input.altitude_turn);

C_Lmax_turn = user_aircraft_TW_input.C_Lmax_turn;


%Sub-formulas
% /*velocity_stall_straight = sqrt((2 .* Wing_loading) ...
% ./ (user_aircraft_TW_input.rho_turn .* C_Lmax_turn)); %A straight
%  line of aircraft stall velocity*\

%The guess of the safe turn velocity
% velocity_guess_turn = user_aircraft_TW_input.K_turn .* velocity_stall_straight;

%Bank angle calculation from the guessed velocity and radius
%/*bank_angle = atand(velocity_guess_turn.^2 ./ 
% (user_aircraft_TW_input.radius_turn * Gravity));*\

%/*The start of the loop. We make it run
%through the loop to be accurate*\
n = 1;

for refine_loop = 1:1000

    n_old = n;
    
    velocity_stall_turn = sqrt((2 * Wing_loading .* n) ...
        ./ (user_aircraft_TW_input.rho_turn .* C_Lmax_turn));
    
    %The safe turn
    velocity_safe_turn = user_aircraft_TW_input.K_turn .* velocity_stall_turn;
    
    %Usign the new safe turn velocity we update the load factor
    update_load_factor = 1 ./ (cosd(atand(velocity_safe_turn.^2 ./  ...
        (user_aircraft_TW_input.radius_turn .* Gravity))));
    
    n = update_load_factor;

    if max(abs(n-n_old)) < 0.0001
        break
    end
    
end

TW.update_load_factor = update_load_factor;

%the dynamic pressure using the safe turn velcoity
q_turn = 0.5 .* user_aircraft_TW_input.rho_turn .* velocity_safe_turn.^2;

%coefficents
C_L_turn = TW.update_load_factor .* Wing_loading ./ q_turn;
C_D_turn = C_D0 + K_1 .* C_L_turn.^2 + K_2 .* C_L_turn;

%Thrust to Weight calculation
Thrust_to_Weight_turn = (q_turn .* C_D_turn) ./ Wing_loading;
% plot(Wing_loading, Thrust_to_Weight_turn, '-');

if any(C_L_turn > C_Lmax_turn)
    % aircraft would stall / turn condition is infeasible
    error("The aircraft will stall due to the turn needing to be higher than" + ...
        " the lift coefficent. This aircraft I would not recommend to use" + ...
        " this any design from this graph unless you found out which aircraft" + ...
        "was causing the problem.");
end



% Horizontal Acceleration constraint

%/*The constraitn assumes that the aircraft is accelerating in a horizontal
%position, no banking nor pitching. The constraitn is asuming that the
% aircraft is in a cruise phase.*\

%variables

    %user inputs
% velocity_accel = 50;
% accel_horiz = 1.1;

user_aircraft_TW_input.rho_horiz_accel = ...
    altitude_find_rho(user_aircraft_TW_input.altitude_horiz_accel);

%sub-formulas

user_aircraft_TW_input.velocity_accel = ...
    conv_knts_to_ms(user_aircraft_TW_input.velocity_accel);

q_accel = 0.5 .* user_aircraft_TW_input.rho_horiz_accel .*...
    user_aircraft_TW_input.velocity_accel.^2;

C_L_accel = Wing_loading ./ q_accel;

C_D_accel = C_D0 + K_1 .* C_L_accel.^2 + K_2 .* C_L_accel;

%horizontal accel. constraint
Thrust_to_Weight_horiz_accel = (q_accel .* C_D_accel) ./ Wing_loading ...
    + user_aircraft_TW_input.accel_horiz ./ Gravity; % Horizontal acceleration
% plot(Wing_loading, Thrust_to_Weight_horiz_accel, '-');



%Approach Constraint

%variables

    %User input
% velocity_approach = user_aircraft_TW_input.velocity_approach .* knot_to_ms;
% K_approach = 1.3;

user_aircraft_TW_input.rho_approach = ...
    altitude_find_rho(user_aircraft_TW_input.altitude_approach);

%sub-formulas

user_aircraft_TW_input.velocity_approach = ...
    conv_knts_to_ms(user_aircraft_TW_input.velocity_approach); 
%Converting knots to m/s

velocity_stall_approach = user_aircraft_TW_input.velocity_approach ./...
    user_aircraft_TW_input.K_approach;

q_approach = 0.5 .* user_aircraft_TW_input.rho_approach .* velocity_stall_approach.^2;

% C_L_approach = Wing_loading ./ q_approach;

%approach formula constraint
Wing_loading_approach = q_approach .* user_aircraft_TW_input.C_Lmax_approach;

%This creates a veritcal line for the apporach constraint
% xline(Wing_loading_approach, '-');



% xlabel('Wing Loading (N/m^2)');
% ylabel('Thrust to Weight Ratio, T/W');
% title('Constraints: T/W vs Wing Loading');
% grid on;
% legend('Takeoff', 'Climb', 'Cruise', 'Turn', 'Horizontal Acceleration', 'Approach');
% 
% %/*stops the plots from being in the hold 
% %mode thus future plots can ovveride*\
% 
% hold off; 

%T/W for plots
TW.Takeoff = Thrust_to_Weight_TO;
TW.Climb = Thrust_to_Weight_climb;
TW.Cruise = Thrust_to_Weight_cruise;
TW.Turn = Thrust_to_Weight_turn;
TW.Horizontal_acceleration = Thrust_to_Weight_horiz_accel;
TW.Approach_wing_loading = Wing_loading_approach;

TW.Wing_loading = Wing_loading;

%For Forward CG limit
TW.q_TO = 0.5 .* user_aircraft_TW_input.rho_TO .* Velocity_TO.^2;
TW.C_L_required_TO = C_L_required_TO;

%For calculating the loads
TW.rho_cruise = user_aircraft_TW_input.rho_cruise;
TW.velocity_cruise = user_aircraft_TW_input.velocity_cruise;

end

function rho = altitude_find_rho(altitude_TO)
rho_SL = 1.225;
Gravity = 9.80665;
temp_SL = 288.15;
temp_lapse_rate = 0.0065;
air_gas = 287.05;

rho = rho_SL .* (1 - (temp_lapse_rate .* altitude_TO) ./ temp_SL) ...
    .^ ((Gravity ./ (air_gas .* temp_lapse_rate)) - 1);

end



%/*From the GET_TW_AIRCRAFT_DATA *\
function user_aircraft_TW_input = get_user_aircraft_design_inputs()

%user_aircraft_TW_input.
%Will add more once organized all the user inputs and can add

%Ask user about:

% Aircraft geometry / design

user_aircraft_TW_input.Engine_power_HP = input("Engine power (HP): ");

user_aircraft_TW_input.Span = input("Wing span (m): ");

user_aircraft_TW_input.Wing_area_raw = input("Wing area (m^2): ");

user_aircraft_TW_input.Sweep_angle = input("Wing sweep angle (deg): ");


% Aircraft mass / material assumptions

user_aircraft_TW_input.Mass_without_wing_skin = ...
    input("Aircraft mass without wing skin (kg): ");

user_aircraft_TW_input.Wing_material_density = ...
    input("Wing material density (kg/m^3): ");

user_aircraft_TW_input.Wing_skin_thickness = ...
    input("Wing skin thickness (m): ");


% Aerodynamic assumptions

user_aircraft_TW_input.C_Dmin = input("Minimum drag coefficient C_Dmin: ");

user_aircraft_TW_input.C_Lmin = ...
    input("Lift coefficient at minimum drag C_Lmin: ");

user_aircraft_TW_input.C_Lmax_TO = ...
    input("Maximum takeoff lift coefficient C_Lmax_TO: ");


% Takeoff requirements / assumptions

user_aircraft_TW_input.S_G = input("Takeoff ground roll distance (m): ");

user_aircraft_TW_input.K_TO = input("Takeoff stall-speed safety factor K_TO: ");

user_aircraft_TW_input.Rolling_friction_coefficient = ...
    input("Rolling friction coefficient: ");

user_aircraft_TW_input.Propeller_efficiency_TO = ...
    input("Takeoff propeller efficiency: ");

user_aircraft_TW_input.altitude_TO = input("Takeoff altitude (m): ");


% Fuel assumptions

user_aircraft_TW_input.Fuel_spent_ground_to_TO = ...
    input("Fuel used before/during takeoff (gal): ");

user_aircraft_TW_input.Fuel_mass_per_gallon = ...
    input("Fuel mass per gallon (kg/gal): ");


% Climb requirements

user_aircraft_TW_input.rate_of_climb = input("Required climb rate: ");

user_aircraft_TW_input.velocity_climb = ...
    input("Climb velocity (knots): ");

user_aircraft_TW_input.altitude_climb = input("Climb constraint altitude (m): ");


% Cruise requirements

user_aircraft_TW_input.velocity_cruise = ...
    input("Cruise velocity (knots): ");

user_aircraft_TW_input.altitude_cruise = input("Cruise altitude (m): ");


% Turn requirements

user_aircraft_TW_input.radius_turn = input("Turn radius (m): ");

user_aircraft_TW_input.altitude_turn = input("Turn altitude (m): ");

user_aircraft_TW_input.C_Lmax_turn = input("Turn max lift coefficient: ");

user_aircraft_TW_input.K_turn = input("Takeoff stall-speed safety factor K_turn: ");


% Horizontal acceleration requirements

user_aircraft_TW_input.velocity_accel = ...
    input("Horizontal acceleration's velocity (knots): ");

user_aircraft_TW_input.accel_horiz = ...
    input("Required horizontal acceleration (m/s^2): ");

user_aircraft_TW_input.altitude_horiz_accel = ...
    input("Horizontal acceleration altitude (m): ");


% Approach requirements

user_aircraft_TW_input.velocity_approach = input("Approach velocity (knots): ");

user_aircraft_TW_input.K_approach = ...
    input("Approach stall-speed safety factor K_approach: ");

user_aircraft_TW_input.C_Lmax_approach = ...
    input("Maximum approach lift coefficient C_Lmax_approach: ");

user_aircraft_TW_input.altitude_approach = input("Approach altitude (m): ");

% Creating the wing_Area bounds

user_aircraft_TW_input.Wing_area_final = user_aircraft_TW_input.Wing_area_raw .* 2;

user_aircraft_TW_input.Wing_area = ...
    user_aircraft_TW_input.Wing_area_raw:0.1:user_aircraft_TW_input.Wing_area_final;

end


%/*What the user specifically wants from the program. Do they want
%specifically explore wing area based on fixed data they already know
% or does the user wants to explore multiple aircrafts and which would
% fit their goals.*\

function currState = user_state() %From main menu

 disp('Choose from the following options:');
 disp(' - Find T/W');
 disp(' - T/W docs');
    
 user_path = input('My choice is: ', 's');
    
if strcmpi(user_path, 'find T/W')
    currState = Aircraft_constraint_states.GET_TW_AIRCRAFT_DATA;


elseif strcmpi(user_path, 'T/W docs')
    currState = Aircraft_constraint_states.SAVED_TW_AIRCRAFT_DATA;

else
    disp("Invalid choice");
    currState = Aircraft_constraint_states.MAIN_MENU;
end

end



%/*Need to finish function that gathers data from the user 
% before starting the calculation of the aircraft T/W.*\

% function TW = found_TW()

% TW = 3;
% end

function user_aircraft_TW_input = edit_TW_aircraft(user_aircraft_TW_input)

disp("Choose what aircraft input you want to change:");
disp("1  - Engine power (HP)");
disp("2  - Wing span");
disp("3  - Wing area");
disp("4  - Wing sweep angle");

disp("5  - Aircraft mass without wing skin");
disp("6  - Wing material density");
disp("7  - Wing skin thickness");

disp("8  - Minimum drag coefficient C_Dmin");
disp("9  - Lift coefficient at minimum drag C_Lmin");
disp("10 - Maximum takeoff lift coefficient C_Lmax_TO");

disp("11 - Takeoff ground roll distance");
disp("12 - Takeoff stall-speed factor K_TO");
disp("13 - Rolling friction coefficient");
disp("14 - Takeoff propeller efficiency");
disp("15 - Takeoff altitude");

disp("16 - Fuel used before/during takeoff");
disp("17 - Fuel mass per gallon");

disp("18 - Required climb rate");
disp("19 - Climb velocity");
disp("20 - Climb altitude");

disp("21 - Cruise velocity");
disp("22 - Cruise altitude");

disp("23 - Turn radius");
disp("24 - Turn altitude");
disp("25 - Turn max lift coefficient C_Lmax_turn");
disp("26 - Turn stall-speed factor K_turn");

disp("27 - Horizontal acceleration velocity");
disp("28 - Required horizontal acceleration");
disp("29 - Horizontal acceleration altitude");

disp("30 - Approach velocity");
disp("31 - Approach stall-speed factor K_approach");
disp("32 - Maximum approach lift coefficient C_Lmax_approach");
disp("33 - Approach altitude");

edit = input("Choose number: ");

switch edit

    case 1
        user_aircraft_TW_input.Engine_power_HP = ...
            input("Engine power (HP): ");

    case 2
        user_aircraft_TW_input.Span = ...
            input("Wing span (m): ");

    case 3
        user_aircraft_TW_input.Wing_area_raw = ...
            input("Wing area (m^2): ");

        user_aircraft_TW_input.Wing_area_final = ...
            user_aircraft_TW_input.Wing_area_raw .* 2;

        user_aircraft_TW_input.Wing_area = user_aircraft_TW_input.Wing_area_raw:...
            0.1:user_aircraft_TW_input.Wing_area_final;

    case 4
        user_aircraft_TW_input.Sweep_angle = ...
            input("Wing sweep angle (deg): ");


    case 5
        user_aircraft_TW_input.Mass_without_wing_skin = ...
            input("Aircraft mass without wing skin (kg): ");

    case 6
        user_aircraft_TW_input.Wing_material_density = ...
            input("Wing material density (kg/m^3): ");

    case 7
        user_aircraft_TW_input.Wing_skin_thickness = ...
            input("Wing skin thickness (m): ");


    case 8
        user_aircraft_TW_input.C_Dmin = ...
            input("Minimum drag coefficient C_Dmin: ");

    case 9
        user_aircraft_TW_input.C_Lmin = ...
            input("Lift coefficient at minimum drag C_Lmin: ");

    case 10
        user_aircraft_TW_input.C_Lmax_TO = ...
            input("Maximum takeoff lift coefficient C_Lmax_TO: ");


    case 11
        user_aircraft_TW_input.S_G = ...
            input("Takeoff ground roll distance (m): ");

    case 12
        user_aircraft_TW_input.K_TO = ...
            input("Takeoff stall-speed safety factor K_TO: ");

    case 13
        user_aircraft_TW_input.Rolling_friction_coefficient = ...
            input("Rolling friction coefficient: ");

    case 14
        user_aircraft_TW_input.Propeller_efficiency_TO = ...
            input("Takeoff propeller efficiency: ");

    case 15
        user_aircraft_TW_input.altitude_TO = ...
            input("Takeoff altitude (m): ");


    case 16
        user_aircraft_TW_input.Fuel_spent_ground_to_TO = ...
            input("Fuel used before/during takeoff (gal): ");

    case 17
        user_aircraft_TW_input.Fuel_mass_per_gallon = ...
            input("Fuel mass per gallon (kg/gal): ");


    case 18
        user_aircraft_TW_input.rate_of_climb = ...
            input("Required climb rate: ");

    case 19
        user_aircraft_TW_input.velocity_climb = ...
           input("Climb velocity (knots): ");

    case 20
        user_aircraft_TW_input.altitude_climb = ...
            input("Climb constraint altitude (m): ");


    case 21
        user_aircraft_TW_input.velocity_cruise = ...
            input("Cruise velocity (knots): ");

    case 22
        user_aircraft_TW_input.altitude_cruise = ...
            input("Cruise altitude (m): ");


    case 23
        user_aircraft_TW_input.radius_turn = ...
            input("Turn radius (m): ");

    case 24
        user_aircraft_TW_input.altitude_turn = ...
            input("Turn altitude (m): ");

    case 25
        user_aircraft_TW_input.C_Lmax_turn = ...
            input("Turn max lift coefficient: ");

    case 26
        user_aircraft_TW_input.K_turn = ...
            input("Turn stall-speed safety factor K_turn: ");


    case 27
        user_aircraft_TW_input.velocity_accel = ...
            input("Horizontal acceleration velocity (knots): ");

    case 28
        user_aircraft_TW_input.accel_horiz = ...
            input("Required horizontal acceleration (m/s^2): ");

    case 29
        user_aircraft_TW_input.altitude_horiz_accel = ...
            input("Horizontal acceleration altitude (m): ");


    case 30
        user_aircraft_TW_input.velocity_approach = ...
        input("Approach velocity (knots): ");

    case 31
        user_aircraft_TW_input.K_approach = ...
            input("Approach stall-speed safety factor K_approach: ");

    case 32
        user_aircraft_TW_input.C_Lmax_approach = ...
            input("Maximum approach lift coefficient C_Lmax_approach: ");

    case 33
        user_aircraft_TW_input.altitude_approach = ...
            input("Approach altitude (m): ");

    otherwise
        disp("Invalid choice");

end
end



function velocity_ms = conv_knts_to_ms(velocity_knots)

velocity_ms = velocity_knots .* 0.5144;

end

function display_TW(TW)

figure;

plot(TW.Wing_loading, TW.Takeoff, '-');
hold on;
            
plot(TW.Wing_loading, TW.Climb, '-');
            
plot(TW.Wing_loading, TW.Cruise, '-');
            
plot(TW.Wing_loading, TW.Turn, '-');
            
plot(TW.Wing_loading, TW.Horizontal_acceleration, '-');
            
% Approach is a vertical wing-loading constraint
xline(TW.Approach_wing_loading, '-');

xlabel('Wing Loading (N/m^2)');
ylabel('Thrust to Weight Ratio, T/W');
title('Constraints: T/W vs Wing Loading');
grid on;
legend('Takeoff', 'Climb', 'Cruise', 'Turn', 'Horizontal Acceleration',...
    'Approach');

%/*stops the plots from being in the hold 
%mode thus future plots can ovveride*\

hold off;

end



function user_TW_saved = save_user_aircraft(user_TW_saved, ...
    user_aircraft_TW_input)

user_save_option = input("Save your inputs? yes/no: ", "s");

if strcmpi(user_save_option, 'yes')

    new_aircraft.name = input("Aircraft name: ", "s");

    new_aircraft.user_input = user_aircraft_TW_input;
                
    user_TW_saved(end + 1) = new_aircraft;
                
    save("user_TW_aircraft.mat", "user_TW_saved");

    disp("Your aircraft data has been saved");

elseif strcmpi(user_save_option, "no")

    disp("did not save aircraft data");

else

    disp("input was not yes or no");

end
end

function currState = doc_options(user_TW_saved)

if isempty(user_TW_saved)

    disp("No saved T/W aircraft data...");
    currState = Aircraft_constraint_states.MAIN_MENU;
    return

end

disp("0  - Back to the last page");
disp("1  - user's " + user_TW_saved(1).name);

user_input = input("your choice: ");

switch user_input

    case 0
        currState = Aircraft_constraint_states.MAIN_MENU;

    case 1
    currState = Aircraft_constraint_states.USER_TW_AIRCRAFT_MENU;

end
end



function [currState, user_TW_saved] = user_TW_aircraft_menu(user_TW_saved)

disp("0  - Back to the last page");
disp("1  - calculate the user aircraft data");
disp("2  - Edit the user aircraft data");
disp("3  - View the user aircraft data");
disp("4  - Delete this file");
disp("5  - get the Stability/Trim");
disp("6  - Stability/Trim docs");

user_choice = input("Your choice: ");

switch user_choice

    case 0
        currState = Aircraft_constraint_states.SAVED_TW_AIRCRAFT_DATA;

    case 1
        currState = Aircraft_constraint_states. ...
            CALCULATE_TW_FROM_USER_TW_DATA_CALCULATION;

    case 2
        currState = Aircraft_constraint_states.EDIT_SAVED_TW_AIRCRAFT;
    
    case 3
        disp(user_TW_saved(1).user_input);
        currState = Aircraft_constraint_states.USER_TW_AIRCRAFT_MENU;

    case 4
        user_TW_saved(1) = [];
        save("user_TW_aircraft.mat", "user_TW_saved");
        disp("File has been deleted");
        currState = Aircraft_constraint_states.SAVED_TW_AIRCRAFT_DATA;

    case 5
        currState = Aircraft_constraint_states.GET_ST_AIRCRAFT_DATA;

    case 6
        currState = Aircraft_constraint_states.SAVED_ST_AIRCRAFT_DATA;

end
end



%Calculation of Trim/Stability constraint analysis from here and onwards



function user_ST_aircraft_input = get_user_aircraft_ST_design_inputs()

%Wing area
user_ST_aircraft_input.Wing_area = input("The wing area that" + ...
    " you chose, enter in that specific wing area that founded from the wing" + ...
    " loading: ");

%Volume coeff
user_ST_aircraft_input.Horizontal_tail_volume_coeff = ...
    input("Choose the horizontal tail volume coefficient number by aircraft type: ");

user_ST_aircraft_input.Vertical_tail_volume_coeff = ...
    input("Choose the vertical tail volume coefficient number by aircraft type: ");

%Radii
user_ST_aircraft_input.Cockpit_radius = input("The cockpit radius: ");

user_ST_aircraft_input.Fuselage_radius_near_tail = input("The " + ...
    "fuselage radius near the tail: ");

%Aspect ratio for vert and horiz stabilizers
user_ST_aircraft_input.AR_HS = input("Horizontal stabilizer aspect ratio: ");

user_ST_aircraft_input.AR_VS = input("Vertical stabilizer aspect ratio: ");

%Taper ratio for ref wing
user_ST_aircraft_input.TR = input("Based on past aircraft choose the " + ...
    "reference wingtaper ratio that resembles the type of aircraft: ");

user_ST_aircraft_input.tail_efficiency = input("Horizontal tail efficiency " + ...
    "    factor (0 to 1): ");

user_ST_aircraft_input.X_wing_root_LE = input("The longitudinal location of " + ...
    "    wing root leading edge (m): ");

end


%/*ref are the variabels that are oringally
%from the energy based constraint anaylsis*\

function ST = calculate_ST(user_aircraft_TW_input, ...
    user_ST_aircraft_input)


%Initial fixed variables
pi = 3.141592653589793238462643383; 

% /*for fun I wrote down the decimals ik, MATLAB automatically rounds
% numbers to the 4th decimal*\

%root chord calculation
ST.root_chord = (2 .* user_ST_aircraft_input.Wing_area) ./ ...
    (user_aircraft_TW_input.Span .* (1 + user_ST_aircraft_input.TR));

%Tip chord calculation
ST.tip_chord = user_ST_aircraft_input.TR .* ST.root_chord;

%Mean aerodynamic chord
ST.MAC_ref = (2 ./ 3) .* ST.root_chord .* ((1 + user_ST_aircraft_input.TR + ...
    user_ST_aircraft_input.TR.^2) ./ (1 + user_ST_aircraft_input.TR));

%Based on a rectangular wing, i would like to add an option for the
%user to add their own Mac_ref if they would want to and the option to
%calulate a swept wing with any type of curvature from the wing tips

%/*Uses the TW aircraft data and the user chosen tail volume coeff and wing
%area to calculate the tail moment arm*\


%Tail moment arm calculation
ST.Tail_moment_arm = sqrt((2 .* user_ST_aircraft_input.Wing_area .* ...
    ((user_ST_aircraft_input.Horizontal_tail_volume_coeff .* ST.MAC_ref) + ...
     (user_ST_aircraft_input.Vertical_tail_volume_coeff .* ...
     user_aircraft_TW_input.Span))) ./ ... %variable span is a ref
    (pi .* (user_ST_aircraft_input.Cockpit_radius + ...
    user_ST_aircraft_input.Fuselage_radius_near_tail)));

%Tail horizontal area
ST.HS_Wing_area = (user_ST_aircraft_input.Horizontal_tail_volume_coeff .* ...
    user_ST_aircraft_input.Wing_area .* ST.MAC_ref) ./ ST.Tail_moment_arm;

%Tail vertical area
ST.VS_Wing_area = (user_ST_aircraft_input.Vertical_tail_volume_coeff .* ...
    user_ST_aircraft_input.Wing_area .* user_aircraft_TW_input.Span) ./ ...
    ST.Tail_moment_arm;


%Span for horizontal stabilizer
ST.HS_Span = sqrt(user_ST_aircraft_input.AR_HS .* ST.HS_Wing_area);

%Span for vertical stabilizer
ST.VS_Span = sqrt(user_ST_aircraft_input.AR_VS .* ST.VS_Wing_area);


%neutral point

    %sub formula

ST.wing_AR_ref = user_aircraft_TW_input.Span.^2 ./ ...
    user_ST_aircraft_input.Wing_area;

tail_lift_curve_slope = (2 .* pi .* user_ST_aircraft_input.AR_HS) ./ ...
    (2 + sqrt(4 + user_ST_aircraft_input.AR_HS.^2));

ST.wing_lift_curve_slope = (2 .* pi .* ST.wing_AR_ref) ./ ...
    (2 + sqrt(4 + ST.wing_AR_ref.^2));

Y_MAC = (user_aircraft_TW_input.Span ./ 6) .* ((1 + 2 .*...
    user_ST_aircraft_input.TR) ./ (1 + user_ST_aircraft_input.TR));

X_leading_edge_MAC = user_ST_aircraft_input.X_wing_root_LE + Y_MAC .* tand(user_aircraft_TW_input.Sweep_angle); 

%The aerodynamic center location on a 1D plane (the longitude, left to right)
ST.X_AC = X_leading_edge_MAC + 0.25 .* ST.MAC_ref;

downwash_gradient = (2 .* ST.wing_lift_curve_slope) ./ (pi .* ST.wing_AR_ref);

    %location of neutral point based on entire aircraft
ST.X_NP = ST.X_AC + user_ST_aircraft_input.tail_efficiency .* ...
    user_ST_aircraft_input.Horizontal_tail_volume_coeff .* ...
    (tail_lift_curve_slope ./ ST.wing_lift_curve_slope) .* ...
    (1 - downwash_gradient) .* ST.MAC_ref;

end



function display_ST_calc_data(ST)
disp(" ");
disp("Tail moment arm: " + ST.Tail_moment_arm);
disp("Horizontal stabilizer wing area: " + ST.HS_Wing_area);
disp("Horizontal stabilizer span: " + ST.HS_Span);
disp("Vertical stabilizer wing area: " + ST.VS_Wing_area);
disp("Vertical stabilizer span: " + ST.VS_Span);
disp("reference wing root chord: " + ST.root_chord);
disp("reference wing tip chord: " + ST.tip_chord);
disp("Neutral location located at: " + ST.X_NP);

end



function user_ST_saved = save_user_ST_aircraft(user_ST_saved, ...
    user_ST_aircraft_input, TW_aircraft_name)

user_save_option = input("Save your inputs? yes/no: ", "s");

if strcmpi(user_save_option, 'yes')

    new_aircraft.name = input("Aircraft name: ", "s");

    new_aircraft.TW_aircraft_name = TW_aircraft_name;

    new_aircraft.user_input = user_ST_aircraft_input;

    user_ST_saved(end + 1) = new_aircraft;

    save("user_ST_aircraft.mat", "user_ST_saved");

    disp("Your aircraft data has been saved");

elseif strcmpi(user_save_option, "no")

    disp("did not save aircraft data");

else

    disp("input was not yes or no");
    user_ST_saved = save_user_ST_aircraft(user_ST_saved, ...
    user_ST_aircraft_input, TW_aircraft_name);

end
end



function currState = ST_doc_options(user_TW_saved, user_ST_saved)

if isempty(user_ST_saved)

    disp("No saved stability/trim aircraft data...");
    currState = Aircraft_constraint_states.USER_TW_AIRCRAFT_MENU;
    return

end

disp("Stability and trim documents to choose are:");
disp("Title of user aircraft: " + user_TW_saved(1).name);
disp("0  - Back to last page");
disp("1  - " + user_ST_saved(1).name);
user_choice = input("Your choice: ");

switch user_choice
    
    case 0
        currState = Aircraft_constraint_states.USER_TW_AIRCRAFT_MENU;

    case 1
        currState = Aircraft_constraint_states.USER_ST_AIRCRAFT_MENU;


end
end



function [currState, user_ST_saved] = user_ST_aircraft_menu(user_ST_saved)

disp("0  - Back to last page")
disp("1  - calculate the stability/trim")
disp("2  - edit the stability/trim data");
disp("3  - View your stability/trim data");
disp("4  - get the aircraft loads data");
disp("5  - User saved aircraft loads docs");

% disp("2  - Calculate stability/trim from your saved aircraft data");
user_choice = input("Your choice: ");

switch user_choice

    case 0
        currState = Aircraft_constraint_states.SAVED_ST_AIRCRAFT_DATA;

    case 1
        currState = Aircraft_constraint_states.CALCULATE_ST_FROM_USER_ST_DATA_CALCULATION;

    case 2
        currState = Aircraft_constraint_states.EDIT_SAVED_ST_AIRCRAFT;

    case 3
        disp(user_ST_saved(1).user_input);

        currState = Aircraft_constraint_states.USER_ST_AIRCRAFT_MENU;

    case 4
        currState = Aircraft_constraint_states.GET_LOADS_AIRCRAFT_DATA;

    case 5
        currState = Aircraft_constraint_states.SAVED_LOADS_AIRCRAFT_DATA;


end
end



function user_ST_aircraft_input = edit_ST_aircraft(user_ST_aircraft_input)

disp(" 1  - Wing area");
disp(" 2  - horizontal tail volume coefficient");
disp(" 3  - vertical tail volume coefficient");
disp(" 4  - cockpit radius");
disp(" 5  - fuselage radius near the tail");
disp(" 6  - cockpit radius");
disp(" 7  - Horizontal stabilizer aspect ratio");
disp(" 8  - vertical stabilizer aspect ratio");
disp(" 9  - wing taper ratio");
disp(" 10 - Horizontal tail efficiency factor");
disp(" 11 - longitudinal location of wing root leading edge (m) from the nose being as the datum ");


user_choice = input("Your choice to edit: ");

switch user_choice

    case 1
        user_ST_aircraft_input.Wing_area = ...
            input("Wing area: ");

    case 2
        user_ST_aircraft_input.Horizontal_tail_volume_coeff = ...
            input("Horizontal tail volume coefficient: ");

    case 3
        user_ST_aircraft_input.Vertical_tail_volume_coeff = ...
            input("Vertical tail volume coefficient: ");

    case 4
        user_ST_aircraft_input.Cockpit_radius = ...
            input("Cockpit radius: ");

    case 5
        user_ST_aircraft_input.Fuselage_radius_near_tail = ...
            input("Fuselage radius near the tail: ");

    case 6
        user_ST_aircraft_input.Cockpit_radius = ...
            input("Cockpit radius: ");

    case 7
        user_ST_aircraft_input.AR_HS = ...
            input("Horizontal stabilizer aspect ratio: ");

    case 8
        user_ST_aircraft_input.AR_VS = ...
            input("Vertical stabilizer aspect ratio: ");

    case 9
        user_ST_aircraft_input.TR = ...
            input("Wing taper ratio: ");

    case 10
        user_ST_aircraft_input.tail_efficiency = ...
            input("Horizontal tail efficiency factor (0 to 1): ");

    case 11
        user_ST_aircraft_input.X_wing_root_LE = ...
            input("The longitudinal location of wing root leading edge (m): ");

    otherwise
        disp("Invalid choice");
end
end



%Loads from here on and out



function user_loads_aircraft_input = get_user_aircraft_loads_design_inputs()

disp(" ");
disp("We treat the aircraft nose as the CG datum location.");
disp("You choose if you want the aircraft to be pointed to the left or right");
disp("and then enter the distance from the nose.");
disp(" ");

% Propeller
user_loads_aircraft_input.Propeller_mass = ...
    input("Mass of propeller (kg): ");

user_loads_aircraft_input.X_propeller = input("The longitudinal location " + ...
    "of center of mass of propeller (m): ");

% Engine
user_loads_aircraft_input.Engine_mass = ...
    input("Mass of engine (kg): ");

user_loads_aircraft_input.X_engine = input("The longitudinal location " + ...
    "of center of mass of engine (m): ");

% Fuselage
user_loads_aircraft_input.Fuselage_mass = ...
    input("Mass of only the fuselage structure (kg): ");

user_loads_aircraft_input.X_fuselage = input("The longitudinal location " + ...
    "of center of mass of fuselage (m): ");

% Wing
user_loads_aircraft_input.Wing_mass = ...
    input("Mass of wing (kg): ");

user_loads_aircraft_input.X_wing = input("The longitudinal location " + ...
    "of center of mass of wing (m): ");

% Horizontal stabilizer
user_loads_aircraft_input.HS_mass = ...
    input("Mass of horizontal stabilizer (kg): ");

user_loads_aircraft_input.X_HS = input("The longitudinal location " + ...
    "of center of mass of horizontal stabilizer (m): ");

% Vertical stabilizer
user_loads_aircraft_input.VS_mass = ...
    input("Mass of vertical stabilizer (kg): ");

user_loads_aircraft_input.X_VS = input("The longitudinal location " + ...
    "of center of mass of vertical stabilizer (m): ");

% Landing gear
user_loads_aircraft_input.Landing_nose_gear_mass = ...
    input("Mass of the nose landing gear (kg): ");

user_loads_aircraft_input.X_nose_landing_gear = input("The longitudinal location " + ...
    "of center of mass of nose landing gear (m): ");

user_loads_aircraft_input.Landing_main_gear_mass = ...
    input("Mass of the main landing gear (kg): ");

user_loads_aircraft_input.X_main_landing_gear = input("The longitudinal location " + ...
    "of center of mass of main landing gear (m): ");

% Avionics
user_loads_aircraft_input.Avionics_mass = ...
    input("Mass of avionics and electrical equipment (kg): ");

user_loads_aircraft_input.X_avionics = input("The longitudinal location " + ...
    "of center of mass of avionics and electrical equipment (m): ");

% Battery
user_loads_aircraft_input.Battery_mass = ...
    input("Mass of battery (kg): ");

user_loads_aircraft_input.X_battery = input("The longitudinal location " + ...
    "of center of mass of battery (m): ");

% Fuel

%We assumed that the tanks are at the same longitudinal position, only the
%lattitude is different. However, it does not affect the CG due to the
%formula acting as a 1D problem.
user_loads_aircraft_input.Fuel_mass = ...
    input("Mass of fuel of both tanks(kg): ");

user_loads_aircraft_input.X_fuel = input("The longitudinal location " + ...
    "of center of mass of fuel (m): ");

% Pilot
user_loads_aircraft_input.Pilot_mass = ...
    input("Mass of pilot (kg): ");

user_loads_aircraft_input.X_pilot = input("The longitudinal location " + ...
    "of center of mass of pilot (m): ");

% Front passenger
user_loads_aircraft_input.Front_passenger_mass = ...
    input("Mass of front passenger (kg): ");

user_loads_aircraft_input.X_front_passenger = input("The longitudinal location " + ...
    "of center of mass of front passenger (m): ");

% Rear passengers
user_loads_aircraft_input.Rear_passenger_mass = ...
    input("Mass of rear passengers (kg): ");

user_loads_aircraft_input.X_rear_passenger = input("The longitudinal location " + ...
    "of center of mass of rear passengers (m): ");

% Baggage
user_loads_aircraft_input.Baggage_mass = ...
    input("Mass of baggage (kg): ");

user_loads_aircraft_input.X_baggage = input("The longitudinal location " + ...
    "of center of mass of baggage (m): ");

disp("The formula expects a decimal as a percentage...");
user_loads_aircraft_input.min_static_margin = input("What is the minimum " + ...
    "static margin of the aircraft: ");

%trimming the aircraft
disp(" ");
disp("This is for the forward CG limit. I recommend using XFoil or in my " + ...
    "case I use DATCOM, to find the pitching moment coefficient...");
disp(" ");
user_loads_aircraft_input.C_M_AC_TO = input("During takeoff, what is the reference wing " + ...
    "pitching moment coefficient: ");

user_loads_aircraft_input.tail_incidence = input("The tail incidence (deg): ");

user_loads_aircraft_input.wing_incidence = input("The wing incidence (deg): ");

user_loads_aircraft_input.max_elevator_up = input("The max the elevator can" + ...
    " move up: ");

user_loads_aircraft_input.elevator_efficiency = input("The efficiency of the" + ...
    " elevator (0 to 1): ");

user_loads_aircraft_input.alpha_L0_wing = input("Enter the wing " + ...
    " + zero-lift angle of attack from DATCOM (deg): ");

user_loads_aircraft_input.AoA_L0_HS = input( ...
    "Enter the horizontal tail zero-lift angle of attack from DATCOM (deg): ");

user_loads_aircraft_input.C_L_AoA_TO = input( ...
    "Enter the CLA at the takeoff AoA from DATCOM: ");

user_loads_aircraft_input.C_M_AoA_TO = input( ...
    "Enter the CMA at the takeoff AoA from DATCOM: ");

user_loads_aircraft_input.downwash_TO = ...
    input("enter EPSLON from the takeoff AoA from DATCOM (deg): ");

user_loads_aircraft_input.C_M0 = input("Full aircraft pithcing moment coeff " + ...
    "when the AoA is at 0 from DATCOM: ");

user_loads_aircraft_input.C_M_delta_e = input( ...
    "Enter the elevator pitching-moment derivative from DATCOM: ");
disp("Enter your percentage as a decimal");

user_loads_aircraft_input.limit_load_factor = input("What decimal " + ...
    "(percentage) is placed on the main gear e.g. 0.9");

user_loads_aircraft_input.gust_velocity = ...
    input("What is the vertical gust velocity (m/s): ");

user_loads_aircraft_input.gust_alt = input("What is the altitutde the " + ...
    "aircraft experiences the specific gust velocity you entered:");

user_loads_aircraft_input.velocity_aircraft_gust = input("What is the velocity of the " + ...
    "aircraft when experiencing the gust:");

user_loads_aircraft_input.touchdown_sink_rate = input("The aircraft vertical descent rate at touchdown (m/s): ");

user_loads_aircraft_input.gear_effective_stroke = input("Enter how far the tire and the ladning gear strut compresses while " + ...
    "absorbing the touchdown impact: ");

end

%/*ref are the variabels that are oringally
%from the energy based constraint anaylsis*\

function loads = calculate_loads(TW, ST, ...
    user_loads_aircraft_input, user_ST_aircraft_input, user_aircraft_TW_input)

%Variable
initial_masses = [ ...
    user_loads_aircraft_input.Propeller_mass, ...
    user_loads_aircraft_input.Engine_mass, ...
    user_loads_aircraft_input.Fuselage_mass, ...
    user_loads_aircraft_input.Wing_mass, ...
    user_loads_aircraft_input.HS_mass, ...
    user_loads_aircraft_input.VS_mass, ...
    user_loads_aircraft_input.Landing_main_gear_mass, ...
    user_loads_aircraft_input.Landing_nose_gear_mass, ...
    user_loads_aircraft_input.Avionics_mass, ...
    user_loads_aircraft_input.Battery_mass, ...
    user_loads_aircraft_input.Fuel_mass, ...
    user_loads_aircraft_input.Pilot_mass, ...
    user_loads_aircraft_input.Front_passenger_mass, ...
    user_loads_aircraft_input.Rear_passenger_mass, ...
    user_loads_aircraft_input.Baggage_mass ...
    ];

X_components = [ ...
    user_loads_aircraft_input.X_propeller, ...
    user_loads_aircraft_input.X_engine, ...
    user_loads_aircraft_input.X_fuselage, ...
    user_loads_aircraft_input.X_wing, ...
    user_loads_aircraft_input.X_HS, ...
    user_loads_aircraft_input.X_VS, ...
    user_loads_aircraft_input.X_main_landing_gear, ...
    user_loads_aircraft_input.X_nose_landing_gear, ...
    user_loads_aircraft_input.X_avionics, ...
    user_loads_aircraft_input.X_battery, ...
    user_loads_aircraft_input.X_fuel, ...
    user_loads_aircraft_input.X_pilot, ...
    user_loads_aircraft_input.X_front_passenger, ...
    user_loads_aircraft_input.X_rear_passenger, ...
    user_loads_aircraft_input.X_baggage ...
    ];


% CG_datum_nose = 0;

total_mass = sum(initial_masses);

% The longitudinal CG datum location at the aircraft nose (1D)
loads.X_CG = sum(initial_masses .* X_components) ./ total_mass;


%Static margin
loads.static_margin = -user_loads_aircraft_input.C_M_AoA_TO ./ ...
    user_loads_aircraft_input.C_L_AoA_TO;

%Neautral point ()
loads.X_NP = loads.X_CG + loads.static_margin .* ST.MAC_ref;

%AFT CG limit
%in my notes I have the static margin as the minimum and will need to find
%values that representt our aircraft. 
loads.AFT_X_CG = loads.X_NP - user_loads_aircraft_input.min_static_margin .* ST.MAC_ref;


downwash_TO = deg2rad( ...
    user_loads_aircraft_input.downwash_TO);

AoA_L0_ref_wing = deg2rad(user_loads_aircraft_input.alpha_L0_wing);

AoA_L0_HS = deg2rad(user_loads_aircraft_input.AoA_L0_HS);

tail_incidence = deg2rad(user_loads_aircraft_input.tail_incidence);

wing_incidence = deg2rad(user_loads_aircraft_input.wing_incidence);



loads.wing_pitching_moment = user_loads_aircraft_input.C_M_AC_TO.* TW.q_TO .* ...
    user_ST_aircraft_input.Wing_area .* ST.MAC_ref;

%location of the tails aerodynamic center
X_tail_AC = ST.X_AC + ST.Tail_moment_arm;


%I realized its better to defvleop the lift coefficient from the tail AoA
%and elevator deflection rather than asking the user because this can cause
%inconsistencies in the values of the geometry, downwash, and the elevator
%position.

%tells us how much the horizontal stabilier lift coeff changes when the AoA
%changes
tail_lift_curve_slope = (2 .* pi .* user_ST_aircraft_input.AR_HS) ./ ...
    (2 + sqrt(4 + user_ST_aircraft_input.AR_HS.^2));

%tells us how much the reference wing lift coeff changes when the AoA
%changes
wing_lift_curve_slope = (2 .* pi .* ST.wing_AR_ref) ./ ...
    (2 + sqrt(4 + ST.wing_AR_ref.^2));

tail_force = 1;

for updated_tail_force = 1:100

    tail_force_old = tail_force;

    wing_ref_lift_required_TO = TW.Weight_TO - tail_force;

    C_L_ref_wing = wing_ref_lift_required_TO ./ ...
        (TW.q_TO .* user_ST_aircraft_input.Wing_area);
    
    AoA_wing_TO = AoA_L0_ref_wing + ...
    C_L_ref_wing ./ wing_lift_curve_slope;

    %The AoA that is required to takeoff
    AoA_TO = AoA_wing_TO - wing_incidence;
    
    %How strong the angle of the wings downwash changes which is the turning of
    %the airflow behind the wing
    
    %The AoA the horizontal stabilizer is experiencing
    AoA_HS = AoA_TO + tail_incidence - downwash_TO;
    
    %elevator angle we test the forward cg limit
    delta_e_forward_CG = -deg2rad(user_loads_aircraft_input.max_elevator_up);
    
    %The lift coeff for the forward CG when calculating the downard tial force
    C_L_tail_forward = tail_lift_curve_slope .* ...
        (AoA_HS - AoA_L0_HS + ...
        user_loads_aircraft_input.elevator_efficiency .* delta_e_forward_CG);
    
    %the tail downforce
    tail_force = user_ST_aircraft_input.tail_efficiency .* ...
        TW.q_TO .* ST.HS_Wing_area .* C_L_tail_forward;

    if abs(tail_force - tail_force_old) < 0.0001
        break
    end
end

wing_ref_lift_required_TO = TW.Weight_TO - tail_force;

%FOR. CG limit calculation
loads.forward_X_CG = (ST.X_AC .* wing_ref_lift_required_TO + ...
   tail_force .* X_tail_AC - loads.wing_pitching_moment) ./ ...
   (wing_ref_lift_required_TO + tail_force);

%CG range
loads.CG_range = loads.AFT_X_CG - loads.forward_X_CG;

%Longitudinal trim
loads.elevator_deflection_trimmed = -(user_loads_aircraft_input.C_M0 + ...
    user_loads_aircraft_input.C_M_AoA_TO .* rad2deg(AoA_TO)) ./ ...
    user_loads_aircraft_input.C_M_delta_e;



%Control/Elevator authority
%/*Basically asking can the elevator generate 
% eneough pitching moment at this CG moment*\

%limit load, this answers what load can the aircraft handle before breaking

loads.limit_load_force = user_loads_aircraft_input.limit_load_factor .* ...
    TW.Weight_TO;

%ultimate load

loads.ult_load_factor = 1.5 .* user_loads_aircraft_input.limit_load_factor;

loads.ult_load_force = 1.5 .* loads.limit_load_force;

if TW.update_load_factor > user_loads_aircraft_input.limit_load_factor

    disp(" ");
    disp("Error: the load factor of the aircraft while turning exceeds ")
    disp("the limit load factor... RECOMENDATION: edit your limit factor from")
    disp("the turn load factor if you are trying to have the bare minimum of a limit factor");
    disp(" ");

end

if TW.update_load_factor > loads.ult_load_factor

    disp(" ");
    disp("Error: the load factor of the aircraft while turning drastically exceeds ")
    disp("the limit load factor... RECOMENDATION: edit your limit factor from")
    disp("the turn load factor if you are trying to have the bare minimum of a limit factor");
    disp(" ");

end


%Gust loads, vertical gust changes load factor

%intial variables

Gravity = 9.80665;

%sub calc beforehand

rho_gust = altitude_find_rho(user_loads_aircraft_input.gust_alt);

Wing_loading = TW.Weight_TO ./ user_ST_aircraft_input.Wing_area;

%The aircraft mass ratio for the gust when responding to it
loads.mu_g = (2 .* Wing_loading ) ./ (rho_gust .* ST.MAC_ref .* ...
    ST.wing_lift_curve_slope .* Gravity);

loads.gust_alleviation_factor = (0.88 .* loads.mu_g) ./ (5.3 + loads.mu_g);

%the gust load factor
loads.delta_load_factor = (loads.gust_alleviation_factor .* rho_gust .* ...
    user_loads_aircraft_input.velocity_aircraft_gust .* ...
    user_loads_aircraft_input.gust_velocity .* ST.wing_lift_curve_slope) ... 
    ./ (2 .* Wing_loading);

loads.total_load_factor_pos = 1 + loads.delta_load_factor;

loads.total_load_factor_neg = 1 - loads.delta_load_factor;

%which is larger, the limit factor or the total load factor from the gust
loads.wing_load_factor = max(TW.update_load_factor, ...
    loads.total_load_factor_pos);

%Wing bending moment

loads.moment_ref_wing_root = ( loads.wing_load_factor .* TW.Weight_TO .* ...
    user_aircraft_TW_input.Span) ./ 8;

% Landing gear vertical factor when the wheels touch the ground

%I need to delete the percentage of weight due to already having accurate
%information of the weight on the nose and main gear

%The nose gear loading factor
loads.landing_load_factor = 1 + ...
    (user_loads_aircraft_input.touchdown_sink_rate.^2) ./ ...
    (2 .* Gravity .* user_loads_aircraft_input.gear_effective_stroke);

%Only just the distance between nose and main landing gear on a 1D plane
loads.wheelbase = ...
    user_loads_aircraft_input.X_main_landing_gear - ...
    user_loads_aircraft_input.X_nose_landing_gear;

%I need to delete the percentage of weight due to already having accurate
%information from the user about the location and mass thus I can get the
%percentage of the aircraft load that is carried by bth main gear
%information of the weight on the nose and main gear
loads.main_weight_factor = ...
    (loads.X_CG - user_loads_aircraft_input.X_nose_landing_gear) ./ ...
    loads.wheelbase;

%Actually part of the fraction of the aricraft vertical load that is
%carried byt the nose gear
loads.nose_weight_factor = ...
    (user_loads_aircraft_input.X_main_landing_gear - loads.X_CG) ./ ...
    loads.wheelbase;


%The reaction is the force the ground pushes back on the landing gears. The
%upward force is the ground reaciton force
loads.main_gear_reaction_factor = ...
    loads.main_weight_factor .* loads.landing_load_factor;
    %same for nose landing gear
loads.nose_gear_reaction_factor = loads.nose_weight_factor .* ...
    loads.landing_load_factor;


%The total force of the vert landing gear from touching down
loads.landing_gear_vert_load = loads.landing_load_factor .* TW.Weight_TO;

%Force carried by BOTH main gears
loads.Force_main_landing_gear_both = loads.main_weight_factor .* ...
    loads.landing_gear_vert_load;

%Now the force carried by each landing gear

loads.Force_main_landing_gear_each = loads.Force_main_landing_gear_both ./ 2;

%Force carried by nose landing gear
loads.Force_nose_landing_gear = loads.nose_gear_load_factor .* TW.Weight_TO;

end



function display_loads_calc_data(loads)
disp(" ");
disp(loads);

end



function user_loads_saved = save_user_loads_aircraft(user_loads_saved, ...
    user_loads_aircraft_input, ST_aircraft_name)

user_save_option = input("Save your inputs? yes/no: ", "s");

if strcmpi(user_save_option, 'yes')

    new_aircraft.name = input("Aircraft name: ", "s");

    new_aircraft.ST_aircraft_name = ST_aircraft_name;

    new_aircraft.user_input = user_loads_aircraft_input;

    user_loads_saved(end + 1) = new_aircraft;

    save("user_loads_aircraft.mat", "user_loads_saved");

    disp("Your aircraft data has been saved");

elseif strcmpi(user_save_option, "no")

    disp("did not save aircraft data");

else

    disp("input was not yes or no");
    user_loads_saved = save_user_loads_aircraft(user_loads_saved, ...
    user_loads_aircraft_input, ST_aircraft_name);

end
end



function currState = loads_doc_options(user_ST_saved, user_loads_saved)

if isempty(user_loads_saved)

    disp("No saved  aircraft loads data...");
    currState = Aircraft_constraint_states.USER_ST_AIRCRAFT_MENU;
    return

end

disp("aircraft loads documents to choose are:");
disp("Title of user aircraft: " + user_ST_saved(1).name);
disp("0  - Back to last page");
disp("1  - " + user_loads_saved(1).name);
user_choice = input("Your choice: ");

switch user_choice
    
    case 0
        currState = Aircraft_constraint_states.USER_ST_AIRCRAFT_MENU;

    case 1
        currState = Aircraft_constraint_states.USER_LOADS_AIRCRAFT_MENU;


end
end



function [currState, user_loads_saved] = user_loads_aircraft_menu(user_loads_saved)

disp("0  - Back to last page");
disp("1  - calculate the aircraft loads");
disp("2  - edit the aircraft loads data");
disp("3  - View your aircraft loads data");

user_choice = input("Your choice: ");

switch user_choice

    case 0
        currState = Aircraft_constraint_states.SAVED_LOADS_AIRCRAFT_DATA;

    case 1
        currState = Aircraft_constraint_states.CALCULATE_LOADS_FROM_USER_LOADS_DATA_CALCULATION;

    case 2
        currState = Aircraft_constraint_states.EDIT_SAVED_LOADS_AIRCRAFT;

    case 3
        disp(user_loads_saved(1).user_input);

        currState = Aircraft_constraint_states.USER_LOADS_AIRCRAFT_MENU;

end
end



function user_loads_aircraft_input = edit_loads_aircraft(user_loads_aircraft_input)

disp("1  - Propeller mass");
disp("2  - Propeller X location");
disp("3  - Engine mass");
disp("4  - Engine X location");
disp("5  - Fuselage mass");
disp("6  - Fuselage X location");
disp("7  - Wing mass");
disp("8  - Wing X location");
disp("9  - Horizontal stabilizer mass");
disp("10 - Horizontal stabilizer X location");
disp("11 - Vertical stabilizer mass");
disp("12 - Vertical stabilizer X location");
disp("13 - Nose landing gear mass");
disp("14 - Nose landing gear X location");
disp("15 - Main landing gear mass");
disp("16 - Main landing gear X location");
disp("17 - Avionics mass");
disp("18 - Avionics X location");
disp("19 - Battery mass");
disp("20 - Battery X location");
disp("21 - Fuel mass");
disp("22 - Fuel X location");
disp("23 - Pilot mass");
disp("24 - Pilot X location");
disp("25 - Front passenger mass");
disp("26 - Front passenger X location");
disp("27 - Rear passenger mass");
disp("28 - Rear passenger X location");
disp("29 - Baggage mass");
disp("30 - Baggage X location");
disp("31 - Minimum static margin");
disp("32 - Wing pitching moment coefficient C_M_AC_TO");
disp("33 - Horizontal tail incidence");
disp("34 - Wing incidence");
disp("35 - Maximum elevator up deflection");
disp("36 - Elevator efficiency");
disp("37 - Wing zero-lift angle of attack");
disp("38 - Horizontal tail zero-lift angle of attack");
disp("39 - DATCOM CLA at takeoff AoA");
disp("40 - DATCOM CMA at takeoff AoA");
disp("41 - DATCOM downwash EPSLON at takeoff AoA");
disp("42 - Full aircraft pitching moment coefficient at zero AoA");
disp("43 - Elevator pitching-moment derivative");
disp("44 - Structural limit load factor");
disp("45 - Vertical gust velocity");
disp("46 - Gust altitude");
disp("47 - Aircraft velocity during gust");
disp("48 - Touchdown sink rate");
disp("49 - Landing gear effective stroke");
user_choice = input("Your choice to edit: ");

switch user_choice

    case 1
        user_loads_aircraft_input.Propeller_mass = input("Mass of propeller (kg): ");

    case 2
        user_loads_aircraft_input.X_propeller = ...
            input("Propeller center of mass X location (m): ");


    case 3
        user_loads_aircraft_input.Engine_mass = input("Mass of engine (kg): ");

    case 4
        user_loads_aircraft_input.X_engine = ...
            input("Engine center of mass X location (m): ");


    case 5
        user_loads_aircraft_input.Fuselage_mass = ...
            input("Mass of fuselage structure (kg): ");

    case 6
        user_loads_aircraft_input.X_fuselage = ...
            input("Fuselage center of mass X location (m): ");


    case 7
        user_loads_aircraft_input.Wing_mass = ...
            input("Mass of wing (kg): ");

    case 8
        user_loads_aircraft_input.X_wing = ...
            input("Wing center of mass X location (m): ");


    case 9
        user_loads_aircraft_input.HS_mass = ...
            input("Mass of horizontal stabilizer (kg): ");

    case 10
        user_loads_aircraft_input.X_HS = ...
            input("Horizontal stabilizer center of mass X location (m): ");


    case 11
        user_loads_aircraft_input.VS_mass = ...
            input("Mass of vertical stabilizer (kg): ");

    case 12
        user_loads_aircraft_input.X_VS = ...
            input("Vertical stabilizer center of mass X location (m): ");


    case 13
        user_loads_aircraft_input.Landing_nose_gear_mass = ...
            input("Mass of nose landing gear (kg): ");

    case 14
        user_loads_aircraft_input.X_nose_landing_gear = ...
            input("Nose landing gear center of mass X location (m): ");


    case 15
        user_loads_aircraft_input.Landing_main_gear_mass = ...
            input("Mass of main landing gear (kg): ");

    case 16
        user_loads_aircraft_input.X_main_landing_gear = ...
            input("Main landing gear center of mass X location (m): ");


    case 17
        user_loads_aircraft_input.Avionics_mass = ...
            input("Mass of avionics and electrical equipment (kg): ");

    case 18
        user_loads_aircraft_input.X_avionics = ...
            input("Avionics center of mass X location (m): ");


    case 19
        user_loads_aircraft_input.Battery_mass = input("Mass of battery (kg): ");

    case 20
        user_loads_aircraft_input.X_battery = ...
            input("Battery center of mass X location (m): ");


    case 21
        user_loads_aircraft_input.Fuel_mass = ...
            input("Mass of fuel in both tanks (kg): ");

    case 22
        user_loads_aircraft_input.X_fuel = ...
            input("Fuel center of mass X location (m): ");


    case 23
        user_loads_aircraft_input.Pilot_mass = input("Mass of pilot (kg): ");

    case 24
        user_loads_aircraft_input.X_pilot = ...
            input("Pilot center of mass X location (m): ");


    case 25
        user_loads_aircraft_input.Front_passenger_mass = ...
            input("Mass of front passenger (kg): ");

    case 26
        user_loads_aircraft_input.X_front_passenger = ...
            input("Front passenger center of mass X location (m): ");


    case 27
        user_loads_aircraft_input.Rear_passenger_mass = ...
            input("Mass of rear passengers (kg): ");

    case 28
        user_loads_aircraft_input.X_rear_passenger = ...
            input("Rear passenger center of mass X location (m): ");


    case 29
        user_loads_aircraft_input.Baggage_mass = input("Mass of baggage (kg): ");

    case 30
        user_loads_aircraft_input.X_baggage = ...
            input("Baggage center of mass X location (m): ");


    case 31
        user_loads_aircraft_input.min_static_margin = ...
            input("What is the minimum static margin of the aircraft: ");

    case 32
        user_loads_aircraft_input.C_M_AC_TO = input("During takeoff, what is " + ...
            "the reference wing pitching moment coefficient: ");

    case 33
        user_loads_aircraft_input.tail_incidence = input( ...
            "The tail incidence (deg): ");

    case 34
        user_loads_aircraft_input.wing_incidence = input( ...
            "The wing incidence (deg): ");

    case 35
        user_loads_aircraft_input.max_elevator_up = input("The max the " + ...
            "elevator can move up: ");

    case 36
        user_loads_aircraft_input.elevator_efficiency = input( ...
            "The efficiency of the elevator (0 to 1): ");

    case 37
        user_loads_aircraft_input.alpha_L0_wing = input( ...
            "Enter the wing zero-lift angle of attack from DATCOM (deg): ");

    case 38
        user_loads_aircraft_input.AoA_L0_HS = input( ...
            "Enter the horizontal tail zero-lift angle of attack from " + ...
            "DATCOM (deg): ");

    case 39
        user_loads_aircraft_input.C_L_AoA_TO = input( ...
            "Enter the CLA at the takeoff AoA from DATCOM: ");

    case 40
        user_loads_aircraft_input.C_M_AoA_TO = input( ...
            "Enter the CMA at the takeoff AoA from DATCOM: ");

    case 41
        user_loads_aircraft_input.downwash_TO = input( ...
            "Enter EPSLON from the takeoff AoA from DATCOM (deg): ");

    case 42
        user_loads_aircraft_input.C_M0 = input( ...
            "Full aircraft pitching moment coeff when the AoA is at 0 " + ...
            "from DATCOM: ");

    case 43
        user_loads_aircraft_input.C_M_delta_e = input( ...
            "Enter the elevator pitching-moment derivative from DATCOM: ");

    case 44
        user_loads_aircraft_input.limit_load_factor = ...
            input("Enter the aircraft structural limit load factor (g): ");


    case 45
        user_loads_aircraft_input.gust_velocity = ...
            input("What is the vertical gust velocity (m/s): ");


    case 46
        user_loads_aircraft_input.gust_alt = ...
            input("What is the altitude where the aircraft experiences the gust (m): ");


    case 47
        user_loads_aircraft_input.velocity_aircraft_gust = ...
            input("What is the aircraft velocity when experiencing the gust: ");


    case 48
        user_loads_aircraft_input.touchdown_sink_rate = ...
            input("The aircraft vertical descent rate at touchdown (m/s): ");


    case 49
        user_loads_aircraft_input.gear_effective_stroke = ...
            input("How far the tire and landing gear strut compress during touchdown (m): ");

    otherwise
        disp("Invalid choice");
end
end


%Goals for impropvement for accuracy in the future:

%Performance verification will be updated in version 2...

    %Based on a rectangular wing, i would like to add an option for the
% In the get stability/trim seleciton, user to add their own Mac_ref if 
% they would want to and the option to calulate a swept wing with any type 
% of curvature from the wing tips in the get stability/trim

% In the find T/W selection, have the Weight change each moment for 
% calculation due to the weight from fuel constantly changing in each phase
% of the find T/W

%In the get stability/trim seleciton, if the user already knows their horiz
%and vert tail area and they want to know what htye want for the tial
%moment arm, then calaculate that based on the standard tail volume
%coefficients to find that (I chose to start with the user having an idea of
%  what their aircraft is and choose a tail volume coefficients off of what
%  they want. To calculate the tail moment arm and soon later the tail
%  horizontal area)

%For an accurate CG we can get more detialeid in the weight and location of
%the avionics, the fuel (if located in two different longitude positions),



%For further updates for adding accuracy calculate/ask user these values:

%Wing airfoil
%Horizontal tail airfoil
%wing dihedral
%wing twist
%wing vertical location
%fuselage length
%maximium fuselage radius (Could be the cockpit radius that we asked user)
%tail region radius
%fuselage radii between the cockpit and tail radii to create body shape
%Horizontal tail taper ratio
%Horizontal tail LE sweep
%horizontal tail root leading edge

%Get output from DATCOM for ease and accuracy of forward XCG due to the 
% elvator deflect and efficency depending on that thus these need to be
% calculated in DATCOM:
    %maximmum elevator up defleciton
    %elevator efficiency
    %C_M_delta_E pithcing moment coeff per def of the elevator deflection
