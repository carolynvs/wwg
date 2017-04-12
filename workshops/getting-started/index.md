---
---

# Intro to Golang, setting up & saying "Hello World!!!"
## 1. Install Golang itself
### Windows
[Golang Downloads](https://golang.org/dl/)

> MSI installer

> Open the MSI file and follow the prompts to install the Go tools. By default, the installer puts the Go distribution in `Cs:\Go`.

> The installer should put the `C:\Go\bin` directory in your PATH environment variable. You may need to restart any open command prompts for the change to take effect.
> Setting environment variables under Windows

> Under Windows, you may set environment variables through the "Environment Variables" button on the "Advanced" tab of the "System" control panel. Some versions of Windows provide this control panel through the "Advanced System Settings" option inside the "System" control panel.

### Macintosh
[Golang Downloads](https://golang.org/dl/)

> Mac OS X package installer

> Download the package file, open it, and follow the prompts to install the Go tools. The package installs the Go distribution to /usr/local/go.

> The package should put the /usr/local/go/bin directory in your PATH environment variable. You may need to restart any open Terminal sessions for the change to take effect.

### Linux
[Golang Downloads](https://golang.org/dl/)

> Linux, Mac OS X, and FreeBSD tarballs

> Download the archive and extract it into /usr/local, creating a Go tree in /usr/local/go. For example:

> `tar -C /usr/local -xzf go1.8.linux-amd64.tar.gz`

> (Typically these commands must be run as root or through sudo.)

> Add /usr/local/go/bin to the PATH environment variable. You can do this by adding this line to your /etc/profile (for a system-wide installation) or $HOME/.profile:

> `export PATH=$PATH:/usr/local/go/bin`

## 2. Installing VS code
### Windows
- [VS Code Link](https://code.visualstudio.com/)

    1. Download the Visual Studio Code installer for Windows.
    2. Once it is downloaded, run the installer (VSCodeSetup-version.exe). This will only take a minute.
    3. By default, VS Code is installed under `C:\Program Files (x86)\Microsoft VS Code` for a 64-bit machine.

### Macintosh
- [VS Code Link](https://code.visualstudio.com/)

    1. Download Visual Studio Code for Mac.
    2. Double-click on the downloaded archive to expand the contents.
    3. Drag Visual Studio Code.app to the Applications folder, making it available in the Launchpad.
    4. Add VS Code to your Dock by right-clicking on the icon and choosing Options, Keep in Dock.

### Linux
- [VS Code Link](https://code.visualstudio.com/)

- Debian based

```bash
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] http://packages.microsoft.com/repos/vscod
 stable main" > /etc/apt/sources.list.d/vscode.list'
```

- Redhat based

```bash
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio \
Code\nbaseurl=https://packages.microsoft.\
com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.\
com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
```

```bash
dnf check-update
sudo dnf install code
```

```bash
yum check-update
sudo yum install code
```

## 3. Installing Golang & Code Runner plugins
### Go Plugin
[Go plugin](https://marketplace.visualstudio.com/items?itemName=lukehoban.Go)

>  Launch VS Code Quick Open (Ctrl+P), paste the following command, and press enter.
> `ext install Go`
> This will pull up a selection menu of packages you  can install, choose "Go" by lukehoban

The Go plugin gives easy support for code code highlighting and for running test suites, but it doesn't provide a simple "run my code snippet". Since we want that for some easy early iterating, let's also install Code Runner.

### Code Runner plugin
[Code Runner plugin](https://marketplace.visualstudio.com/items?itemName=formulahendry.code-runner)

> Launch VS Code Quick Open (Ctrl+P), paste the following command, and press enter.
> `ext install code-runner`
> This will pull up a selection menu of packages you  can install, choose "Code  Runner" by Jun Han

Code Runner gives us a simple in-editor script runner. It works for a fairly large range of scripted & compiled languages, not just Golang. It can also be setup to run custom commands. Output is displayed in a pane under the text editor by default.

## 4. Writing Helloworld app
### Setting up your workspace

1. Create a folder named `hello`.
2. Inside of the folder, create `main.go` and paste in the file contents below.
3. Open folder in VS Code via the menus with **File > Open Folder** or **ctrl-k ctrl-o**.
4. Use **ctrl-\`** to open the VS code terminal to run commands below. _The backtick key is left of the 1 key._

NOTE: For this exercise, using your GOPATH shouldn't matter. However, having your source code located under the GOPATH is important for the commands such as `go get` and `go install`.

### Writing main.go
```go
package main

import "fmt"

func main() {
    fmt.Println("Hello World!")
}
```

### Ways to run your program
Run directly in VS Code:

1. Press `ctrl-alt-j`.
2. Select the "go" programming language.
3. Re-run code after modifying with `ctrl-alt-n`.

Run manually:
```bash
go run main.go
```

Compile and run a binary:
```bash
go build
./hello
```

## 5. Basic Go Syntax

Let's get familiar with go syntax!

### Declare Variables

```go
// Declare a variable for later
var x int

// Declare and assign immediately
var x int = 1

// Declare multiple variables at once!
var x, y int
```

### Types
There are lots of types:

* int
* string
* bool
* []string - Array of strings
* map[string]string - Dictionary or Map of string => string

### Assign Variables

```go
// Declare and assign, this is the most common usage
x := 1

// Assign multiple variables
x, y := DoSomething()
```

### Importing packages
There are many built-in packages, `fmt` lets you write to the console.

```go
package main

import (
	"fmt"
)

func main() {
	fmt.Println("Hello, playground")
}
```

### Arrays and Slices
* Arrays have a fixed length.
* Slices are similar to vectors or lists in other languages. Use these.

```go
colors := []string{"red", "blue"}

// range returns two variables: index and item
for i, color := range colors {
  fmt.Printf("[%d] = %s\n", i, color)
}

// You can ignore the index with an underscore
for _, color := range colors {
  fmt.Println(color)
}

// You can also directly index the elements in the array/slice
for i:=0; i < len(colors); i++ {
  color := colors[i]
  fmt.Println(color)
}
```

### Maps

```go
colors := map[string]string {
  "red": "FF0000",
  "blue": "0000FF",
  "green": "00FF00",
}

// range returns two values: key and value
for color, hex := range colors {
  fmt.Printf("[%s] = %s\n", color, hex)
}
```

### Functions

```go
package main

import "fmt"

func main() {
	x, y := GetStartingCoordinates()
	fmt.Printf("Starting at (%d, %d)\n", x, y)

	if IsDone() {
		SaySomething("All Done!")
	}
}

// This function doesn't return anything
func SaySomething(message string) {
  fmt.Println(message)
}

// This function returns a boolean value
func IsDone() bool {
  return true
}

// This function returns multiple values
func GetStartingCoordinates() (int, int) {
  return 0, 0
}
```

For more go adventures, follow the [Go Tour](https://tour.golang.org/list)!
