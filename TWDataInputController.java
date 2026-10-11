package com.kriston.test1;

import java.io.IOException;

import com.kriston.test1.master.Aircraft_constraint_states;

import javafx.fxml.FXML;
import javafx.scene.control.TextField;
import javafx.scene.control.Alert;

public class TWDataInputController {

    @FXML
    private TextField Engine_power_HPInput;
    @FXML
    private TextField SpanInput;
    @FXML
    private TextField Wing_area_rawInput;
    @FXML
    private TextField Sweep_angleInput;
    @FXML
    private TextField Mass_without_wing_skinInput;
    @FXML
    private TextField Wing_material_densityInput;
    @FXML
    private TextField Wing_skin_thicknessInput;
    @FXML
    private TextField C_DminInput;
    @FXML
    private TextField C_LminInput;
    @FXML
    private TextField C_Lmax_TOInput;
    @FXML
    private TextField S_GInput;
    @FXML
    private TextField K_TOInput;
    @FXML
    private TextField Rolling_friction_coefficientInput;
    @FXML
    private TextField Propeller_efficiency_TOInput;
    @FXML
    private TextField altitude_TOInput;
    @FXML
    private TextField Fuel_spent_ground_to_TOInput;
    @FXML
    private TextField Fuel_mass_per_gallonInput;
    @FXML
    private TextField rate_of_climbInput;
    @FXML
    private TextField velocity_climbInput;
    @FXML
    private TextField altitude_climbInput;
    @FXML
    private TextField velocity_cruiseInput;
    @FXML
    private TextField altitude_cruiseInput;
    @FXML
    private TextField radius_turnInput;
    @FXML
    private TextField altitude_turnInput;
    @FXML
    private TextField C_Lmax_turnInput;
    @FXML
    private TextField K_turnInput;
    @FXML
    private TextField velocity_accelInput;
    @FXML
    private TextField accel_horizInput;
    @FXML
    private TextField altitude_horiz_accelInput;
    @FXML
    private TextField velocity_approachInput;
    @FXML
    private TextField K_approachInput;
    @FXML
    private TextField C_Lmax_approachInput;
    @FXML
    private TextField altitude_approachInput;

    @FXML
    private void handleTWGraph() throws IOException {
        try {
            TWAircraftInput user_aircraft_TW_input = master.user_aircraft_TW_input;

            user_aircraft_TW_input.Engine_power_HP = Double.parseDouble(Engine_power_HPInput.getText());
            user_aircraft_TW_input.Span = Double.parseDouble(SpanInput.getText());
            user_aircraft_TW_input.Wing_area_raw = Double.parseDouble(Wing_area_rawInput.getText());
            user_aircraft_TW_input.Sweep_angle = Double.parseDouble(Sweep_angleInput.getText());

            user_aircraft_TW_input.Mass_without_wing_skin = Double.parseDouble(Mass_without_wing_skinInput.getText());
            user_aircraft_TW_input.Wing_material_density = Double.parseDouble(Wing_material_densityInput.getText());
            user_aircraft_TW_input.Wing_skin_thickness = Double.parseDouble(Wing_skin_thicknessInput.getText());

            user_aircraft_TW_input.C_Dmin = Double.parseDouble(C_DminInput.getText());
            user_aircraft_TW_input.C_Lmin = Double.parseDouble(C_LminInput.getText());
            user_aircraft_TW_input.C_Lmax_TO = Double.parseDouble(C_Lmax_TOInput.getText());
            user_aircraft_TW_input.S_G = Double.parseDouble(S_GInput.getText());

            user_aircraft_TW_input.K_TO = Double.parseDouble(K_TOInput.getText());
            user_aircraft_TW_input.Rolling_friction_coefficient = Double.parseDouble(Rolling_friction_coefficientInput.getText());

            user_aircraft_TW_input.Propeller_efficiency_TO = Double.parseDouble(Propeller_efficiency_TOInput.getText());
            user_aircraft_TW_input.altitude_TO = Double.parseDouble(altitude_TOInput.getText());

            user_aircraft_TW_input.Fuel_spent_ground_to_TO = Double.parseDouble(Fuel_spent_ground_to_TOInput.getText());
            user_aircraft_TW_input.Fuel_mass_per_gallon = Double.parseDouble(Fuel_mass_per_gallonInput.getText());

            user_aircraft_TW_input.rate_of_climb = Double.parseDouble(rate_of_climbInput.getText());
            user_aircraft_TW_input.velocity_climb = Double.parseDouble(velocity_climbInput.getText());
            user_aircraft_TW_input.altitude_climb = Double.parseDouble(altitude_climbInput.getText());

            user_aircraft_TW_input.velocity_cruise = Double.parseDouble(velocity_cruiseInput.getText());
            user_aircraft_TW_input.altitude_cruise = Double.parseDouble(altitude_cruiseInput.getText());

            user_aircraft_TW_input.radius_turn = Double.parseDouble(radius_turnInput.getText());
            user_aircraft_TW_input.altitude_turn = Double.parseDouble(altitude_turnInput.getText());
            user_aircraft_TW_input.C_Lmax_turn = Double.parseDouble(C_Lmax_turnInput.getText());
            user_aircraft_TW_input.K_turn = Double.parseDouble(K_turnInput.getText());

            user_aircraft_TW_input.velocity_accel = Double.parseDouble(velocity_accelInput.getText());
            user_aircraft_TW_input.accel_horiz = Double.parseDouble(accel_horizInput.getText());
            user_aircraft_TW_input.altitude_horiz_accel = Double.parseDouble(altitude_horiz_accelInput.getText());
            user_aircraft_TW_input.velocity_approach = Double.parseDouble(velocity_approachInput.getText());
            user_aircraft_TW_input.K_approach = Double.parseDouble(K_approachInput.getText());
            user_aircraft_TW_input.C_Lmax_approach = Double.parseDouble(C_Lmax_approachInput.getText());
            user_aircraft_TW_input.altitude_approach = Double.parseDouble(altitude_approachInput.getText());

            App.changeState(Aircraft_constraint_states.CALCULATE_TW);

        } catch (NumberFormatException e) {

            Alert alert = new Alert(Alert.AlertType.ERROR);
            alert.setContentText("Enter valid number");
            alert.showAndWait();

        }

        master.main(Aircraft_constraint_states.CALCULATE_TW);
        System.out.println("T/W Graph button pressed");

    }
}