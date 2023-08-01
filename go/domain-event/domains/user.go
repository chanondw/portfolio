package domains

import (
	"context"
	domainevents "domain-event/domain-events"
	"fmt"
	"math/rand"
)

type User struct {
	ID        int    `json:"-"`
	FirstName string `json:"first_name"`
	LastName  string `json:"last_name"`
}

func (u *User) Create(ctx context.Context) (err error) {
	// Simulate ID generated from DB
	u.ID = rand.Intn(100)
	domainevents.RaiseEvent(
		domainevents.UserCreateEvent,
		domainevents.UserEventMessage{UserID: u.ID, Message: fmt.Sprintf("%s %s", u.FirstName, u.LastName)},
	)
	return nil
}
