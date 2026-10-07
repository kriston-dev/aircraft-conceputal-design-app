package com.kriston.test1;

import java.util.Scanner;

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
                    user_aircraft_TW_input_loads = user_aircraft_TW_input;

                    user_aircraft_TW_input_loads.Wing_area = user_ST_aircraft_input.Wing_area;

                    TW = calculate_TW_constraints(user_aircraft_TW_input_loads);

                    App.currState = Aircraft_constraint_states.GRAPH_TW;

                    break;

                // This graphs what the calculation gave from getting the T/W aircraft data
                case GRAPH_TW:
                    display_TW(TW);
                    user_TW_saved = save_user_aircraft(user_TW_saved, user_aircraft_TW_input);
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

        System.out.println("My choice is: ");
        String user_path = scan.nextLine();

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
             * user_aircraft_TW_input.Wing_area_raw .* 2;
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
         * .* 2;
         * 
         * user_aircraft_TW_input.Wing_area = ...
         * user_aircraft_TW_input.Wing_area_raw:0.1:user_aircraft_TW_input.
         * Wing_area_final;
         */
        return user_aircraft_TW_input;
    }

}
