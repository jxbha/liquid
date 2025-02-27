package main

import (
	"fmt"
	"jbernh/mana/internal/database"
	"jbernh/mana/internal/handler"
	"jbernh/mana/internal/router"
	"net/http"
)

func main() {
	db, err := database.NewDB()
	if err != nil {
		fmt.Println(err)
	}
	defer db.DB.Close()
	newHandler := handler.NewHandler(db)
	var h handler.RequestHandler = newHandler

	http.ListenAndServe(":4040", router.Routes(h))
}
