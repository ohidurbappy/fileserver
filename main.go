package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

func main() {
	// Get env variables with fallback
	uploadDir := getEnv("UPLOAD_DIR", "./uploads")
	port := getEnv("PORT", "3000")

	// Serve static files from uploadDir
	fs := http.FileServer(http.Dir(uploadDir))
	http.Handle("/uploads/", http.StripPrefix("/uploads/", fs))

	// Start server
	addr := ":" + port
	fmt.Printf("Serving %s at http://localhost%s/uploads/\n", uploadDir, addr)
	if err := http.ListenAndServe(addr, nil); err != nil {
		log.Fatalf("Server failed: %v", err)
	}
}

// helper function to read env with fallback
func getEnv(key, fallback string) string {
	if value, exists := os.LookupEnv(key); exists && value != "" {
		return value
	}
	return fallback
}
