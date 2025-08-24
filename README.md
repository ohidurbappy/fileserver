# Go Fileserver

A simple, lightweight, and containerized file server built with Go.

## Description

This project provides a basic HTTP server that serves static files from a specified directory. It's designed to be run in a Docker container and is configurable via environment variables.

## Features

-   Serves static files over HTTP.
-   Configurable port and upload directory.
-   Containerized with Docker for easy deployment.
-   Multi-stage Docker build for a small final image size.
-   Includes a `docker-compose.yml` for easy setup.

## Getting Started

### Prerequisites

-   [Docker](https://docs.docker.com/get-docker/)
-   [Docker Compose](https://docs.docker.com/compose/install/) (optional, but recommended)

### Installation & Running

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/ohidurbappy/fileserver.git
    cd fileserver
    ```

2.  **Using Docker Compose (recommended):**

    ```bash
    docker-compose up -d
    ```

3.  **Using Docker:**

    ```bash
    docker build -t go-fileserver .
    docker run -d -p 3000:3000 -v $(pwd)/uploads:/app/uploads --name go-fileserver go-fileserver
    ```

## Usage

Once the server is running, you can access the files in the `uploads` directory by navigating to `http://localhost:3000/uploads/` in your browser.

Any files you place in the local `./uploads` directory will be accessible.

## Configuration

The following environment variables can be used to configure the server:

| Variable     | Description                  | Default     |
| ------------ | ---------------------------- | ----------- |
| `PORT`       | The port the server runs on. | `3000`      |
| `UPLOAD_DIR` | The directory to serve files from. | `./uploads` |

These can be set in the `docker-compose.yml` file or via the `-e` flag with `docker run`.
