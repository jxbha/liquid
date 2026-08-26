package main

import (
	"fmt"
	"jbernh/mana/internal/database"
	"jbernh/mana/internal/handler"
	"jbernh/mana/internal/router"
	"net/http"
)

func main() {
	fmt.Println("setting things up...")
	cfg, err := database.LoadConfig()
	if err != nil {
		panic(err)
	}
	db, err := database.NewDB(cfg)
	if err != nil {
		fmt.Println(err)
		panic(err)
	}
	defer db.Close()
	pgrepo := database.NewPostgresRepository(db)
	h := handler.NewHandler(pgrepo)
	port := ":4040"
	fmt.Printf("serving on port %s...", port)
	http.ListenAndServe(port, router.Routes(h))
}
