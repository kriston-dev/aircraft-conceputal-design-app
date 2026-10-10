package com.kriston.test1;

import java.util.Scanner;

//Remove this when going to add graphto app, we might use this
/* 
import org.knowm.xchart.SwingWrapper;
import org.knowm.xchart.XYChart;
import org.knowm.xchart.XYChartBuilder;

*/

public class master {

    static TWAircraftInput user_aircraft_TW_input = new TWAircraftInput();
    static SavedTWAircraft[] user_TW_saved = new SavedTWAircraft[0];
    static twResults TW;

    public enum Aircraft_constraint_states {

        MAIN_MENU,

        SAVED_TW_AIRCRAFT_DATA,
        USER_TW_AIRCRAFT_MENU,
        EDIT_SAVED_TW_AIRCRAFT,
        GET_TW_AIRCRAFT_DATA,
        CALCULATE_TW,
        GRAPH_TW,
        CALCULATE_TW_FROM_USER_TW_DATA_CALCULATION,
        GRAPH_TW_FROM_USER_TW_DATA_CALCULATION
        /*
         * GET_ST_AIRCRAFT_DATA,
         * CALCULATE_ST,
         * DISPLAY_ST,
         * SAVED_ST_AIRCRAFT_DATA,
         * USER_ST_AIRCRAFT_MENU,
         * DISPLAY_TW_FROM_USER_ST_AIRCRAFT_MENU,
         * EDIT_SAVED_ST_AIRCRAFT,
         * CALCULATE_ST_FROM_USER_ST_DATA_CALCULATION,
         * DISPLAY_ST_FROM_USER_ST_DATA_CALCULATION,
         * 
         * GET_LOADS_AIRCRAFT_DATA,
         * CALCULATE_LOADS,
         * DISPLAY_LOADS,
         * SAVED_LOADS_AIRCRAFT_DATA,
         * USER_LOADS_AIRCRAFT_MENU,
         * CALCULATE_LOADS_FROM_USER_LOADS_DATA_CALCULATION,
         * DISPLAY_LOADS_FROM_USER_LOADS_DATA_CALCULATION,
         * EDIT_SAVED_LOADS_AIRCRAFT,
         * 
         * ERROR_STATE // need to create//
         */
    }

    public static void main(String[] args) {

        while (true) {
            switch (App.currState) {

                // This is the main page
                case MAIN_MENU:
                    App.currState = user_state();
                    break;

                // This shows the user T/W saved aircraft data names
                case SAVED_TW_AIRCRAFT_DATA:
                    App.currState = doc_options(user_TW_saved);
                    break;

                // This shows the menu of the specific T/W aircraft the user chose
                case USER_TW_AIRCRAFT_MENU:
                    user_aircraft_TW_input = user_TW_saved[0].user_input;

                    // [App.currState, user_TW_saved] = user_TW_aircraft_menu(user_TW_saved);
                    break;

                // This edits the user specific T/W aircraft data that they chose
                case EDIT_SAVED_TW_AIRCRAFT:
                    user_aircraft_TW_input = user_TW_saved[0].user_input;

                    user_aircraft_TW_input = edit_TW_aircraft(user_aircraft_TW_input);

                    user_TW_saved[0].user_input = user_aircraft_TW_input;

                    // save("user_TW_aircraft.mat", "user_TW_saved");

                    System.out.println("Data has been saved...");

                    App.currState = Aircraft_constraint_states.USER_TW_AIRCRAFT_MENU;
                    break;

                // This asks the user for T/W aircraft data
                case GET_TW_AIRCRAFT_DATA:
                    user_aircraft_TW_input = get_user_aircraft_design_inputs();

                    App.currState = Aircraft_constraint_states.CALCULATE_TW;

                    break;

                // This calculates what the user entered from getting the T/W aircraft data

                case CALCULATE_TW:
                    // user_aircraft_TW_input_loads = user_aircraft_TW_input;

                    // user_aircraft_TW_input_loads.Wing_area = user_ST_aircraft_input.Wing_area;

                    TW = calculate_TW_constraints(user_aircraft_TW_input);

                    App.currState = Aircraft_constraint_states.GRAPH_TW;

                    break;

                // This graphs what the calculation gave from getting the T/W aircraft data
                case GRAPH_TW:
                    display_TW(TW);
                    // user_TW_saved = save_user_aircraft(user_TW_saved, user_aircraft_TW_input);
                    App.currState = Aircraft_constraint_states.MAIN_MENU;
                    // disp(user_TW_saved(1).user_input);

                    break;

                // This calculates what the user T/W aircraft data entered from getting the
                // aircraft data
                case CALCULATE_TW_FROM_USER_TW_DATA_CALCULATION:
                    TW = calculate_TW_constraints(user_aircraft_TW_input);

                    App.currState = Aircraft_constraint_states.GRAPH_TW_FROM_USER_TW_DATA_CALCULATION;
                    break;

                /*
                 * This graphs the calculation that was recieved from the user T/W
                 * aircraft data file
                 */ case GRAPH_TW_FROM_USER_TW_DATA_CALCULATION:
                    display_TW(TW);

                    App.currState = Aircraft_constraint_states.SAVED_TW_AIRCRAFT_DATA;

                    break;
            }
        }
    }

    public static Aircraft_constraint_states user_state() {

        System.out.println("Choose from the following options:");
        System.out.println(" - Find T/W");
        System.out.println(" - T/W docs");

        Scanner scan = new Scanner(System.in);
        scan.close();

        System.out.println("My choice is: ");
        String user_path = scan.nextLine();

        scan.close();

        if (user_path.equals("Find T/W")) {
            return Aircraft_constraint_states.GET_TW_AIRCRAFT_DATA;
        }

        else if (user_path.equals("T/W docs")) {
            return Aircraft_constraint_states.SAVED_TW_AIRCRAFT_DATA;
        }

        else {
            System.out.println("Invalid choice");
            return Aircraft_constraint_states.MAIN_MENU;
        }

        /*
         * Need to finish function that gathers data from the user
         * // before starting the calculation of the aircraft T/W.*\
         * 
         * // function TW = found_TW()
         * 
         * // TW = 3;
         * // end
         */
    }

    public static Aircraft_constraint_states doc_options(SavedTWAircraft[] user_TW_saved) {

        int user_input;

        Scanner scan = new Scanner(System.in);

        if (user_TW_saved.length == 0) {
            System.out.println("No saved T/W aircraft data...");
            return Aircraft_constraint_states.MAIN_MENU;
        }

        System.out.println("0  - Back to the last page");
        System.out.println("1  - user's " + user_TW_saved[0].name);

        System.out.println("your choice: ");
        user_input = scan.nextInt();
        scan.close();

        switch (user_input) {

            case 0:
                return Aircraft_constraint_states.MAIN_MENU;

            case 1:
                return Aircraft_constraint_states.USER_TW_AIRCRAFT_MENU;

            default:
                return Aircraft_constraint_states.SAVED_TW_AIRCRAFT_DATA;
        }
    }

    public static TWAircraftInput edit_TW_aircraft(TWAircraftInput user_aircraft_TW_input) {

        int edit;

        Scanner scan = new Scanner(System.in);

        System.out.println("Choose what aircraft input you want to change:");
        System.out.println("1  - Engine power (HP)");
        System.out.println("2  - Wing span");
        System.out.println("3  - Wing area");
        System.out.println("4  - Wing sweep angle");

        System.out.println("5  - Aircraft mass without wing skin");
        System.out.println("6  - Wing material density");
        System.out.println("7  - Wing skin thickness");

        System.out.println("8  - Minimum drag coefficient C_Dmin");
        System.out.println("9  - Lift coefficient at minimum drag C_Lmin");
        System.out.println("10 - Maximum takeoff lift coefficient C_Lmax_TO");

        System.out.println("11 - Takeoff ground roll distance");
        System.out.println("12 - Takeoff stall-speed factor K_TO");
        System.out.println("13 - Rolling friction coefficient");
        System.out.println("14 - Takeoff propeller efficiency");
        System.out.println("15 - Takeoff altitude");

        System.out.println("16 - Fuel used before/during takeoff");
        System.out.println("17 - Fuel mass per gallon");

        System.out.println("18 - Required climb rate");
        System.out.println("19 - Climb velocity");
        System.out.println("20 - Climb altitude");

        System.out.println("21 - Cruise velocity");
        System.out.println("22 - Cruise altitude");

        System.out.println("23 - Turn radius");
        System.out.println("24 - Turn altitude");
        System.out.println("25 - Turn max lift coefficient C_Lmax_turn");
        System.out.println("26 - Turn stall-speed factor K_turn");

        System.out.println("27 - Horizontal acceleration velocity");
        System.out.println("28 - Required horizontal acceleration");
        System.out.println("29 - Horizontal acceleration altitude");

        System.out.println("30 - Approach velocity");
        System.out.println("31 - Approach stall-speed factor K_approach");
        System.out.println("32 - Maximum approach lift coefficient C_Lmax_approach");
        System.out.println("33 - Approach altitude");

        System.out.println("Choose number: ");
        edit = scan.nextInt();

        switch (edit) {

            case 1:
                System.out.println("Engine power (HP): ");
                user_aircraft_TW_input.Engine_power_HP = scan.nextInt();
                scan.close();
                break;
            /*
             * case 2:
             * user_aircraft_TW_input.Span = input("Wing span (m): ");
             * break;
             * 
             * case 3:
             * user_aircraft_TW_input.Wing_area_raw = input("Wing area (m^2): ");
             * break;
             * 
             * user_aircraft_TW_input.Wing_area_final = ...
             * user_aircraft_TW_input.Wing_area_raw 2;
             * break;
             * 
             * user_aircraft_TW_input.Wing_area = user_aircraft_TW_input.Wing_area_raw:...
             * 0.1:user_aircraft_TW_input.Wing_area_final;
             * break;
             * 
             * case 4:
             * user_aircraft_TW_input.Sweep_angle = ...
             * input("Wing sweep angle (deg): ");
             * break;
             * 
             * 
             * case 5:
             * user_aircraft_TW_input.Mass_without_wing_skin = ...
             * input("Aircraft mass without wing skin (kg): ");
             * break;
             * 
             * case 6:
             * user_aircraft_TW_input.Wing_material_density = ...
             * input("Wing material density (kg/m^3): ");
             * break;
             * 
             * case 7:
             * user_aircraft_TW_input.Wing_skin_thickness = ...
             * input("Wing skin thickness (m): ");
             * break;
             * 
             * 
             * case 8:
             * user_aircraft_TW_input.C_Dmin = ...
             * input("Minimum drag coefficient C_Dmin: ");
             * break;
             * 
             * case 9:
             * user_aircraft_TW_input.C_Lmin = ...
             * input("Lift coefficient at minimum drag C_Lmin: ");
             * break;
             * 
             * case 10:
             * user_aircraft_TW_input.C_Lmax_TO = ...
             * input("Maximum takeoff lift coefficient C_Lmax_TO: ");
             * break;
             * 
             * 
             * case 11:
             * user_aircraft_TW_input.S_G = ...
             * input("Takeoff ground roll distance (m): ");
             * break;
             * 
             * case 12:
             * user_aircraft_TW_input.K_TO = ...
             * input("Takeoff stall-speed safety factor K_TO: ");
             * break;
             * 
             * case 13:
             * user_aircraft_TW_input.Rolling_friction_coefficient = ...
             * input("Rolling friction coefficient: ");
             * break;
             * 
             * case 14:
             * user_aircraft_TW_input.Propeller_efficiency_TO = ...
             * input("Takeoff propeller efficiency: ");
             * break;
             * 
             * case 15:
             * user_aircraft_TW_input.altitude_TO = ...
             * input("Takeoff altitude (m): ");
             * break;
             * 
             * 
             * case 16:
             * user_aircraft_TW_input.Fuel_spent_ground_to_TO = ...
             * input("Fuel used before/during takeoff (gal): ");
             * break;
             * 
             * case 17:
             * user_aircraft_TW_input.Fuel_mass_per_gallon = ...
             * input("Fuel mass per gallon (kg/gal): ");
             * break;
             * 
             * 
             * case 18:
             * user_aircraft_TW_input.rate_of_climb = ...
             * input("Required climb rate: ");
             * break;
             * 
             * case 19:
             * user_aircraft_TW_input.velocity_climb = ...
             * input("Climb velocity (knots): ");
             * 
             * case 20:
             * user_aircraft_TW_input.altitude_climb = ...
             * input("Climb constraint altitude (m): ");
             * break;
             * 
             * 
             * case 21:
             * user_aircraft_TW_input.velocity_cruise = ...
             * input("Cruise velocity (knots): ");
             * break;
             * 
             * case 22:
             * user_aircraft_TW_input.altitude_cruise = ...
             * input("Cruise altitude (m): ");
             * break;
             * 
             * 
             * case 23:
             * user_aircraft_TW_input.radius_turn = ...
             * input("Turn radius (m): ");
             * break;
             * 
             * case 24:
             * user_aircraft_TW_input.altitude_turn = ...
             * input("Turn altitude (m): ");
             * break;
             * 
             * case 25:
             * user_aircraft_TW_input.C_Lmax_turn = ...
             * input("Turn max lift coefficient: ");
             * break;
             * 
             * case 26:
             * user_aircraft_TW_input.K_turn = ...
             * input("Turn stall-speed safety factor K_turn: ");
             * break;
             * 
             * case 27:
             * user_aircraft_TW_input.velocity_accel = ...
             * input("Horizontal acceleration velocity (knots): ");
             * break;
             * 
             * case 28:
             * user_aircraft_TW_input.accel_horiz = ...
             * input("Required horizontal acceleration (m/s^2): ");
             * break;
             * 
             * case 29:
             * user_aircraft_TW_input.altitude_horiz_accel = ...
             * input("Horizontal acceleration altitude (m): ");
             * break;
             * 
             * case 30:
             * user_aircraft_TW_input.velocity_approach = ...
             * input("Approach velocity (knots): ");
             * break;
             * 
             * case 31:
             * user_aircraft_TW_input.K_approach = ...
             * input("Approach stall-speed safety factor K_approach: ");
             * break;
             * 
             * case 32:
             * user_aircraft_TW_input.C_Lmax_approach = ...
             * input("Maximum approach lift coefficient C_Lmax_approach: ");
             * break;
             * 
             * case 33:
             * user_aircraft_TW_input.altitude_approach = ...
             * input("Approach altitude (m): ");
             * break;
             */
            default:
                System.out.println("Invalid choice");
                break;
        }

        return user_aircraft_TW_input;

    }

    public static TWAircraftInput get_user_aircraft_design_inputs() {

        Scanner scan = new Scanner(System.in);

        // user_aircraft_TW_input.
        // Will add more once organized all the user inputs and can add

        // Ask user about:

        // Aircraft geometry / design

        System.out.println("Engine power (HP): ");
        user_aircraft_TW_input.Engine_power_HP = scan.nextInt();

        /*
         * user_aircraft_TW_input.Span = input("Wing span (m): ");
         * 
         * user_aircraft_TW_input.Wing_area_raw = input("Wing area (m^2): ");
         * 
         * user_aircraft_TW_input.Sweep_angle = input("Wing sweep angle (deg): ");
         * 
         * 
         * // Aircraft mass / material assumptions
         * 
         * user_aircraft_TW_input.Mass_without_wing_skin = ...
         * input("Aircraft mass without wing skin (kg): ");
         * 
         * user_aircraft_TW_input.Wing_material_density = ...
         * input("Wing material density (kg/m^3): ");
         * 
         * user_aircraft_TW_input.Wing_skin_thickness = ...
         * input("Wing skin thickness (m): ");
         * 
         * 
         * // Aerodynamic assumptions
         * 
         * user_aircraft_TW_input.C_Dmin = input("Minimum drag coefficient C_Dmin: ");
         * 
         * user_aircraft_TW_input.C_Lmin = ...
         * input("Lift coefficient at minimum drag C_Lmin: ");
         * 
         * user_aircraft_TW_input.C_Lmax_TO = ...
         * input("Maximum takeoff lift coefficient C_Lmax_TO: ");
         * 
         * 
         * // Takeoff requirements / assumptions
         * 
         * user_aircraft_TW_input.S_G = input("Takeoff ground roll distance (m): ");
         * 
         * user_aircraft_TW_input.K_TO =
         * input("Takeoff stall-speed safety factor K_TO: ");
         * 
         * user_aircraft_TW_input.Rolling_friction_coefficient = ...
         * input("Rolling friction coefficient: ");
         * 
         * user_aircraft_TW_input.Propeller_efficiency_TO = ...
         * input("Takeoff propeller efficiency: ");
         * 
         * user_aircraft_TW_input.altitude_TO = input("Takeoff altitude (m): ");
         * 
         * 
         * // Fuel assumptions
         * 
         * user_aircraft_TW_input.Fuel_spent_ground_to_TO = ...
         * input("Fuel used before/during takeoff (gal): ");
         * 
         * user_aircraft_TW_input.Fuel_mass_per_gallon = ...
         * input("Fuel mass per gallon (kg/gal): ");
         * 
         * 
         * // Climb requirements
         * 
         * user_aircraft_TW_input.rate_of_climb = input("Required climb rate: ");
         * 
         * user_aircraft_TW_input.velocity_climb = ...
         * input("Climb velocity (knots): ");
         * 
         * user_aircraft_TW_input.altitude_climb =
         * input("Climb constraint altitude (m): ");
         * 
         * 
         * // Cruise requirements
         * 
         * user_aircraft_TW_input.velocity_cruise = ...
         * input("Cruise velocity (knots): ");
         * 
         * user_aircraft_TW_input.altitude_cruise = input("Cruise altitude (m): ");
         * 
         * 
         * // Turn requirements
         * 
         * user_aircraft_TW_input.radius_turn = input("Turn radius (m): ");
         * 
         * user_aircraft_TW_input.altitude_turn = input("Turn altitude (m): ");
         * 
         * user_aircraft_TW_input.C_Lmax_turn = input("Turn max lift coefficient: ");
         * 
         * user_aircraft_TW_input.K_turn =
         * input("Takeoff stall-speed safety factor K_turn: ");
         * 
         * 
         * // Horizontal acceleration requirements
         * 
         * user_aircraft_TW_input.velocity_accel = ...
         * input("Horizontal acceleration's velocity (knots): ");
         * 
         * user_aircraft_TW_input.accel_horiz = ...
         * input("Required horizontal acceleration (m/s^2): ");
         * 
         * user_aircraft_TW_input.altitude_horiz_accel = ...
         * input("Horizontal acceleration altitude (m): ");
         * 
         * 
         * // Approach requirements
         * 
         * user_aircraft_TW_input.velocity_approach =
         * input("Approach velocity (knots): ");
         * 
         * user_aircraft_TW_input.K_approach = ...
         * input("Approach stall-speed safety factor K_approach: ");
         * 
         * user_aircraft_TW_input.C_Lmax_approach = ...
         * input("Maximum approach lift coefficient C_Lmax_approach: ");
         * 
         * user_aircraft_TW_input.altitude_approach = input("Approach altitude (m): ");
         * 
         * // Creating the wing_Area bounds
         * 
         * user_aircraft_TW_input.Wing_area_final = user_aircraft_TW_input.Wing_area_raw
         * * 2;
         * 
         * user_aircraft_TW_input.Wing_area = ...
         * user_aircraft_TW_input.Wing_area_raw:0.1:user_aircraft_TW_input.
         * Wing_area_final;
         */
        scan.close();
        return user_aircraft_TW_input;
    }

    public static twResults calculate_TW_constraints(TWAircraftInput user_aircraft_TW_input) {

        // Initial assumptions of aircraft design

        double Gravity = 9.81;

        double pi = 3.141592653589793238462643383;

        twResults TW = new twResults();

        // for fun I wrote down the decimals ik,
        // the program rounds decimals to the 4th decimal

        // rho_SL = 1.225;

        // Cruise_velocity = 74.594;

        // C_Dmin = 0.027; // Assumption from Cirrus sr 20

        // C_Lmin = 0.3; // Assumption from Cirrus sr 20

        // Sweep_angle = 3; // Made from assumption

        // HP_to_watts = 745.7;

        // The Design of the aircraft inputs

        // NOTE Measuremnt in HP will be convert to Watts

        // Engine_power_HP = 230; // Assumption of Eninge need data

        // Span = 9; // assume based on aircraft type

        // Wing_area = 8:0.1:16; // assume based on aircraft type

        // Mass_without_wing_skin = 780; // assume based on aircraft type

        // Wing_material_density = 2700; // assumption of kg/m^3 density of GA aluminum

        // Wing_skin_thickness = 0.002; // assumption of mass of GA aluminum

        // Engine Characteristics calculations

        // Engine_power_watts = user_aircraft_TW_input.Engine_power_HP .* HP_to_watts;

        // Mass of the aircraft and related Geometry calculations

        // Fuel_spent_ground_to_TO = 0.11;

        // Fuel_mass_per_gallon = 2.8; // ARD

        double mass_loss_on_TO = user_aircraft_TW_input.Fuel_spent_ground_to_TO
                * user_aircraft_TW_input.Fuel_mass_per_gallon;

        user_aircraft_TW_input.Wing_area_final = user_aircraft_TW_input.Wing_area_raw * 2;

        int size = (int) Math
                .round((user_aircraft_TW_input.Wing_area_final - user_aircraft_TW_input.Wing_area_raw) / 0.1) + 1;

        user_aircraft_TW_input.Wing_area = new double[size];

        double[] Wing_skin_area_total = new double[size];
        double[] Wing_skin_volume = new double[size];
        double[] Wing_skin_mass = new double[size];
        double[] Mass_aircraft = new double[size];
        double[] Mass_TO = new double[size];

        TW.Weight_TO = new double[size];

        double[] Wing_loading = new double[size];
        double[] AR_wing = new double[size];

        for (int i = 0; i < size; i++) {

            Wing_skin_area_total[i] = 2 * user_aircraft_TW_input.Wing_area[i];

            Wing_skin_volume[i] = Wing_skin_area_total[i] * user_aircraft_TW_input.Wing_skin_thickness;

            Wing_skin_mass[i] = Wing_skin_volume[i] * user_aircraft_TW_input.Wing_material_density;

            Mass_aircraft[i] = user_aircraft_TW_input.Mass_without_wing_skin + Wing_skin_mass[i];

            Mass_TO[i] = Mass_aircraft[i] - mass_loss_on_TO;

            TW.Weight_TO[i] = Mass_TO[i] * Gravity;

            Wing_loading[i] = TW.Weight_TO[i] / user_aircraft_TW_input.Wing_area[i];

            AR_wing[i] = Math.pow(user_aircraft_TW_input.Span, 2)
                    / user_aircraft_TW_input.Wing_area[i];
        }

        // Aerodynamic calculations

        // Oswald efficiency calculations - Sweep angle calculation decision

        TW.e = new double[size];

        if (user_aircraft_TW_input.Sweep_angle == 0) {

            for (int i = 0; i < size; i++) {
                TW.e[i] = 1.78 * (1 - 0.045 * Math.pow(AR_wing[i], 0.68)) - 0.64;
            }

        } else if (user_aircraft_TW_input.Sweep_angle >= 30) {

            for (int i = 0; i < size; i++) {
                TW.e[i] = 4.61 * (1 - 0.045 * Math.pow(AR_wing[i], 0.68))
                        * Math.pow(Math.cos(Math.toRadians(user_aircraft_TW_input.Sweep_angle)), 0.15) - 3.1;
            }

        } else if ((user_aircraft_TW_input.Sweep_angle > 0) &&
                (user_aircraft_TW_input.Sweep_angle < 30)) {

            TW.e0 = new double[size];
            TW.e30 = new double[size];

            for (int i = 0; i < size; i++) {
                TW.e0[i] = 1.78 * (1 - 0.045 * Math.pow(AR_wing[i], 0.68)) - 0.64;

                TW.e30[i] = 4.61 * (1 - 0.045 * Math.pow(AR_wing[i], 0.68))
                        * Math.pow(Math.cos(Math.toRadians(30)), 0.15) - 3.1;

                TW.e[i] = TW.e0[i] + (user_aircraft_TW_input.Sweep_angle / 30.0) * (TW.e30[i] - TW.e0[i]);
            }

        } else {

            throw new IllegalArgumentException("Sweep angle is out of range");

        }

        // Full Drag Polar Buildup

        TW.K_1 = new double[size];
        TW.C_D0 = new double[size];
        TW.K_2 = new double[size];

        for (int i = 0; i < size; i++) {
            TW.K_1[i] = 1.0 / (pi * AR_wing[i] * TW.e[i]);

            TW.C_D0[i] = user_aircraft_TW_input.C_Dmin + TW.K_1[i] * Math.pow(user_aircraft_TW_input.C_Lmin, 2);

            TW.K_2[i] = -2 * TW.K_1[i] * user_aircraft_TW_input.C_Lmin;
        }

        // Takeoff constraint assumptions, variables and formulas

        // variables

        // Desired inputs

        // S_G = 502.92; // Ground roll takeoff distance

        // K_TO = 1.2;

        // C_Lmax_TO = 1.7; // Assumption including flaps, elevator, and wing

        // Rolling_friction_coefficient = 0.03;

        // Propeller_efficiency_TO = 0.75; // assume based on propeller

        user_aircraft_TW_input.rho_TO = altitude_find_rho(user_aircraft_TW_input.altitude_TO);

        // Velocity formulas

        TW.Velocity_stall = new double[size];
        TW.velocity_TO = new double[size];
        TW.Velocity_avg_TO = new double[size];
        TW.q_avg_TO = new double[size];
        TW.C_L_required_TO = new double[size];
        TW.C_DTO = new double[size];

        double[] Acceleration_TO = new double[size];
        double[] Thrust_to_Weight_TO = new double[size];

        for (int i = 0; i < size; i++) {
            TW.Velocity_stall[i] = Math.sqrt((2 * TW.Weight_TO[i]) / (user_aircraft_TW_input.rho_TO *
                    user_aircraft_TW_input.Wing_area[i] * user_aircraft_TW_input.C_Lmax_TO));

            TW.velocity_TO[i] = user_aircraft_TW_input.K_TO * TW.Velocity_stall[i];

            TW.Velocity_avg_TO[i] = TW.velocity_TO[i] / Math.sqrt(2);

            // constraints sub-formulas

            TW.q_avg_TO[i] = 0.5 * user_aircraft_TW_input.rho_TO * Math.pow(TW.Velocity_avg_TO[i], 2);

            TW.C_L_required_TO[i] = 2 * TW.Weight_TO[i] / (user_aircraft_TW_input.rho_TO *
                    Math.pow(TW.velocity_TO[i], 2) * user_aircraft_TW_input.Wing_area[i]);

            /// *C_L_ground_TO For a more accurate constraint create a lift
            // coefficient that is specific for ground because the ground
            // and takeoff coefficients are not the same*\

            TW.C_DTO[i] = TW.C_D0[i] + (TW.K_1[i] * Math.pow(TW.C_L_required_TO[i], 2))
                    + TW.K_2[i] * TW.C_L_required_TO[i];

            /// *Lift_avg_TO = 0.5 .* user_aircraft_TW_input.rho_TO .* TW.Velocity_avg_TO.^2
            // .* user_aircraft_TW_input.Wing_area .* C_L_required_TO;*\

            /// *The lift average take off will change based on the average dynamic
            // pressure, lift coefficients for the ground Take off and etc*\

            /// *Drag_TO = 0.5 .* TW.C_DTO .* user_aircraft_TW_input.rho_TO .*
            // user_aircraft_TW_input.Wing_area .* TW.velocity_TO.^2;*\

            /// *Drag_avg_TO = 0.5 .* user_aircraft_TW_input.rho_TO .* TW.Velocity_avg_TO.^2
            // .* user_aircraft_TW_input.Wing_area .* TW.C_DTO;*\

            /// *Will also chagned when created ground drag coeffiecients for TO*\
            /// *Thrust_TO = (user_aircraft_TW_input.Propeller_efficiency_TO .*
            // Engine_power_watts) ./ TW.velocity_TO;*\

            Acceleration_TO[i] = Math.pow(TW.velocity_TO[i], 2) / (2 * user_aircraft_TW_input.S_G);

            Thrust_to_Weight_TO[i] = (Acceleration_TO[i] / Gravity) +
                    (TW.q_avg_TO[i] * TW.C_DTO[i]) / Wing_loading[i]
                    + user_aircraft_TW_input.Rolling_friction_coefficient
                            * (1 - (TW.q_avg_TO[i] * TW.C_L_required_TO[i]) / Wing_loading[i]); // Takeoff Constraint
        }

        // Creating scatter plot for takeoff constraint

        // figure;

        // plot(Wing_loading, Thrust_to_Weight_TO, '-');

        // hold on; //Stops from other plots from overriding the first

        // Climb constraint

        /// *This assumes no turns and constant climbing velocity, thus
        // keeping the load factor (n) roughly around 1. Additionaly, the
        // claculation assumes that there are no resistance such as landing
        // gears or flaps that can have an inlfluence to drag are all not
        // accounted for.*\

        // Variables

        double alpha = 1; // assuming Simple sea-level climb

        // Aircraft desired Inputs

        double n = 1;

        // rate_of_climb = 3.5; //(meters per sec)

        // velocity_climb = 48;

        user_aircraft_TW_input.rho_climb = altitude_find_rho(user_aircraft_TW_input.altitude_climb);

        // sub-formulas for the climb constraint

        user_aircraft_TW_input.velocity_climb = conv_knts_to_ms(user_aircraft_TW_input.velocity_climb);

        double q_climb = 0.5 * user_aircraft_TW_input.rho_climb *
                Math.pow(user_aircraft_TW_input.velocity_climb, 2);

        double[] Beta = new double[size]; // Weight fraction

        // A more specific version of Beta could have bee the mass while
        // climbing ./ Mass_TO

        double[] Thrust_to_Weight_climb = new double[size];

        for (int i = 0; i < size; i++) {
            Beta[i] = Mass_TO[i] / Mass_aircraft[i];

            Thrust_to_Weight_climb[i] = Beta[i] / alpha * (((TW.K_1[i] * Math.pow(n, 2) * Beta[i]) /
                    q_climb) * (TW.Weight_TO[i] / user_aircraft_TW_input.Wing_area[i]) + TW.K_2[i] *
                            n
                    + TW.C_D0[i] / ((Beta[i] / q_climb) * Wing_loading[i]) +
                    user_aircraft_TW_input.rate_of_climb /
                            user_aircraft_TW_input.velocity_climb);
        }

        // plot(Wing_loading, Thrust_to_Weight_climb, '-');

        // Cruise constraint

        // variable

        // knot_to_ms = 0.51444444;

        // aircraft user inputs

        // velocity_cruise = 155 .* knot_to_ms;

        /// *Will change in the future for user input when wanting to know
        // the T/W for the desired cruise knots they want. Additionaly, will
        // add the calculation of the cruise velocity when user does not have
        // a desire velcoity and will be based on the parameter they place for
        // the aircraft.*\

        user_aircraft_TW_input.rho_cruise = altitude_find_rho(user_aircraft_TW_input.altitude_cruise);

        // sub-formulas for constraint

        // velocity_cruise_knts = user_aircraft_TW_input.velocity_cruise .* knot_to_ms;

        user_aircraft_TW_input.velocity_cruise = conv_knts_to_ms(user_aircraft_TW_input.velocity_cruise);

        double q_cruise = 0.5 * user_aircraft_TW_input.rho_cruise *
                Math.pow(user_aircraft_TW_input.velocity_cruise, 2);

        double[] C_Lcruise = new double[size];

        double[] C_D_cruise = new double[size];

        double[] Thrust_to_Weight_cruise = new double[size];

        for (int i = 0; i < size; i++) {
            C_Lcruise[i] = Wing_loading[i] / q_cruise;

            C_D_cruise[i] = TW.C_D0[i] + (TW.K_1[i] * Math.pow(C_Lcruise[i], 2)) + TW.K_2[i] * C_Lcruise[i];

            // Calculate the thrust-to-weight ratio for cruise

            Thrust_to_Weight_cruise[i] = (q_cruise * C_D_cruise[i]) / Wing_loading[i];
        }

        // plot(Wing_loading, Thrust_to_Weight_cruise, '-');

        // Turn constraint

        // Variables

        // User desire input

        // in meters of user idea of their aircraft turning

        // radius_turn = 300;

        user_aircraft_TW_input.rho_turn = altitude_find_rho(user_aircraft_TW_input.altitude_turn);

        double C_Lmax_turn = user_aircraft_TW_input.C_Lmax_turn;

        // Sub-formulas

        // /*velocity_stall_straight = sqrt((2 .* Wing_loading) ...
        // ./ (user_aircraft_TW_input.rho_turn .* C_Lmax_turn)); //A straight
        // line of aircraft stall velocity*\

        // The guess of the safe turn velocity

        // velocity_guess_turn = user_aircraft_TW_input.K_turn .*
        // velocity_stall_straight;

        // Bank angle calculation from the guessed velocity and radius

        /// *bank_angle = atand(velocity_guess_turn.^2 .
        // (user_aircraft_TW_input.radius_turn * Gravity));*\

        /// *The start of the loop. We make it run
        // through the loop to be accurate*\

        double[] n_turn = new double[size];
        double[] velocity_safe_turn = new double[size];
        double[] update_load_factor = new double[size];

        for (int i = 0; i < size; i++) {
            n_turn[i] = 1;
        }

        for (int refine_loop = 1; refine_loop <= 1000; refine_loop++) {

            double[] n_old = n_turn.clone();

            double maxDifference = 0;

            for (int i = 0; i < size; i++) {

                double velocity_stall_turn = Math.sqrt((2 * Wing_loading[i] * n_turn[i]) /
                        (user_aircraft_TW_input.rho_turn * C_Lmax_turn));

                // The safe turn

                velocity_safe_turn[i] = user_aircraft_TW_input.K_turn * velocity_stall_turn;

                // Usign the new safe turn velocity we update the load factor

                update_load_factor[i] = 1.0 / Math.cos(Math.atan(Math.pow(velocity_safe_turn[i], 2) /
                        (user_aircraft_TW_input.radius_turn * Gravity)));

                n_turn[i] = update_load_factor[i];

                maxDifference = Math.max(maxDifference, Math.abs(n_turn[i] - n_old[i]));
            }

            if (maxDifference < 0.0001) {
                break;
            }
        }

        TW.update_load_factor = update_load_factor;

        // the dynamic pressure using the safe turn velcoity

        double[] q_turn = new double[size];

        // coefficents

        double[] C_L_turn = new double[size];

        double[] C_D_turn = new double[size];

        // Thrust to Weight calculation

        double[] Thrust_to_Weight_turn = new double[size];

        boolean aircraftWillStall = false;

        for (int i = 0; i < size; i++) {
            q_turn[i] = 0.5 * user_aircraft_TW_input.rho_turn * Math.pow(velocity_safe_turn[i], 2);

            C_L_turn[i] = TW.update_load_factor[i] * Wing_loading[i] / q_turn[i];

            C_D_turn[i] = TW.C_D0[i] + TW.K_1[i] * Math.pow(C_L_turn[i], 2) + TW.K_2[i] * C_L_turn[i];

            Thrust_to_Weight_turn[i] = (q_turn[i] * C_D_turn[i]) / Wing_loading[i];

            if (C_L_turn[i] > C_Lmax_turn) {
                aircraftWillStall = true;
            }
        }

        // plot(Wing_loading, Thrust_to_Weight_turn, '-');

        if (aircraftWillStall) {

            // aircraft would stall / turn condition is infeasible

            throw new IllegalArgumentException("The aircraft will stall due to the turn needing to be higher than"
                    + " the lift coefficent. This aircraft I would not recommend to use"
                    + " this any design from this graph unless you found out which aircraft"
                    + "was causing the problem.");
        }

        // Horizontal Acceleration constraint

        /// *The constraitn assumes that the aircraft is accelerating in a horizontal
        // position, no banking nor pitching. The constraitn is asuming that the
        // aircraft is in a cruise phase.*\

        // variables

        // user inputs

        // velocity_accel = 50;

        // accel_horiz = 1.1;

        user_aircraft_TW_input.rho_horiz_accel = altitude_find_rho(user_aircraft_TW_input.altitude_horiz_accel);

        // sub-formulas

        user_aircraft_TW_input.velocity_accel = conv_knts_to_ms(user_aircraft_TW_input.velocity_accel);

        double q_accel = 0.5 * user_aircraft_TW_input.rho_horiz_accel *
                Math.pow(user_aircraft_TW_input.velocity_accel, 2);

        double[] C_L_accel = new double[size];

        double[] C_D_accel = new double[size];

        // horizontal accel. constraint

        double[] Thrust_to_Weight_horiz_accel = new double[size];

        for (int i = 0; i < size; i++) {
            C_L_accel[i] = Wing_loading[i] / q_accel;

            C_D_accel[i] = TW.C_D0[i] + TW.K_1[i] * Math.pow(C_L_accel[i], 2) + TW.K_2[i] * C_L_accel[i];

            Thrust_to_Weight_horiz_accel[i] = (q_accel * C_D_accel[i]) / Wing_loading[i]
                    + user_aircraft_TW_input.accel_horiz / Gravity; // Horizontal acceleration
        }

        // plot(Wing_loading, Thrust_to_Weight_horiz_accel, '-');

        // Approach Constraint

        // variables

        // User input

        // velocity_approach = user_aircraft_TW_input.velocity_approach .* knot_to_ms;

        // K_approach = 1.3;

        user_aircraft_TW_input.rho_approach = altitude_find_rho(user_aircraft_TW_input.altitude_approach);

        // sub-formulas

        user_aircraft_TW_input.velocity_approach = conv_knts_to_ms(user_aircraft_TW_input.velocity_approach);

        // Converting knots to m/s

        double velocity_stall_approach = user_aircraft_TW_input.velocity_approach /
                user_aircraft_TW_input.K_approach;

        double q_approach = 0.5 * user_aircraft_TW_input.rho_approach *
                Math.pow(velocity_stall_approach, 2);

        // C_L_approach = Wing_loading ./ q_approach;

        // approach formula constraint

        double Wing_loading_approach = q_approach * user_aircraft_TW_input.C_Lmax_approach;

        // This creates a veritcal line for the apporach constraint

        // xline(Wing_loading_approach, '-');

        // xlabel('Wing Loading (N/m^2)');

        // ylabel('Thrust to Weight Ratio, T/W');

        // title('Constraints: T/W vs Wing Loading');

        // grid on;

        // legend('Takeoff', 'Climb', 'Cruise', 'Turn', 'Horizontal Acceleration',
        // 'Approach');

        //

        // ///*stops the plots from being in the hold

        // //mode thus future plots can ovveride*\

        //

        // hold off;

        // T/W for plots

        TW.Takeoff_constraint = Thrust_to_Weight_TO;

        TW.Climb_constraint = Thrust_to_Weight_climb;

        TW.Cruise_constraint = Thrust_to_Weight_cruise;

        TW.Turn_constraint = Thrust_to_Weight_turn;

        TW.Horizontal_acceleration_constraint = Thrust_to_Weight_horiz_accel;

        TW.Approach_wing_loading_constraint = Wing_loading_approach;

        TW.Wing_loading_x_axis = Wing_loading;

        // For displaying TW data from ST menu

        // For Forward CG limit

        TW.q_TO = new double[size];

        for (int i = 0; i < size; i++) {
            TW.q_TO[i] = 0.5 * user_aircraft_TW_input.rho_TO * Math.pow(TW.velocity_TO[i], 2);
        }

        // TW.C_L_required_TO was already calculated above and stored in
        // TW.C_L_required_TO

        // For calculating the loads

        TW.rho_cruise = user_aircraft_TW_input.rho_cruise;

        TW.velocity_cruise = user_aircraft_TW_input.velocity_cruise;

        return TW;
    }

    public static double altitude_find_rho(double altitude) {

        double rho_SL = 1.225;
        double Gravity = 9.80665;
        double temp_SL = 288.15;
        double temp_lapse_rate = 0.0065;
        double air_gas = 287.05;

        double rho = rho_SL
                * Math.pow(1 - (temp_lapse_rate * altitude) / temp_SL, (Gravity / (air_gas * temp_lapse_rate)) - 1);

        return rho;
    }

    public static double conv_knts_to_ms(double velocity_knots) {

        double velocity_ms = velocity_knots * 0.5144;

        return velocity_ms;

    }

    public static void display_TW(twResults TW) {
        System.out.println("This is entering function display to graph T/W cosntraints");
        System.out.println(java.util.Arrays.toString(TW.Takeoff_constraint));

        // TW.Takeoff_constraint = Thrust_to_Weight_TO;
        // TW.Climb_constraint = Thrust_to_Weight_climb;
        // TW.Cruise_constraint = Thrust_to_Weight_cruise;
        // TW.Turn_constraint = Thrust_to_Weight_turn;
        // TW.Horizontal_acceleration_constraint = Thrust_to_Weight_horiz_accel;
        // TW.Approach_wing_loading_constraint = Wing_loading_approach;
        //
        // TW.Wing_loading_x_axis = Wing_loading;

        /*
         * plot(TW.Wing_loading_x_axis, TW.Takeoff_constraint, '-');
         * hold on;
         * 
         * plot(TW.Wing_loading_x_axis, TW.Climb_constraint, '-');
         * 
         * plot(TW.Wing_loading_x_axis, TW.Cruise_constraint, '-');
         * 
         * plot(TW.Wing_loading_x_axis, TW.Turn_constraint, '-');
         * 
         * plot(TW.Wing_loading_x_axis, TW.Horizontal_acceleration_constraint, '-');
         * 
         * // Approach is a vertical wing-loading constraint
         * xline(TW.Approach_wing_loading_constraint, '-');
         * 
         * xlabel('Wing Loading (N/m^2)');
         * ylabel('Thrust to Weight Ratio, T/W');
         * title('Constraints: T/W vs Wing Loading');
         * grid on;
         * legend('Takeoff', 'Climb', 'Cruise', 'Turn', 'Horizontal Acceleration',...
         * 'Approach');
         * 
         * ///*stops the plots from being in the hold
         * //mode thus future plots can ovveride*\
         * 
         * hold off;
         */

    }

}
