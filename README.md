# An example of [immunopipe][1]

You need to clone this repository to run the example.

```bash
> git clone https://github.com/pwwang/immunopipe-example

# cd immunopipe-example/
```

## Preparing the data

```bash
> bash prepare-data.sh

# The data from GSE139555 (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE139555)
# will be downloaded and extracted into:
#
#   ./prepared-data/LN1
#   ./prepared-data/LN2
#   ...
#
# Only first 12 samples (LN, LT) are used.
```

## Running the example with immunopipe install locally:

```bash
> immunopipe --config config-local.toml
```

## Running the example using docker

```bash
> docker run \
    -w /immunopipe/workdir \
    -v $(pwd)/:/immunopipe/workdir \
    -v /tmp \
    -v $(pwd)/prepared-data:/mnt \
    --rm -it \
    justold/immunopipe:dev \
    --config config.toml
```

## Running the example using singularity

```bash
> singularity run \
    -c -e -w --pwd /immunopipe/workdir \
    -B .:/immunopipe/workdir,prepared-data/:/mnt,/tmp \
    docker://justold/immunopipe:dev \
    --config config.toml
```

## Checking out the reports

https://pwwang.github.io/immunopipe-example/output/REPORTS/

[1]: https://github.com/pwwang/immunopipe
