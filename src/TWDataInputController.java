package com.kriston.test1;

import java.io.IOException;
import javafx.fxml.FXML;

public class TWDataInputController {

    @FXML
    private void handleTWGraph() throws IOException {
        App.setRoot("NaN");
        System.out.println("T/W Graph button pressed");
    }
}