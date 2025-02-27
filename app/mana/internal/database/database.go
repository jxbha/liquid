package database

import (
	"database/sql"
	"errors"
	"fmt"
	"log/slog"

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
	conn, err := sql.Open("pgx", "postgres://postgres:4454@localhost:5432/test?sslmode=disable")
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
	rows, err := conn.DB.Query("SELECT * FROM test")
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
	stmt := `SELECT * FROM test WHERE id = $1`
	var p Pair
	err := conn.DB.QueryRow(stmt, id).Scan(&p.Id, &p.Key, &p.Val)
	if err != nil {
		return Pair{}, errors.New("Not found")
	}

	return p, nil
}

func (conn *Connection) Create(p Pair) (int, error) {
	stmt := `INSERT INTO TEST (key, val) VALUES ($1, $2) RETURNING id`
	var id int
	err := conn.DB.QueryRow(stmt, p.Key, p.Val).Scan(&id)
	if err != nil {
		slog.Error("insert failed", "error", err)
		return -1, fmt.Errorf("Insert failed: %w", err)
	}

	return id, nil
}
