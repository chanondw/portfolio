package domainevents

import "fmt"

type EventType string

const (
	UserCreateEvent EventType = "user-create"
)

type EventHandler func(EventMessage) error

type EventMessage interface {
	Print()
}

var registeredEvents map[EventType][]EventHandler

func init() {
	registeredEvents = map[EventType][]EventHandler{}
}

func Register(eventType EventType, handler EventHandler) {
	if registeredEvents[eventType] == nil {
		registeredEvents[eventType] = []EventHandler{}
	}

	registeredEvents[eventType] = append(registeredEvents[eventType], handler)
}

func RaiseEvent(eventType EventType, message EventMessage) {
	handlers := registeredEvents[eventType]
	for _, h := range handlers {
		if e := h(message); e != nil {
			fmt.Println(e)
		}
	}
}
