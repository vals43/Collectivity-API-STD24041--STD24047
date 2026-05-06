package com.hei.agriculturalfederationmanagement.config;

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

        String db_url = dotenv.get("DB_URL");
        String db_user = dotenv.get("DB_USER");
        String db_password = dotenv.get("DB_PASSWORD");

        try {
            return DriverManager.getConnection(db_url, db_user, db_password);
        } catch (SQLException e) {
            throw new RuntimeException("Erreur connexion DB : " + e.getMessage(), e);
        }
    }
}