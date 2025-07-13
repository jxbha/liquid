package handler

import (
	"database/sql"
	"encoding/json"
	"errors"
	"fmt"
	"jbernh/mana/internal/domain/pair"
	"log"
	"net/http"
	"strconv"
)

type Handler struct {
	repo Repository
}

type Repository interface {
	List() ([]pair.Pair, error)
	Get(id int) (*pair.Pair, error)
	Create(p pair.Pair) (int, error)
}

type RequestHandler interface {
	List(w http.ResponseWriter, r *http.Request)
	Get(w http.ResponseWriter, r *http.Request)
	Create(w http.ResponseWriter, r *http.Request)
	CheckAlive(w http.ResponseWriter, r *http.Request)
}

func NewHandler(repo Repository) *Handler {
	return &Handler{repo: repo}
}

func Index(w http.ResponseWriter, r *http.Request) {}

func (handler *Handler) List(w http.ResponseWriter, r *http.Request) {
	result, err := handler.repo.List()
	if err != nil {
		http.Error(w, err.Error(), 404)
	}
	for _, r := range result {
		fmt.Fprintf(w, "ID: %d\t%s\t%s\n", r.Id, r.Name, r.Val)
	}
}

func (handler *Handler) Get(w http.ResponseWriter, r *http.Request) {
	id, err := strconv.Atoi(r.PathValue("id"))
	if err != nil || id < 1 {
		// w.WriteHeader(http.StatusBadRequest)
		http.Error(w, "Error: please provide a valid ID", http.StatusBadRequest)
		return
	}

	result, err := handler.repo.Get(id)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			log.Printf("record not found: %v", err)
			http.Error(w, "ERROR:\tRecord not found", 404)
			return
		} else {
			log.Printf("database error: %v", err)
			http.Error(w, "ERROR:\tInternal server error", 500)
			return
		}
	}
	fmt.Fprintf(w, "ID: %d\t%s\t%s\n", result.Id, result.Name, result.Val)
}

func (handler *Handler) Create(w http.ResponseWriter, r *http.Request) {
	var p pair.Pair
	err := json.NewDecoder(r.Body).Decode(&p)
	// if things are nil- problem
	if err != nil || !p.IsValid() {
		http.Error(w, "error decoding JSON body; please provide a `name` and a `val`", http.StatusBadRequest)
	}

	_, err = handler.repo.Create(p)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func (handler *Handler) CheckAlive(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Yes, this works")
}
