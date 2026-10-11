package com.kriston.test1;

import javafx.fxml.FXML;
import javafx.scene.chart.LineChart;
import javafx.scene.chart.NumberAxis;
import javafx.scene.chart.XYChart;

public class graphTWController {

    @FXML
    private LineChart<Number, Number> lineChart;

    @FXML
    private NumberAxis xAxis;

    @FXML
    private NumberAxis yAxis;

    private void initialize() {

        XYChart.Series<Number, Number> takeoff = new XYChart.Series<>();
        takeoff.setName("Takeoff");

        for (int i = 0; i < master.TW.Wing_loading_x_axis.length; i++) {

            takeoff.getData().add(new XYChart.Data<>(
                    master.TW.Wing_loading_x_axis[i],
                    master.TW.Takeoff_constraint[i]));
        }

        lineChart.getData().add(takeoff);
    }

}