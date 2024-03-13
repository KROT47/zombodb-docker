# ZomboDB Docker

ZomboDB is a Postgres extension that enables efficient full-text searching via the use of indexes backed by Elasticsearch.

This repo build a docker image which integrate ZomboDB extension with Postgres.

## Reference informations

[ZomboDB github](https://github.com/zombodb/zombodb/tree/master)

## Docker image

You can pull docker image from my docker hub [repo](https://hub.docker.com/r/dldldldl/zombodb).

```shell
docker pull dldldldl/zombodb
```

Or build your own by command:

```shell
docker build --build-arg="PG_VER=13" -t <your_tag_name> .
```

_The build argument `PG_VER` is optional, `12`, `13`, `14`, `15` are available, default value is `13`._

## Usage

- Docker container
  You can run docker container by command:

  ```shell
  docker run -e POSTGRES_PASSWORD=postgresql -p 5432:5432 -d dldldldl/zombodb
  ```

  Or by docker compose (please refer to `docker-compose.yml`).
  _Image usage please refer to [postgres](https://hub.docker.com/_/postgres)\_

- Create extension

  You should first create zombodb extension into your database.
  Sample SQL:

  ```sql
  CREATE EXTENSION zombodb;
  ```

- Create table with index

  Create table sample SQL:

  ```sql
  CREATE TABLE sample_table (
    id serial,
    content zdb.fulltext NOT NULL, -- column with `zdb.fulltext` type
    timstamp timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
  );
  ```

  Create index sample SQL:

  ```sql
  CREATE INDEX idx_sample_table
    ON sample_table
    USING zombodb ((sample_table.*))
    WITH (url='http://elasticsearch:9200/')
  ```

  _Notice that if your Elasticsearch server required user auth, you can pass username/password in URL format like `http://username:password@elasticsearch:9200/`_

- Query data with full-text search

  Sample SQL:

  ```sql
  SELECT * FROM sample_table WHERE sample_table ==> 'some keywords';
  ```
