package services

import (
	domainevents "domain-event/domain-events"
	"fmt"
)

type EmailService interface {
	HandleUserCreateEvent(message domainevents.EventMessage) error
}

func NewEmailService() EmailService {
	return &emailService{}
}

type emailService struct {
}

func (e *emailService) HandleUserCreateEvent(message domainevents.EventMessage) error {
	fmt.Println("[emailService] message received: user create event")
	message.Print()
	return nil
}
