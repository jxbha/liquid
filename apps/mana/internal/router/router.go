package router

import (
	handler "jbernh/mana/internal/handler"
	"net/http"
)

func Routes(h handler.RequestHandler) *http.ServeMux {
	mux := http.NewServeMux()
	mux.HandleFunc("/", h.List)
	mux.HandleFunc("/pairs/{id}", h.Get)
	mux.HandleFunc("/create", h.Create)
	mux.HandleFunc("/livez", h.CheckAlive)

	return mux
}
