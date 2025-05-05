FROM golang:1.24.2-alpine

# RUN apk update && apk upgrade --no-cache

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go install github.com/air-verse/air@latest

EXPOSE 8080

CMD ["go", "run", "main.go"]
