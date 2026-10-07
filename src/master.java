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
         * % before starting the calculation of the aircraft T/W.*\
         * 
         * % function TW = found_TW()
         * 
         * % TW = 3;
         * % end
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

    public static edit_TW_aircraft(TWAircraftInput user_aircraft_TW_input) {
        
    }

}
