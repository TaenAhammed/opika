FROM golang:1.21.5-alpine3.19
LABEL maintainer="Taen Ahammmed"
LABEL email="taenahammed7@gmail.com"

WORKDIR /app
COPY go.mod .
COPY go.sum .
RUN go mod tidy
COPY . .
RUN go build .
EXPOSE 6000

CMD ["./go-service"]