package controllers

import (
	"fmt"
	"net/http"

	"github.com/go-chi/chi/v5"
)

type UserController struct {
}

func (u *UserController) Mount(r chi.Router) error {
	r.Route("/api/v1/user", func(r chi.Router) {
		r.Post("/create", u.Create)
	})

	return nil
}

func (u *UserController) Create(w http.ResponseWriter, r *http.Request) {
	fmt.Println("creating user")

	Render(w, r, "OK")
}
