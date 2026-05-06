package com.Prog3.AgricultureCollectivity.config;

import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

@Configuration
public class Datasource {

    @Bean
    public Connection getConnection() {
        Dotenv dotenv = Dotenv.load();

        // Vérifie bien que ces noms correspondent à ton fichier .env
        String dbUrl = dotenv.get("DB_URL");
        String dbUser = dotenv.get("DB_USERNAME"); // Changé de DB_USER à DB_USERNAME
        String dbPassword = dotenv.get("DB_PASSWORD");

        try {
            return DriverManager.getConnection(dbUrl, dbUser, dbPassword);
        } catch (SQLException e) {
            throw new RuntimeException("Erreur connexion DB : " + e.getMessage(), e);
        }
    }
}