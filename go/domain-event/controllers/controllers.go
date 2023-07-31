package controllers

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/go-chi/chi/v5"
)

type Interface interface {
	Mount(router chi.Router) error
}

var allControllers = []Interface{
	&UserController{},
}

func MountAll(router chi.Router) error {
	for _, v := range allControllers {
		if err := v.Mount(router); err != nil {
			return err
		}
	}

	return nil
}

func Render(w http.ResponseWriter, r *http.Request, obj interface{}) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(200)

	if err := json.NewEncoder(w).Encode(obj); err != nil {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusInternalServerError)
		if err_ := json.NewEncoder(w).Encode("internal server error"); err_ != nil {
			fmt.Print(err)
		}
	}
}
