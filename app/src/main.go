package main

import (
	"fmt"
	"log"
	"net/http"
)

func helloHandler(w http.ResponseWriter, r *http.Request) {
	if r.URL.Path != "/home" {
		http.Error(w, "404 not found.", http.StatusNotFound)
		return
	}

	// if r.Method != "GET" {
	//     http.Error(w, "Method is not supported.", http.StatusNotFound)
	//     return
	// }
	fmt.Fprintf(w, "Hello!")
}

func main() {
	// get env variables

	http.HandleFunc("/home", helloHandler)

	log.Fatal(http.ListenAndServe(":9090", nil))
}
