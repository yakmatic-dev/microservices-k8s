#!/bin/bash

# List of image names
IMAGES=(
  cartservice
  adservice
  checkoutservice
  currencyservice
  emailservice
  frontend
  paymentservice
  productcatalogservice
  recommendationservice
  shippingservice
  shoppingassistantservice
)

DOCKER_USER=yakub363
TAG=v1.0

for IMAGE in "${IMAGES[@]}"; do
  echo "Pushing ${IMAGE}..."

  sudo docker tag yakub/${IMAGE}:${TAG} ${DOCKER_USER}/${IMAGE}:${TAG}
  sudo docker push ${DOCKER_USER}/${IMAGE}:${TAG}

  if [ $? -ne 0 ]; then
    echo "Push failed for ${IMAGE}. Restarting Docker and retrying..."
    sudo systemctl restart docker

    sleep 10

    echo "Retrying push for ${IMAGE}..."
    sudo docker push ${DOCKER_USER}/${IMAGE}:${TAG}

    if [ $? -ne 0 ]; then
      echo "Push failed again for ${IMAGE}, skipping to next."
    else
      echo "Successfully pushed ${IMAGE} after Docker restart."
    fi
  else
    echo "Successfully pushed ${IMAGE}."
  fi

  echo
done

