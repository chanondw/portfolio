package domainevent

type EventHandler func(EventMessage)

type EventMessage interface {
	Print()
}
