package main

import (
	"log"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

type Values struct {
	UnSortedData []int `json:"unSortedData"`
	SortedData []int `json:"sortedData"`
}

func main() {
	gin.SetMode(gin.ReleaseMode)
	app := gin.Default()
	
	app.GET("/", func(c *gin.Context) {
		c.String(http.StatusOK, "Hello from the Go service!")
	})

	app.POST("/log", func (c *gin.Context) {

		var values Values
		if err := c.ShouldBindJSON(&values); err != nil {
			c.JSON(400, gin.H{"error": err.Error()})
			return
		}

		unSortedData := values.UnSortedData
		sortedData := values.SortedData

		log.Printf("Received: %v, Sorted: %v, Time: %v", unSortedData, sortedData, time.Now())

		c.JSON(http.StatusOK, gin.H{"status": "logged"})
	})

	app.Run(":6000")
}