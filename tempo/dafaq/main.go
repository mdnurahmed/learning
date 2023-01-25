// package main

// import (
// 	"fmt"
// 	"net/http"
// )

// func main() {
// 	http.HandleFunc("/", HelloServer)
// 	http.ListenAndServe(":7080", nil)
// }

// func HelloServer(w http.ResponseWriter, r *http.Request) {
// 	fmt.Fprintf(w, "Hello, %s!", r.URL.Path[1:])
// }

package main

import (
	"context"
	"errors"
	"log"
	"net/http"
	"os"
	"os/signal"

	"dafaq/config"
	"dafaq/utils"

	"github.com/gorilla/mux"
	"github.com/rs/cors"
	"go.opencensus.io/trace"
	"go.opentelemetry.io/contrib/instrumentation/github.com/gorilla/mux/otelmux"
)

const serviceName = "order-service"

var (
	srv    *http.Server
	tracer trace.Tracer
)

var orderUrl = "localhost:8082"

func getUser(w http.ResponseWriter, r *http.Request) {
	var u = "hi"
	utils.WriteResponse(w, http.StatusOK, u)
}

func setupServer() {
	router := mux.NewRouter()
	router.HandleFunc("/orders", getUser).Methods(http.MethodGet, http.MethodOptions)
	router.Use(utils.LoggingMW)
	router.Use(otelmux.Middleware(serviceName))
	c := cors.New(cors.Options{
		AllowedOrigins: []string{"*"},
		AllowedMethods: []string{http.MethodGet, http.MethodPut, http.MethodPost},
	})

	srv = &http.Server{
		Addr:    orderUrl,
		Handler: c.Handler(router),
	}

	log.Printf("Order service running at: %s", orderUrl)
	if err := srv.ListenAndServe(); !errors.Is(err, http.ErrServerClosed) {
		log.Fatalf("failed to setup http server: %v", err)
	}
}
func main() {
	// setup tracer
	tp := config.Init(serviceName)
	defer func() {
		if err := tp.Shutdown(context.Background()); err != nil {
			log.Printf("Error shutting down tracer provider: %v", err)
		}
	}()

	sigint := make(chan os.Signal, 1)
	signal.Notify(sigint, os.Interrupt)

	go setupServer()

	<-sigint
	if err := srv.Shutdown(context.Background()); err != nil {
		log.Printf("HTTP server shutdown failed")
	}
}
