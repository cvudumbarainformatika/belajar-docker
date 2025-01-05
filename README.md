## Setup local
1) Copy environments
```sh
cp .env.example .env
```
2) Add current user identity data to environments
```sh
echo UID=$(id -u) >> .env
echo GID=$(id -g) >> .env
```
3) Run docker
```sh
docker compose up -d --build
```
4) Make cache dirs for package managers
```sh
docker compose exec -u root app install -o $(id -u) -g $(id -g) -d "/.npm" &&
docker compose exec -u root app install -o $(id -u) -g $(id -g) -d "/.composer"
```
5) Install composer dependency
```sh 
docker compose exec app composer install
```
6) Install npm dependency
```sh 
docker compose exec app npm i
```
7) Generate app key
```sh 
docker compose exec app php artisan key:generate
```
8) #if services still unhealthy - restart docker
```sh 
docker compose up -d --build
```

### Entry points
* [http://localhost/](http://localhost/) - application
* [http://localhost/horizon](http://localhost/horizon) - queue manager