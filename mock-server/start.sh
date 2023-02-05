docker run -ti -p 8080:8080 --name mock-server \
    -v $(pwd)/config:/opt/imposter/config \
    outofcoffee/imposter-openapi
