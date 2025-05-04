package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/joho/godotenv"
)

func homeHandler(w http.ResponseWriter, r *http.Request) {
	// @ todo dynamic port from .env
	w.Header().Set("Access-Control-Allow-Origin", "http://localhost:8080")
	w.Header().Set("Content-Type", "application/json")
	response := map[string]string{"message": "Welcome to the API!"}
	json.NewEncoder(w).Encode(response)
}

func statusHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	response := map[string]string{"message": "OK"}
	json.NewEncoder(w).Encode(response)
}

func main() {
	// Load .env file if present
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found, using default settings.")
	}

	// Get PORT from environment, default to 8080
	port := os.Getenv("PORT")
	if port == "" {
		port = "8081"
	}

	// Basic routes
	http.HandleFunc("/", homeHandler)
	http.HandleFunc("/status", statusHandler)

	fmt.Println("Server running at http://localhost:" + port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}
