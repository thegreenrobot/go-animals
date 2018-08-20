package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

func main() {

	router := mux.NewRouter().StrictSlash(true)
	router.HandleFunc("/", Index)
	router.HandleFunc("/health", Health)
	router.HandleFunc("/version", Version)

	fmt.Println("Running server!")
	log.Fatal(http.ListenAndServe(":8080", router))
}

func Index(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "dogs dogs dogs")
}

func Health(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, ":thumbsup:")
}

func Version(w http.ResponseWriter, r *http.Request) {
	data, err := ioutil.ReadFile("version.txt")
	if err != nil {
		log.Fatal(err)
	}

	version := string(data)

	fmt.Fprintln(w, version)
}
