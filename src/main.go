package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

func main() {

	router := mux.NewRouter().StrictSlash(true)
	router.HandleFunc("/", Index)
	router.HandleFunc("/health", Health)

	fmt.Println("Running server!")
	log.Fatal(http.ListenAndServe(":8080", router))
}

func Index(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "dogs dogs dogs")
}

func Health(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, ":thumbsup:")
}
