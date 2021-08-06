package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strconv"
)

var procRoot = "/proc"

func main() {

	flag.Parse()
	pid := flag.Arg(0)
	_, err := strconv.Atoi(pid)
	if err != nil {
		log.Fatalf("Non-int PID argument: %v", err)
	}
	procPath := filepath.Join(procRoot, pid, "exe")

	exePath, err := os.Readlink(procPath)
	if err != nil {
		log.Fatalf("Cannot evaluate symlink %s: %v", exePath, err)
	}
	procFsPath := filepath.Join(procRoot, pid, "root")
	exePath = filepath.Join(procFsPath, exePath)
	log.Printf("Path to executable: %s", exePath)

	format := "gdb -iex \"set sysroot %[1]s\" -iex \"set auto-load safe-path %[1]s\" -p %[2]s %[3]s"
	gdbCommandLine := fmt.Sprintf(format, procFsPath, pid, exePath)
	log.Printf("gdb command-line: %s", gdbCommandLine)
}
