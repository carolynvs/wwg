# Let's Talk About Go Types

# https://carolynvs.github.io/wwg/go-types

---

# Setup
1. Make a new directory in your GOPATH for the workshop, e.g. `~/go/src/workshop`.
1. Open your favorite Go editor.

---

# Distance Function

Create a directory named geometry, with a file named `main.go`.

Now we will write a go function that calculates distance between two points:

```go
package main

import (
	"fmt"
	"math"
)

func distance(x1, y1, x2, y2 float64) float64 {
	dx := x2 - x1
	dy := y2 - y1
	return math.Sqrt(math.Pow(dx, 2) + math.Pow(dy, 2))
}

func main() {
	d := distance(0, 0, 0, 4)
	fmt.Printf("distance: %v\n", d)
}

```
___

# Point Type

Let's make a type called point

```go
type point struct {
  x, y float64
}
```

Now change the distance function to use points.

# To OOP or not to OOP

Is this OOP?

```go
p1 := point{0, 0}
p2 := point {0, 4}
distance(p1, p2)
```

See http://spf13.com/post/is-go-object-oriented/ for a deeper debate.


Is this more OOP-y?
```go
p1 := point{0, 0}
p2 := point {0, 4}
p2.Subtract(p1)
```

---

## Carolyn's Law of Getting Stuff Done
We can define a structure to hold data, and provide associated functions to work with it, so .... CLOSE ENOUGH

---

## Move Function
Now let's make a function that modifies our point:

```go
func (p point) Move(dx, dy float64) {
  p.x += dx
  p.y += dy
}

func main() {
  p1 := point{0, 0}

  p1.Move(1,1)
  fmt.Printf("%#v", p1)
}
```

_Wait! Why didn't that do anything?_
It may help to know what the compiler is _really_ doing...

```go
func Move(p point, dx, dy float64) {
  // notice that it is passing in a **copy** of the struct
}
```

Let's fix it by using a "pointer receiver":
```go
func (p *point) Move(dx, dy float64) {
  p.x += dx
  p.y += dy
}
```

yay! now it works
tldr: if you want to modify the struct, the receiver should be a pointer

---

# Circle

Let's make another type:
```go
type circle struct {
  x,y float64
  radius float64
}
```

Now let's move the circle:

```go
func (c *circle) Move(dx, dy float64) {
  c.x += dx
  c.y += dy
}
```

Anyone else thing this is a bit copy/paste?

---

## Composition
go doesn't have inheritance, but I can compose a type using other types

```
type circle struct {
  *point
  radius int
}

func main() {
  p := circle{}
  p.Move(1,1)
  fmt.Printf("%#v")
}
```

## Ah! Pointers!

We have a few options: 
* Make move treat nil points as 0,0
* Set the point when we make it
* Use a constructor

--

## Line

OK! Now let's make _more_ types!

```go
type line struct {
  start, stop point
}
```

Let's make it move too!

Uh, oh, we can't magically use point.Move for free anymore...

```go
func (l *line) Move(dx, dy float64) {
  start.Move(dx, dy)
  stop.Move(dx, dy)
}
```

# Interfaces
What if I want to be able to move anything? 🤔

```go
type shape interface {
  Move(dx, dy float64)
}
```

I don't have to change the types!

```go
var s shape

s = &point{}
s.Move(1,1)

s = &line{&point{0, 0}, &point{1, 1}}
s.Move(2,2)
```

_Why did I use pointers for point and line?_ 🤔
Best Practice: Assign pointers to interface varibles, because most things you implement will be mutable, and will have pointer recivers.

...

Yes, Go is very silly. 😆

---

# Built-in Interfaces
Here's a very useful interface: `fmt.Stringer`

```go
func (p point) String() string {
  return fmt.Printf("(%s, %s)", p.x, p.y)
}

func main() {
  p := point{}
  fmt.Println(p)

  c := circle{radius: 5}
  fmt.Println(c)
}
```

# Casting
_What type am I working with?_ 🤔

sometimes you need to know what you are dealing with
* casting
* switch

extending a type from another package

```go
package main

import "fmt"

type color string

const (
	  red color = "\x1b[31;1m"
	    blue color = "\x1b[34;1m"
    )

    func (c color) Println(msg string) {
	      fmt.Printf("%s%s\n", c, msg)
      }

func main() {
	red.Println("hi")
	blue.Println("bye")
}

```

best practices
* when to use a pointer or the struct for the receiver?
  * ease of use
  * memory usage (stack v. heap)
* when to define an interface?
  * you have more than 1 thing that does the same thing
  * saving a file to an api, to a database, to the filesystem
