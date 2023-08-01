package controllers

import (
	domainevents "domain-event/domain-events"
	"domain-event/services"
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

func init() {
	emailService := services.NewEmailService()

	allControllers = []Interface{
		&UserController{},
	}

	domainevents.Register(domainevents.UserCreateEvent, emailService.HandleUserCreateEvent)
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

func Error(w http.ResponseWriter, r *http.Request, status int, obj interface{}) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)

	if err := json.NewEncoder(w).Encode(obj); err != nil {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusInternalServerError)
		if err_ := json.NewEncoder(w).Encode("internal server error"); err_ != nil {
			fmt.Print(err)
		}
	}
}

func extractJSONBody(req *http.Request, out any) error {
	decoder := json.NewDecoder(req.Body)
	err := decoder.Decode(out)
	if err != nil {
		return err
	}

	return nil
}
