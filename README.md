# An example of [immunopipe][1]

You need to clone this repository to run the example.

```bash
> git clone https://github.com/pwwang/immunopipe
```

## Preparing the data

```bash
> bash prepare-data.sh
```

## Running the example with immunopipe install locally:

```bash
> immunopipe --config config-local.toml
```

## Running the example using docker

```bash
> docker run \
    -w /workdir \
    -v $(pwd)/:/workdir \
    -v /tmp \
    -v $(pwd)/prepared-data:/mnt \
    justold/immunopipe:<tag> \
    --config config.toml
```

## Checking out the reports

https://pwwang.github.io/immunopipe-example/

[1]: https://github.com/pwwang/immunopipe
