package database

import (
	"database/sql"
	"errors"
	"fmt"
	"log/slog"
	"os"

	_ "github.com/jackc/pgx/v5/stdlib"
)

type Pair struct {
	Id  int
	Key string
	Val string
}

type Connection struct {
	DB *sql.DB
}

func NewDB() (*Connection, error) {
	DATABASE_UN := os.Getenv("DATABASE_UN")
	DATABASE_PW := os.Getenv("DATABASE_PW")
	DATABASE_HOST := os.Getenv("DATABASE_HOST")
	URI := fmt.Sprintf("postgres://%v:%v@%v", DATABASE_UN, DATABASE_PW, DATABASE_HOST)

	conn, err := sql.Open("pgx", URI)

	if err != nil {
		return nil, err
	}

	err = conn.Ping()
	if err != nil {
		return nil, err
	}
	return &Connection{DB: conn}, nil
}

func (conn *Connection) List() ([]Pair, error) {
	pairs := []Pair{}
	rows, err := conn.DB.Query("SELECT * FROM persist")
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		var p Pair
		rows.Scan(&p.Id, &p.Key, &p.Val)

		pairs = append(pairs, p)
	}

	return pairs, nil
}

func (conn *Connection) Get(id int) (Pair, error) {
	stmt := `SELECT * FROM persist WHERE id = $1`
	var p Pair
	err := conn.DB.QueryRow(stmt, id).Scan(&p.Id, &p.Key, &p.Val)
	if err != nil {
		return Pair{}, errors.New("Not found")
	}

	return p, nil
}

func (conn *Connection) Create(p Pair) (int, error) {
	stmt := `INSERT INTO persist (key, value) VALUES ($1, $2) RETURNING id`
	var id int
	err := conn.DB.QueryRow(stmt, p.Key, p.Val).Scan(&id)
	if err != nil {
		slog.Error("insert failed", "error", err)
		return -1, fmt.Errorf("Insert failed: %w", err)
	}

	return id, nil
}
