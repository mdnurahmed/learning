package main

import (
	"fmt"
	"net/http"
	"sync"
)

func load(wg *sync.WaitGroup) {
	resp, err := http.Get("http://bookinfo.com/productpage")
	if err != nil {
		fmt.Println(err)
		wg.Done()
		return
	} else {
		if resp != nil {
			resp.Body.Close()
		}
		wg.Done()
	}
}
func main() {
	var wg sync.WaitGroup
	for {
		for i := 1; i <= 20000; i++ {
			wg.Add(1)
			go load(&wg)
		}
		wg.Wait()
	}
}
