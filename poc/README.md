# AWV Trafic Data Implementation
1. Set correct permissions for the EPSG database location:
    ```bash
    mkdir -p ./server/tmp/epsg
    chmod -R 0777 ./server/tmp
    ```

2. Start all systems and wait until they are available:
    ```bash
    docker compose up -d
    while ! docker logs $(docker ps -q -f "name=ldes-server$") 2> /dev/null | grep 'Cancelled mongock lock daemon' ; do sleep 1; done
    ```

3. Create LDES'es and their views using the [seed script](./server/seed/seed.sh):
    ```
    chmod +x ./server/seed/seed.sh
    sh ./server/seed/seed.sh
    ```
    > This will create the following LDES'es and views:
    ```bash
    curl http://localhost:8080/measurement-points
    curl http://localhost:8080/measurement-points/by-page
    curl http://localhost:8080/measurement-points/by-location
    curl http://localhost:8080/observations
    curl http://localhost:8080/observations/by-page
    ```

4. Start the LDIO workbench:
    ```bash
    docker compose up ldio-workbench -d
    while ! docker logs $(docker ps -q -f "name=ldio-workbench$") 2> /dev/null | grep 'Started Application in' ; do sleep 1; done
    ```
    
5. To verify, follow the LDES starting at the views:
    ```bash
    curl http://localhost:8080/measurement-points/by-page?pageNumber=1
    curl http://localhost:8080/measurement-points/by-location?tile=0/0/0
    curl http://localhost:8080/observations/by-page?pageNumber=1
    ```

6. To end:
    ```bash
    docker compose rm ldio-workbench --stop --force --volumes
    docker compose down
    ```
