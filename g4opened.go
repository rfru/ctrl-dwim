package main

import (
	"fmt"
	"os"
	"os/exec"
	"strings"
)

func main() {
	cwd, err := os.Getwd()
	if err != nil {
		return
	}
	if !strings.HasPrefix(cwd, "/google/src/cloud") {
		return
	}

	cmd := exec.Command("sh", "-c", "g4 opened | sed 's/#.*//' | g4 -x - where | awk '/^\\// {print $3}'")

	out, err := cmd.Output()

	if err != nil {
		return
	}

	strOut := string(out)
	fmt.Print(strOut)
}
