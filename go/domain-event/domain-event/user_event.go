package domainevent

import "fmt"

type UserEvent struct {
	registeredEvents []EventHandler
}

type UserEventMessage struct {
	UserID  int
	Message string
}

func (u UserEventMessage) Print() {
	fmt.Println(u.UserID)
}

var _userEvent = UserEvent{}

func (u *UserEvent) Register(handler EventHandler) {
	u.registeredEvents = append(u.registeredEvents, handler)
}
