package handler_test

import (
	"bytes"
	"database/sql"
	"encoding/json"
	"fmt"
	"io"
	"jbernh/mana/internal/domain/pair"
	"jbernh/mana/internal/handler"
	"jbernh/mana/internal/router"
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
func (rs *RepositoryStub) Create(p pair.Pair) (*pair.Pair, error) {
	return &pair.Pair{Id: 1, Name: p.Name, Val: p.Val}, nil
}

func TestURL(t *testing.T) {}

func TestGet(t *testing.T) {
	rs := &RepositoryStub{}
	t.Run("valid ID", func(t *testing.T) {
		req := httptest.NewRequest(http.MethodGet, "/pairs/1", nil)
		resp := httptest.NewRecorder()
		handler := handler.NewHandler(rs)
		router.Routes(handler).ServeHTTP(resp, req)

		got := resp.Body.String()
		want := fmt.Sprintf("ID: %d\t%s\t%s\n", 1, "Distraught", "Joy")
		assertResponseString(t, got, want)
	})
	t.Run("negative ID", func(t *testing.T) {
		req := httptest.NewRequest(http.MethodGet, "/pairs/-1", nil)
		resp := httptest.NewRecorder()
		handler := handler.NewHandler(rs)
		router.Routes(handler).ServeHTTP(resp, req)

		got := resp.Code
		want := http.StatusBadRequest
		assertResponseCode(t, got, want)
	})
	t.Run("non-numeric ID", func(t *testing.T) {
		req := httptest.NewRequest(http.MethodGet, "/pairs/INVALID", nil)
		resp := httptest.NewRecorder()
		handler := handler.NewHandler(rs)
		router.Routes(handler).ServeHTTP(resp, req)

		got := resp.Code
		want := http.StatusBadRequest
		assertResponseCode(t, got, want)
	})
	t.Run("missing ID", func(t *testing.T) {
		req := httptest.NewRequest(http.MethodGet, "/pairs/999", nil)
		resp := httptest.NewRecorder()
		handler := handler.NewHandler(rs)
		router.Routes(handler).ServeHTTP(resp, req)

		got := resp.Code
		want := http.StatusNotFound
		assertResponseCode(t, got, want)
	})
}

func TestCreate(t *testing.T) {
	rs := &RepositoryStub{}
	handler := handler.NewHandler(rs)
	t.Run("happy", func(t *testing.T) {
		req := httptest.NewRequest(http.MethodPost, "/create", nil)
		req.Body = io.NopCloser(bytes.NewReader([]byte(`{"name": "mimicked", "val": "attempt"}`)))
		resp := httptest.NewRecorder()
		router.Routes(handler).ServeHTTP(resp, req)

		// status code
		status_got := resp.Code
		status_want := http.StatusCreated
		assertResponseCreate(t, status_got, status_want)

		// location
		location_got := "/pairs/1"
		location_want := resp.Header().Get("Location")
		assertResponseString(t, location_got, location_want)

		// data
		var p pair.Pair
		json.NewDecoder(resp.Body).Decode(&p)
		data_got := p.Val
		data_want := "attempt"
		assertResponseString(t, data_got, data_want)
	})

	t.Run("provided id", func(t *testing.T) {
		req := httptest.NewRequest(http.MethodPost, "/create", nil)
		req.Body = io.NopCloser(bytes.NewReader([]byte(`{"id": 55, "name": "mimicked", "val": "attempt"}`)))
		resp := httptest.NewRecorder()
		router.Routes(handler).ServeHTTP(resp, req)

		// status code
		status_got := resp.Code
		status_want := http.StatusBadRequest
		assertResponseCreate(t, status_got, status_want)
	})

	t.Run("bad name", func(t *testing.T) {
		req := httptest.NewRequest(http.MethodPost, "/create", nil)
		req.Body = io.NopCloser(bytes.NewReader([]byte(`does this even matter?`)))
		resp := httptest.NewRecorder()
		router.Routes(handler).ServeHTTP(resp, req)

		// status code
		status_got := resp.Code
		status_want := http.StatusBadRequest
		assertResponseCreate(t, status_got, status_want)
	})

	t.Run("bad val", func(t *testing.T) {
		req := httptest.NewRequest(http.MethodPost, "/create", nil)
		req.Body = io.NopCloser(bytes.NewReader([]byte(`{"name": "mimicked", "vaal": "attempt"}`)))
		resp := httptest.NewRecorder()
		router.Routes(handler).ServeHTTP(resp, req)

		// status code
		status_got := resp.Code
		status_want := http.StatusBadRequest
		assertResponseCreate(t, status_got, status_want)
	})
}

func assertResponseString(t testing.TB, got, want string) {
	t.Helper()
	if got != want {
		t.Errorf("got %q, want %q", got, want)
	}
}

func assertResponseCreate(t testing.TB, got, want int) {
	t.Helper()
	if got != want {
		t.Errorf("got %d, want %d", got, want)
	}
}

func assertResponseCode(t testing.TB, got, want int) {
	t.Helper()
	if got != want {
		t.Errorf("got %d, want %d", got, want)
	}
}
