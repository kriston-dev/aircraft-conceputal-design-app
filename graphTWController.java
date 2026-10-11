package com.kriston.test1;

import javafx.fxml.FXML;
import javafx.scene.chart.LineChart;
import javafx.scene.chart.NumberAxis;
import javafx.scene.chart.XYChart;

import javafx.geometry.Point2D;
import javafx.scene.control.Label;

public class graphTWController {

    @FXML
    private LineChart<Number, Number> lineChart;

    @FXML
    private NumberAxis xAxis;

    @FXML
    private NumberAxis yAxis;

    @FXML
    private Label coordinateLabel;

    @FXML
    private void initialize() {

        XYChart.Series<Number, Number> takeoff = new XYChart.Series<>();
        takeoff.setName("Takeoff");

        for (int i = 0; i < master.TW.Wing_loading_x_axis.length; i++) {

            takeoff.getData().add(new XYChart.Data<>(
                    master.TW.Wing_loading_x_axis[i],
                    master.TW.Takeoff_constraint[i]));
        }

        lineChart.setOnMouseMoved(event -> {

            Point2D xPosition = xAxis.sceneToLocal(event.getSceneX(), event.getSceneY());
            Point2D yPosition = yAxis.sceneToLocal(event.getSceneX(), event.getSceneY());

            double x = xAxis.getValueForDisplay(xPosition.getX()).doubleValue();
            double y = yAxis.getValueForDisplay(yPosition.getY()).doubleValue();

            if (xPosition.getX() >= 0 && xPosition.getX() <= xAxis.getWidth()
                    && yPosition.getY() >= 0 && yPosition.getY() <= yAxis.getHeight()) {

                coordinateLabel.setText(
                        String.format("Wing Loading: %.2f N/m² | T/W: %.4f", x, y));
            }
        });

        lineChart.getData().add(takeoff);
    }

}