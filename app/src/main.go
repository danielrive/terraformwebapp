package main

import (
	"html/template"
	"log"
	"net/http"
	"time"
)

type Home struct {
	Name string
	Time string
}

var templates = template.Must(template.ParseFiles("../template/home.html"))

func view(w http.ResponseWriter, r *http.Request) {
	homeinfo := Home{"Anonymous", time.Now().Format(time.Stamp)}
	if name := r.FormValue("name"); name != "" {
		homeinfo.Name = name
	}
	if err := templates.ExecuteTemplate(w, "home.html", homeinfo); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func main() {
	http.HandleFunc("/", view)
	log.Fatal(http.ListenAndServe(":8080", nil))
}
