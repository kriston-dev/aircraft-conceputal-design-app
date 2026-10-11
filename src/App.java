package com.kriston.test1;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

import java.io.IOException;

import com.kriston.test1.master.Aircraft_constraint_states;

/**
 * JavaFX App
 */
public class App extends Application {

    private static Scene scene;

    public static Aircraft_constraint_states currState = Aircraft_constraint_states.MAIN_MENU;

    @Override
    public void start(Stage stage) throws IOException {
        scene = new Scene(loadFXML("mainMenu"), 640, 480);
        stage.setScene(scene);
        stage.show();
    }

    public static void setRoot(String fxml) throws IOException {
        scene.setRoot(loadFXML(fxml));
    }

    private static Parent loadFXML(String fxml) throws IOException {
        FXMLLoader fxmlLoader = new FXMLLoader(App.class.getResource(fxml + ".fxml"));
        return fxmlLoader.load();
    }

    public static void main(String[] args) {
        launch();
    }

    public static void changeState(Aircraft_constraint_states newState)
            throws IOException {

        currState = newState;

        switch (currState) {

            case MAIN_MENU:
                System.out.println("entering main menu from app");
                master.main(Aircraft_constraint_states.MAIN_MENU);
                setRoot("mainMenu");
                break;

            case GET_TW_AIRCRAFT_DATA:
                System.out.println("entering getting data from app");
                master.main(Aircraft_constraint_states.GET_TW_AIRCRAFT_DATA);
                setRoot("get_tw_data_disp");
                break;

            case SAVED_TW_AIRCRAFT_DATA:
                System.out.println("entering saved files TW from app");
                master.main(Aircraft_constraint_states.SAVED_TW_AIRCRAFT_DATA);
                setRoot("saved_tw_data_disp");
                break;

            case CALCULATE_TW:
                System.out.println("entering calculation from app");
                master.main(Aircraft_constraint_states.CALCULATE_TW);
                changeState(Aircraft_constraint_states.GRAPH_TW);

            case GRAPH_TW:
                System.out.println("entering graph TW from app");
                setRoot("graphTW");
                break;

            default:
                System.out.println("State not added in the app.java file: " + currState);
                break;
        }
    }

}