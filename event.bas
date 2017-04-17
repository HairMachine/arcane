/'
' passed around as a dependency

dim eq as EventQueue

' adding to queue

type MyEventData extends object
	one as integer
	two as integer
	declare constructor(one as integer, two as integer)
end type
constructor MyEventData(one as integer, two as integer)
	this.one = one
	this.two = two
end constructor

'adding to queue

dim e as Event
e.name = "MyEvent"
e.data = new MyEventData(1, 2)
eq.add(e)

' getting from queue

dim myevent as Event = EventListener("MyEvent", eq)
dim mydata as MyEventData ptr = Cast(MyEventData ptr, myevent.data)
print mydata->one
print mydata->two
eq.remove(myevent)

print "Event queue has " + str(eq.count()) + " events."

'/

type Event
	name as string
	data as object ptr
	index as integer = -1
end type

type EventQueue
	queue(15) as Event
	declare sub add(e as Event)
	declare sub remove(e as Event)
	declare function count as integer
end type

declare function EventListener(event_name as string, eq as EventQueue) as Event

dim shared NULL_EVENT as Event

sub EventQueue.add(e as Event)
	for i as integer = 0 to ubound(this.queue)
		if this.queue(i).index = -1 then
			this.queue(i).index = i
			this.queue(i).name = e.name
			this.queue(i).data = e.data
			exit sub
		end if
	next
end sub

sub EventQueue.remove(e as Event)
	for i as integer = 0 to ubound(this.queue)
		if this.queue(i).index = e.index then
			this.queue(i) = NULL_EVENT
			exit sub
		end if
	next
end sub

function EventQueue.count() as integer
	dim c as integer
	for i as integer = 0 to ubound(this.queue)
		if this.queue(i).index <> -1 then c = c + 1
	next
	return c
end function

function EventListener(event_name as string, eq as EventQueue) as Event
	for i as integer = 0 to ubound(eq.queue)
		if eq.queue(i).name = event_name then
			return eq.queue(i)
		end if
	next
	return NULL_EVENT
end function
