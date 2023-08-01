package main

import (
	"domain-event/controllers"
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/go-chi/chi/v5"
)

func main() {
	handler := http.NotFoundHandler()
	handler = AddController(handler)

	fmt.Println("ready")
	http.ListenAndServe(":4000", handler)
}

func AddController(h http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		router, err := buildRouter()
		if err != nil {
			w.Header().Set("Content-Type", "application/json")
			w.WriteHeader(http.StatusInternalServerError)
			if err_ := json.NewEncoder(w).Encode("internal server error"); err_ != nil {
				fmt.Print(err)
			}
		} else {
			router.ServeHTTP(w, r)
		}
	})
}

func buildRouter() (http.Handler, error) {
	router := chi.NewRouter()

	if err := controllers.MountAll(router); err != nil {
		return nil, err
	}

	return router, nil
}
