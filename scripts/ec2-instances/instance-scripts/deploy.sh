#!/bin/bash
function deploy {
    sudo docker stop petclinic-container | echo
    sudo docker rm petclinic-container | echo
    sudo docker rmi $(sudo docker images -q 050376771752.dkr.ecr.us-east-1.amazonaws.com/ecr-repo)
    aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin 050376771752.dkr.ecr.us-east-1.amazonaws.com
    latestTag=$1
    sudo docker run --name petclinic-container -p 8080:8080 -d 050376771752.dkr.ecr.us-east-1.amazonaws.com/ecr-repo:$latestTag
    controlTag=$(python3 /home/ubuntu/instance-scripts/latestTag.py)
    if ! [[ $latestTag == $controlTag ]]; then
        deploy $controlTag
    fi
}

deploy $1