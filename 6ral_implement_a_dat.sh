#!/bin/bash

# Config variables
PIPELINE_CONFIG_FILE="pipeline_config.json"
DATA_SOURCE_DIR="/data/source"
DATA_DEST_DIR="/data/destination"
LOG_DIR="/logs"

# Functions
parse_config() {
  local config_file=$1
  local pipeline_config=$(jq '.pipeline' $config_file)
  local data_sources=$(jq '.data_sources[] | .name' $config_file)
  local data_transforms=$(jq '.data_transforms[] | .name' $config_file)

  echo "Pipeline Config: $pipeline_config"
  echo "Data Sources: ${data_sources[@]}"
  echo "Data Transforms: ${data_transforms[@]}"
}

parse_data() {
  local data_source=$1
  local data_file=$DATA_SOURCE_DIR/$data_source

  # Parse data using AWK
  awk '{print $1,$3}' $data_file > $DATA_DEST_DIR/$data_source
}

main() {
  # Load pipeline config
  parse_config $PIPELINE_CONFIG_FILE

  # Parse data sources
  for data_source in $(jq '.data_sources[] | .name' $PIPELINE_CONFIG_FILE); do
    parse_data $data_source
  done
}

# Run pipeline
main