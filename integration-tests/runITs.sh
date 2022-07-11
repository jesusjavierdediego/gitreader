#!/bin/bash

if [[ -f "gitea" ]]
then
    echo "The test IT Git repo DOES NOT EXIST in the filesystem. The Integration Test is not possible"
else
    echo "GIT READER integration tests start"
    docker-compose up -d
    echo "Docker containers for ITs ready."
    sleep 10
    sh prepareTests.sh
    sh pushgitexamples.sh
    echo "Preparation to tests OK"
    echo "Integration tests start"
    # PROFILE=dev go test xqledger/gitreader/apilogger -v 
    # PROFILE=dev go test xqledger/gitreader/configuration -v 
    # PROFILE=dev go test xqledger/gitreader/utils -v
    # PROFILE=dev go test xqledger/gitreader/grpc -v 
    # PROFILE=dev go test xqledger/gitreader/askgit -v
    PROFILE=dev go test xqledger/gitreader/apilogger -v 2>&1 | go-junit-report > ../testreports/apilogger.xml
    PROFILE=dev go test xqledger/gitreader/configuration -v 2>&1 | go-junit-report > ../testreports/configuration.xml
    PROFILE=dev go test xqledger/gitreader/utils -v 2>&1 | go-junit-report > ../testreports/utils.xml
    PROFILE=dev go test xqledger/gitreader/grpc -v 2>&1 | go-junit-report > ../testreports/grpc.xml
    PROFILE=dev go test xqledger/gitreader/askgit -v 2>&1 | go-junit-report > ../testreports/askgit.xml
    echo "Integration tests complete"
    echo "Cleaning up..."
    cd ../integration-tests
    docker-compose down
    echo "Clean up complete. Bye!"
fi