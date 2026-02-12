# Create Mock Mixpanel Data from Real Dataset

Samples a subset of users and returns all their events for testing

## Usage

``` r
sample_mixpanel(df, n_users = 20, seed = 123)
```

## Arguments

- df:

  Full Mixpanel dataset (tibble)

- n_users:

  Number of distinct users to sample

- seed:

  Random seed for reproducibility

## Value

A tibble with sampled events
