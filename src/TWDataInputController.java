package com.kriston.test1;

import java.io.IOException;
import javafx.fxml.FXML;
import javafx.scene.control.TextField;
import javafx.scene.control.Alert;

public class TWDataInputController {

    @FXML
    private TextField spanInput;

    @FXML
    private void handleTWGraph() throws IOException {
        try {
            double span = Double.parseDouble(spanInput.getText());
            master.user_aircraft_TW_input.Span = span;
        } catch (NumberFormatException e) {
            Alert alert = new Alert(Alert.AlertType.ERROR);
            alert.setContentText("Enter valid number");
            alert.showAndWait();
        }

        App.setRoot("NaN");
        System.out.println("T/W Graph button pressed");
    }
}