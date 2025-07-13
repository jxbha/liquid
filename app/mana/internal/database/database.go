package database

import (
	"database/sql"
	"fmt"
	"jbernh/mana/internal/domain/pair"
	"log/slog"
	"os"
	"time"

	_ "github.com/jackc/pgx/v5/stdlib"
)

type PostgresRepository struct {
	DB *sql.DB
}

func NewPostgresRepository(db *sql.DB) *PostgresRepository {
	return &PostgresRepository{DB: db}
}

type Config struct {
	host     string
	port     string
	username string
	password string
	database string
	sslmode  string
	table    string
}

func (c *Config) ConnectionString() string {
	return fmt.Sprintf("postgres://%s:%s@%s:%s/%s?sslmode=%s",
		c.username, c.password, c.host, c.port, c.database, c.sslmode)
}

func LoadConfig() (*Config, error) {
	cfg := &Config{
		host:     getEnvOrDefault("POSTGRES_ADDR", "localhost"),
		port:     getEnvOrDefault("POSTGRES_PORT", "5432"),
		username: getEnvOrDefault("POSTGRES_USER", "mana"),
		password: getEnvOrDefault("POSTGRES_PASSWORD", ""),
		database: getEnvOrDefault("POSTGRES_DATABASE", "mana"),
		sslmode:  getEnvOrDefault("SSL_MODE", "disable"),
	}

	if cfg.password == "" {
		return nil, fmt.Errorf("error: password not provided")
	}

	return cfg, nil
}

func getEnvOrDefault(key, defaultValue string) string {
	if os.Getenv(key) != "" {
		return os.Getenv(key)
	}

	return defaultValue
}

func NewDB(cfg *Config) (*sql.DB, error) {
	URI := cfg.ConnectionString()
	db, err := sql.Open("pgx", URI)

	if err == nil {
		for i := 5; i > 0; i-- {
			if err = db.Ping(); err == nil {
				break
			}
			time.Sleep(5 * time.Second)
		}

		if err != nil {
			return nil, err
		}

		return db, nil
	}

	return nil, err
}

func (conn *PostgresRepository) List() ([]pair.Pair, error) {
	pairs := []pair.Pair{}
	rows, err := conn.DB.Query("SELECT * FROM pairs")
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		var p pair.Pair
		rows.Scan(&p.Id, &p.Name, &p.Val)

		pairs = append(pairs, p)
	}

	return pairs, nil
}

func (conn *PostgresRepository) Get(id int) (*pair.Pair, error) {
	stmt := `SELECT * FROM pairs WHERE id = $1`
	var p pair.Pair
	err := conn.DB.QueryRow(stmt, id).Scan(&p.Id, &p.Name, &p.Val)
	if err != nil {
		return nil, err
	}

	return &p, nil
}

func (conn *PostgresRepository) Create(p pair.Pair) (int, error) {
	stmt := `INSERT INTO pairs (name, value) VALUES ($1, $2) RETURNING id`
	var id int
	err := conn.DB.QueryRow(stmt, p.Name, p.Val).Scan(&id)
	if err != nil {
		slog.Error("insert failed", "error", err)
		return -1, fmt.Errorf("Insert failed: %w", err)
	}

	return id, nil
}
