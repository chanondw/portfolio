package controllers

import (
	"domain-event/domains"
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
	usrDomain := domains.User{}
	if err := extractJSONBody(r, &usrDomain); err != nil {
		// Error class should be more refined in real case scenario
		// simplifying it for since it is not the main focus of this project
		Error(w, r, http.StatusInternalServerError, err)
		return
	}

	usrDomain.Create(r.Context())
	Render(w, r, "OK")
}
