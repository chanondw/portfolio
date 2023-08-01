package domainevents

import "fmt"

type UserEventMessage struct {
	UserID  int
	Message string
}

var _ EventMessage = UserEventMessage{}

func (u UserEventMessage) Print() {
	fmt.Println(u.UserID, " ", u.Message)
}
