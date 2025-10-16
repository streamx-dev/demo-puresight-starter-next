# PureSight & WKND in Dockerized AEM

The steps below show how to run locally an AEMaaCS image that has embedded PureSight, WKND, and the AEM Connector.

1. Build the `aem-author-cloud` Docker image as described in the https://github.com/streamx-dev/demo-puresight-aem/blob/main/README.md.

1. Run the Docker container with `./sources/start-aem.sh` script.

   You can optionally pass a **StreamX client URL** as the first argument and a **StreamX client auth token** as the second argument.  
   - If the second argument is not provided, it defaults to an empty token (no authentication is attempted).  
   - You can also **explicitly** pass an empty token by placing `""` as the second argument.
   - When running together with apisix make sure you connect the network 
   ```bash
   docker network connect docker-apisix_apisix aem-author-cloud  >/dev/null 2>&1
   ```


   **Examples:**
   ```bash
   # Run with the default URL and default token (default toke is empty)
   ./sources/start-aem.sh
   
   # Pass URL only, token is empty by default
   ./sources/start-aem.sh http://host.docker.internal:8080

   # Pass both URL and token
   ./sources/start-aem.sh https://my-streamx.example.com ABCD1234567

   # Pass a URL and an explicit empty token
   ./sources/start-aem.sh https://my-streamx.example.com ""
   ```

1. Once the AEM instance is running, it is accessible at:  
   ```text
   http://localhost:4502
   ```

1. To run a related StreamX instance that will be used by the AEM, refer to the main [README](../README.md).
