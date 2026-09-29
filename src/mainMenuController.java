package com.kriston.test1;

import java.io.IOException;

import com.kriston.test1.master.Aircraft_constraint_states;

import javafx.fxml.FXML;

public class mainMenuController {

    @FXML
    private void getTW() throws IOException {
        App.currState = Aircraft_constraint_states.GET_TW_AIRCRAFT_DATA;
        App.setRoot("get_tw_data_disp");
    }
}
