echo 'Pulling the latest image'
sudo docker-compose pull

echo 'Re-starting the container'
sudo docker-compose up --build -d
