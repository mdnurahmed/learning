package main

import (
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()
	r.GET("/ping", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "pong",
		})
	})

	podname := os.Getenv("MY_POD_NAME")
	nodename := os.Getenv("MY_NODE_NAME")
	podip := os.Getenv("MY_POD_IP")
	image := os.Getenv("MY_IMAGE")
	r.GET("/", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"app":       "frontend",
			"pod name":  podname,
			"node name": nodename,
			"pod ip":    podip,
			"image":     image,
		})
	})
	r.Run(":7070") // listen and serve on 0.0.0.0:8080 (for windows "localhost:8080")
}
