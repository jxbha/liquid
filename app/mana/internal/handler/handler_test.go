package handler_test

import (
	"database/sql"
	"fmt"
	"jbernh/mana/internal/domain/pair"
	handler "jbernh/mana/internal/handler"
	router "jbernh/mana/internal/router"
	"net/http"
	"net/http/httptest"
	"testing"
)

type RepositoryStub struct{}

func (rs *RepositoryStub) List() ([]pair.Pair, error) {
	return []pair.Pair{{Id: 1, Name: "Distraught", Val: "Joy"}, {Id: 2, Name: "Treasured", Val: "Pain"}}, nil
}
func (rs *RepositoryStub) Get(id int) (*pair.Pair, error) {
	if id == 999 {
		return &pair.Pair{}, sql.ErrNoRows
	}
	return &pair.Pair{Id: 1, Name: "Distraught", Val: "Joy"}, nil
}
func (rs *RepositoryStub) Create(p pair.Pair) (int, error) {
	return 1, nil
}

func TestGet(t *testing.T) {
	rs := &RepositoryStub{}
	resp := httptest.NewRecorder()
	handler := handler.NewHandler(rs)
	t.Run("valid ID", func(t *testing.T) {
		req := httptest.NewRequest(http.MethodGet, "/view/1", nil)
		router.Routes(handler).ServeHTTP(resp, req)

		got := resp.Body.String()
		want := fmt.Sprintf("ID: %d\t%s\t%s\n", 1, "Distraught", "Joy")
		assertResponseBody(t, got, want)
	})
	t.Run("negative ID", func(t *testing.T) {
		req := httptest.NewRequest(http.MethodGet, "/view/-1", nil)
		router.Routes(handler).ServeHTTP(resp, req)

		got := resp.Code
		want := http.StatusBadRequest
		assertResponseCode(t, got, want)
	})
	t.Run("non-numeric ID", func(t *testing.T) {
		req := httptest.NewRequest(http.MethodGet, "/view/INVALID", nil)
		router.Routes(handler).ServeHTTP(resp, req)

		got := resp.Code
		want := http.StatusBadRequest
		assertResponseCode(t, got, want)
	})
	t.Run("missing ID", func(t *testing.T) {
		req := httptest.NewRequest(http.MethodGet, "/view/999", nil)
		router.Routes(handler).ServeHTTP(resp, req)

		got := resp.Code
		want := http.StatusNotFound
		assertResponseCode(t, got, want)
	})
}

func TestCreate(t *testing.T) {}

func assertResponseBody(t testing.TB, got, want string) {
	t.Helper()
	if got != want {
		t.Errorf("got %q, want %q", got, want)
	}
}

func assertResponseCode(t testing.TB, got, want int) {
	t.Helper()
	if got != want {
		t.Errorf("got %d, want %d", got, want)
	}
}
