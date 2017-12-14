# Let's Talk About Go Types

<h2 style="text-align: center"><a href="http://carolynvs.com/go-types">http://carolynvs.com/go-types</a></h2>

---

# Setup
1. Make a new directory in your GOPATH for the workshop, e.g. `~/go/src/geometry`.
1. Open your favorite Go editor.
1. Add a file named `main.go`.

If you don't have Go setup on your computer, you can do the exercises on the Go Playground. Just click the link above each code sample.

---

# Distance Function

First we will write a go function that calculates distance between two points:

[Play](https://play.golang.org/p/dxx9jIfaI_)
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

Let's make a type called point:

```go
type point struct {
  x, y float64
}
```

Now change the distance function to use points.

[Play](https://play.golang.org/p/9GeZBIMIQr)

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

[Play](https://play.golang.org/p/4wKbaIlLXV)
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

[Play](https://play.golang.org/p/UUAw1OV5dM)
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
Go doesn't have inheritance, but I can compose a type using other types:

[Play](https://play.golang.org/p/WHPPNw7Vko)
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

---

## Ah! Pointers!

We have a few options: 
* Make move treat nil points as 0,0
* Set the point when we make it
* Use a constructor

--

## Line

OK! Now let's make _more_ types!

[Play](https://play.golang.org/p/AU0uefP7Qp)
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

[Play](https://play.golang.org/p/A87Ytz8jAa)
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
**Tip**: Assign pointers to interface varibles, because most things you implement will be mutable, and will have pointer recivers.

...

Yes, Go is _very_ silly. 😆

---

# Built-in Interfaces
Here's a very useful interface: `fmt.Stringer`

[Play](https://play.golang.org/p/7eaXTE5FjE)
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

# Extending Types
You can "extend" a type from another package!

[Play](https://play.golang.org/p/gM0SqPffef)
```go
package main

import "fmt"

type color string

const (
	red  color = "\x1b[31;1m"
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

This is very useful for creating enums.

# Casting
_What type am I working with?_ 🤔

[Play](https://play.golang.org/p/Gte_EqrzPD)
```go
func main() {
	var s shape
	s = &point{}

	p, ok := s.(*point)
	if ok {
		fmt.Printf("Yay! It's a point!\n%s\n", p)
  }
  
  _, ok = s.(*line)
  if !ok {
    fmt.Println("It is NOT a line")
  }
}
```

Use a `switch` to check multiple types at once:

[Play](https://play.golang.org/p/sC1Re3yNWf)
```go
func printType(s shape) {
	switch v := s.(type) {
	case *point:
		fmt.Printf("I'm a point! %s\n", v)
	case *line:
		fmt.Printf("I'm a line! %s\n", v)
	}
}

func main() {
	printType(&point{1, 1})
	printType(&line{&point{0, 0}, &point{1, 1}})
}
```

# Go Forth and Play!

![gophers building stuff](https://raw.githubusercontent.com/ashleymcnamara/gophers/master/GoBuild.png)