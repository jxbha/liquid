package handler

import (
	"encoding/json"
	"fmt"
	"jbernh/mana/internal/database"
	"net/http"
	"strconv"
)

type Handler struct {
	db *database.Connection
}

type RequestHandler interface {
	List(w http.ResponseWriter, r *http.Request)
	Get(w http.ResponseWriter, r *http.Request)
	Create(w http.ResponseWriter, r *http.Request)
}

func NewHandler(db *database.Connection) *Handler {
	return &Handler{db: db}
}

func Index(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w, "Yes")
}

func (handler *Handler) List(w http.ResponseWriter, r *http.Request) {
	result, _ := handler.db.List()
	for _, r := range result {
		fmt.Fprintf(w, "ID: %d\t%s\t%s\n", r.Id, r.Key, r.Val)
	}
}

func (handler *Handler) Get(w http.ResponseWriter, r *http.Request) {
	id, err := strconv.Atoi(r.PathValue("id"))
	if err != nil || id < 1 {
		http.NotFound(w, r)
		return
	}

	result, err := handler.db.Get(id)
	if err != nil {
		http.Error(w, "ERROR:\tRecord not found", 500)
		return
	}
	fmt.Fprintf(w, "ID: %d\t%s\t%s\n", result.Id, result.Key, result.Val)
}

func (handler *Handler) Create(w http.ResponseWriter, r *http.Request) {
	var p database.Pair
	err := json.NewDecoder(r.Body).Decode(&p)
	if err != nil {
		fmt.Fprint(w, http.StatusBadRequest)
	}

	handler.db.Create(p)

}
