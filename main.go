package main

import (
    "fmt"
    "net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hello from Weave-Go API!")
}

func main() {
    http.HandleFunc("/", handler)
    fmt.Println("Starting Weave-Go API on port 8080...")
    http.ListenAndServe(":8080", nil)
}
