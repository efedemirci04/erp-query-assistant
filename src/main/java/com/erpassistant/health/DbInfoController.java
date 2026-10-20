package com.erpassistant.health;

import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

/**
 * Smoke-test endpoint: proves the app can reach PostgreSQL
 * and shows which tables exist (empty until we write V1).
 */
@RestController
@RequestMapping("/api/db")
public class DbInfoController {

    private final JdbcClient jdbc;

    // Constructor injection: Spring sees this constructor and passes in a JdbcClient bean.
    public DbInfoController(JdbcClient jdbc) {
        this.jdbc = jdbc;
    }

    @GetMapping("/info")
    public Map<String, Object> info() {
        String version = jdbc.sql("SELECT version()")
                .query(String.class)
                .single();

        List<String> tables = jdbc.sql("""
                        SELECT table_name
                        FROM information_schema.tables
                        WHERE table_schema = 'public'
                          AND table_type = 'BASE TABLE'
                        ORDER BY table_name
                        """)
                .query(String.class)
                .list();

        return Map.of(
                "postgres", version,
                "tables", tables
        );
    }
}
