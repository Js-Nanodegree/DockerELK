# DockerELK

When using in a `docker-compose.yml` file, use the following settings:

```
ports:
  - 5601:5601
environment:
  - ES_PASSWORD=password_for_elastic_user
```
